using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using P01R01_Cafeteria.Context;
using P01R01_Cafeteria.Models;
using P01R01_Cafeteria.Models.Dtos;
using P01R01_Cafeteria.Models.Dtos.Pedido;
using P01R01_Cafeteria.Models.Enums;

namespace P01R01_Cafeteria.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PedidosController : ControllerBase
    {
        private readonly AppBdContext _context;

        public PedidosController(AppBdContext context)
        {
            _context = context;
        }

        [HttpGet("Paged", Name ="GetPedidosInPage")]
        public async Task<ActionResult<PageResult<Pedidos_Bd>>> GetPedidosInPage(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 10,
            [FromQuery] EstadoPedido? status = null
            )
        {
            //Creamos la validaciones
            if(pageNumber < 1 || pageSize < 1)
            {
                return BadRequest("Los parámetros de paginación no son válidos");
            }

            if(status.HasValue && !Enum.IsDefined(status.Value))
            {
                return BadRequest("El estado no es válido");
            }

            pageSize = Math.Min(pageSize, 100);
            var query = _context.Pedidos.AsNoTracking(); //Creo mi consulta pero aún no la ejecuto

            if (status.HasValue)
            {
                query = query.Where(p => p.Estado == status.Value);
            }

            // Contar
            var totalCount = await query.CountAsync();

            // Ordenar
            /*var items = await query
                .OrderByDescending(c => c.Fecha)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();*/
            var items = await query
                .OrderByDescending(p => p.Fecha)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .Select(p => new PedidoListDto
                {
                    PedidoID = p.PedidoID,
                    ClienteID = p.ClienteID,
                    ClienteNombre = p.Cliente != null ? p.Cliente.Nombre : string.Empty,
                    Fecha = p.Fecha,
                    Total = p.Total,
                    Estado = p.Estado
                })
                .ToListAsync();

            return Ok(new PageResult<PedidoListDto>
            {
                Items       = items,
                PageNumber  = pageNumber,
                PageSize    = pageSize,
                TotalCount  = totalCount
            });
        }

        [HttpGet("{pedidoid}")]
        public async Task<ActionResult<Pedidos_Bd>> GetPedidoBd(int pedidoid)
        {
            var pedido_bd = await _context.Pedidos.FindAsync(pedidoid);
            if (pedido_bd == null)
            {
                return NotFound("El pedido no existe");
            }

            return Ok(pedido_bd);
        }

        [HttpPost]
        public async Task<ActionResult<Pedidos_Bd>> CreatePedidoDb(CrearPedidoDto dto)
        {
            // 1. ¿Existe el cliente?
            if (!await _context.Clientes.AnyAsync(c => c.ClienteID == dto.ClienteID))
                return BadRequest("El cliente no existe");

            // 2. Traer todos los productos en UNA consulta
            var ids = dto.Productos.Select(p => p.ProductoID).Distinct().ToList();
            var productosBd = await _context.Productos
                .Where(p => ids.Contains(p.ProductoID))
                .ToDictionaryAsync(p => p.ProductoID);

            // 3. ¿Existen todos?
            var faltantes = ids.Where(id => !productosBd.ContainsKey(id)).ToList();
            if (faltantes.Any())
                return BadRequest($"Productos inexistentes: {string.Join(", ", faltantes)}");

            // 4. Crear el pedido en memoria
            var pedido = new Pedidos_Bd
            {
                ClienteID = dto.ClienteID,
                Estado    = dto.Estado
            };

            // 5. Validar Stock, calcula el total y arma los detalles (en memoria, sin consultas)
            decimal total = 0;
            foreach (var item in dto.Productos)
            {
                var producto = productosBd[item.ProductoID];

                if (producto.Stock < item.Cantidad)
                    return BadRequest($"Stock insuficiente de {producto.Nombre} (disponible: {producto.Stock})");

                total += producto.Precio * item.Cantidad;
                producto.Stock -= item.Cantidad;   // EF Core lo rastrea → UPDATE al guardar

                pedido.Detalles.Add(new DetallesPedido_Bd
                {
                    ProductoID  = item.ProductoID,
                    ClienteID   = dto.ClienteID,
                    Cantidad    = item.Cantidad, 
                    PrecioUnitario = producto.Precio    // precio congelado al momento de la venta
                    //PedidoID NO se asigna: EF Core lo pone después de insertar el pedido
                });
            }

            pedido.Total = total; 
            _context.Pedidos.Add(pedido); // Agrega el pedido y sus detalles

            // 6. Un solo SaveChanges: INSERT del pedido + UPDATE de los stocks, en una transacción
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetPedidoBd), new { pedidoid = pedido.PedidoID }, pedido);
        }

        [HttpPut("{pedidoid}")]
        public async Task<ActionResult<Pedidos_Bd>> UpdatePedido_Bd(int pedidoid, Pedidos_Bd pedido)
        {
            if(pedidoid != pedido.PedidoID)
            {
                return BadRequest("El pedido a actualizar esta incorrecto");
            }

            _context.Entry(pedido).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch
            {
                if (!Pedido_BdExist(pedidoid))
                {
                    return NotFound("No se encontró este pedido");
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPatch("{pedidoid}/estado")]
        public async Task<ActionResult> UpdateEstadoPedido(int pedidoid, ActualizarEstadoPedidoDto dto)
        {
            var pedido = await _context.Pedidos.FindAsync(pedidoid);
            if(pedido == null)
            {
                return NotFound("No se encontró el pedido");
            }

            pedido.Estado = dto.Estado; // EF Solo actualiza esa columna
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{pedidoid}")]
        public async Task<ActionResult> DeletePedido_Bd(int pedidoid)
        {
            var pedido = await _context.Pedidos.FindAsync(pedidoid);
            if(pedido == null)
            {
                return NotFound("No se encontró el pedido");
            }

            _context.Pedidos.Remove(pedido);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        private bool Pedido_BdExist(int? pedidoId)
        {
            return _context.Pedidos.Any(p => p.PedidoID == pedidoId);
        }
    }
}
