using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using P01R01_Cafeteria.Models;
using P01R01_Cafeteria.Models.Dtos.Producto;
using P01R01_Cafeteria.Context;
using P01R01_Cafeteria.Services;
using Microsoft.Data.SqlClient;
using P01R01_Cafeteria.Models.Dtos;

[Route("api/[controller]")]
[ApiController]
public class ProductosController : ControllerBase
{
    private readonly AppBdContext _context;
    private readonly ProductoService _producto;
    public ProductosController(AppBdContext context, ProductoService producto)
    {
        _context = context;
        _producto = producto;
    }

    // GET: api/Productos
    [HttpGet("Paged", Name = "GetProductsInPages")]
    public async Task<ActionResult<PageResult<Productos_Bd>>> GetProductos_Bd(
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 10,
        [FromQuery] string? searchText = null,
        CancellationToken cancellationToken = default // Se cancela si el frontend aborta la petición
        )
    {

        //Validaciones
        if (pageNumber < 1 || pageSize < 1)
        {
            return BadRequest("Los parámetros de paginación no son válidos");
        }

        // Limitamos la paginación para que nunca sea mayor que 100
        pageSize = Math.Min(pageSize, 100);

        // Creo mi consulta
        var query = _context.Productos.AsNoTracking();
        int totalCount;
        //Validamos el searchText
        if (!string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(p => p.Nombre.StartsWith(searchText));
            totalCount = await query.CountAsync(cancellationToken);
        }
        else
        {
            // Sin filtro: el total sale de los metadatos de la tabla,
            // sin recorrer el millón de filas en cada petición
            totalCount = await _context.Database
                .SqlQueryRaw<int>(@"SELECT CAST(SUM(p.rows) AS int) AS Value
                                FROM sys.partitions p
                                WHERE p.object_id = OBJECT_ID('dbo.Productos')
                                  AND p.index_id IN (0, 1)")
                .SingleAsync(cancellationToken);
        }

        //Ordenamos el resultado
        var productos = await query
            .OrderBy(p => p.ProductoID)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);


        return Ok(new PageResult<Productos_Bd>
        {
            Items = productos,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = totalCount,

        });
    }

    // GET: api/Productos/5
    [HttpGet("{productoid}")]
    public async Task<ActionResult<Productos_Bd>> GetProductos_Bd(int productoid)
    {
        var productos_bd = await _context.Productos.FindAsync(productoid);

        if (productos_bd == null)
        {
            return NotFound();
        }

        return productos_bd;
    }

    // PUT: api/Productos/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{productoid}")]
    public async Task<IActionResult> PutProductos_Bd(int productoid, Productos_Bd productos_bd)
    {
        if (productoid != productos_bd.ProductoID)
        {
            return BadRequest();
        }

        _context.Entry(productos_bd).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!Productos_BdExists(productoid))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    // POST: api/Productos
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost]
    public async Task<ActionResult<Productos_Bd>> PostProductos_Bd(CreateProductDto createProductoDto)
    {
        try
        {
           var id = await _producto.CrearAsync(createProductoDto);
            return CreatedAtAction(nameof(GetProductos_Bd), new { productid = id}, new {productoId = id});
        }
        catch (SqlException ex) when (ex.Number >= 50000) 
        {
            return BadRequest();
        }

    }

    // DELETE: api/Productos/5
    [HttpDelete("{productoid}")]
    public async Task<IActionResult> DeleteProductos_Bd(int? productoid)
    {
        var productos_bd = await _context.Productos.FindAsync(productoid);
        if (productos_bd == null)
        {
            return NotFound();
        }

        _context.Productos.Remove(productos_bd);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool Productos_BdExists(int? productoid)
    {
        return _context.Productos.Any(e => e.ProductoID == productoid);
    }
}
