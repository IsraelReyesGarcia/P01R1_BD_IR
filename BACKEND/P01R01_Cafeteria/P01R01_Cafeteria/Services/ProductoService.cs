using P01R01_Cafeteria.Context;
using P01R01_Cafeteria.Models.Dtos.Producto;
using Microsoft.EntityFrameworkCore;
using System.Data;
using Microsoft.Data.SqlClient;

namespace P01R01_Cafeteria.Services
{
    public class ProductoService
    {
        private readonly AppBdContext _context;

        public ProductoService(AppBdContext context)
        {
            _context = context;
        }

        public async Task<int> CrearAsync(CreateProductDto dto)
        {
            var pNombre     = new SqlParameter("@Nombre", dto.Nombre);
            var pCategoria  = new SqlParameter("@Categoria", dto.Categoria.ToString());
            var pPrecio     = new SqlParameter("@Precio", dto.Precio);
            var pStock      = new SqlParameter("@Stock", dto.Stock);
            var pNuevoID    = new SqlParameter("@NuevoID", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output,
            };

            await _context.Database.ExecuteSqlRawAsync(
                "EXEC dbo.spProductos_Insertar @Nombre, @Categoria, @Precio, @Stock, @NuevoID OUTPUT",
                pNombre, pCategoria, pPrecio, pStock, pNuevoID
                );

            return (int)pNuevoID.Value;
        }
    }
}
