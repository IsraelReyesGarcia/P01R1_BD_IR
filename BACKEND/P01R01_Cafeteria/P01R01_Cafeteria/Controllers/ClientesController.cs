using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using P01R01_Cafeteria.Context;
using P01R01_Cafeteria.Models;
using P01R01_Cafeteria.Models.Dtos;

namespace P01R01_Cafeteria.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClientesController : ControllerBase
    {
        private readonly AppBdContext _context;

        public ClientesController(AppBdContext context)
        {
            _context = context;
        }

        // Get: api/Clientes
        [HttpGet("Paged", Name = "GetClientsInPages")]
        public async Task<ActionResult<PageResult<Clientes_Bd>>> GetClientsInPages(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 10,
            [FromQuery] string? searchText = null
            )
        {
            if (pageNumber < 1 || pageSize < 1)
            {
                return BadRequest("Los parámetros de paginación no son válidos");
            }

            pageSize = Math.Min(pageSize, 100); // Obligamos a que no pidan más de 100

            // 1. Armar la consulta (Aún no se consulta)
            var query = _context.Clientes.AsNoTracking(); // Armas tu consulta: SELECT * FROM Clientes
            //AsNoTracking: Solo voy a leer
            // Como sabemos; cada objeto que traemos de la base de datos queda rastreado(EF Core) 
            // guarda un copia de sus valores originales para detectar cambios cuando llames a SaveChanges()
            //Con AskNoTracking() le dices: Estos datos son solo para mostrarlos; no los voy a modificar, así que no los rastrees
            //Se recomienda su uso únicamnete en operaciones de consulta
            // 2. Filtro opcional
            if (!string.IsNullOrWhiteSpace(searchText))
            {
                query = query.Where(c => c.Nombre.Contains(searchText) || c.Email.Contains(searchText));
            }

            // 3. Contal el total (con el filtro) -> SELECT COUNT(*)
            var totalCount = await query.CountAsync();

            // 4. Ordernar y cortar la página -> SELECT ... ORDER BY ... OFFSET ... FETCH NEXT ...
            var items = await query
                .OrderBy(c => c.ClienteID)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync(); // Aquí se ejecuta todo junto

            return Ok(new PageResult<Clientes_Bd>
            {
                Items        = items,
                PageNumber   = pageNumber,
                PageSize     = pageSize,
                TotalCount   = totalCount
            });
        }

        //Get: api/Clientes/1
        [HttpGet("{clienteid}")]
        public async Task<ActionResult<Clientes_Bd>> GetClientes_Bd(int clienteid)
        {
            var cliente_bd = await _context.Clientes.FindAsync(clienteid);
            if(cliente_bd == null)
            {
                return NotFound("No se encontró un cliente con este id");
            }

            return cliente_bd;
        }

        // PUT: api/clientes/4
        [HttpPut("{clienteid}")]
        public async Task<ActionResult<Clientes_Bd>> UpdateCliente_Bd(int clienteid,Clientes_Bd cliente)
        {
            if(clienteid != cliente.ClienteID)
            {
                return BadRequest();
            }

            _context.Entry(cliente).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch
            {
                if (!Clientes_BdExists(clienteid))
                {
                    return NotFound("Este cliente no se pudo encontrar");
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Clientes
        [HttpPost]
        public async Task<ActionResult<Clientes_Bd>> PostCliente_Bd(Clientes_Bd cliente)
        {
           _context.Clientes.Add(cliente); // EF Core le da a mi objeto un estado de Added aún no de INSERT
            await _context.SaveChangesAsync(); // Aquí es donde se ejecuta el INSERT

            // Cuando se haya generado el INSERT, EF Core llena cliente.ClienteID con el IDENTITY que generó SQL Server
            return CreatedAtAction(nameof(GetClientes_Bd), new { clienteid = cliente.ClienteID }, cliente);
        }

        // DELETE: api/Clientes
        [HttpDelete("{clienteId}")]
        public async Task<ActionResult> DeleteClliente_Bd(int? clienteId)
        {
            var cliente = await _context.Clientes.FindAsync(clienteId);
            if (cliente == null)
            {
                return NotFound("No se encontró el cliente");
            }

            _context.Clientes.Remove(cliente); //Marca el cliente con un estado de DELETED
            await _context.SaveChangesAsync(); // Aolica los cambios y elimina el registro de la base de datos
            return NoContent();
        }

        private bool Clientes_BdExists(int? clienteid)
        {
            return _context.Clientes.Any(e => e.ClienteID == clienteid);
        }
    }
}
