using Microsoft.EntityFrameworkCore;
using P01R01_Cafeteria.Models;

namespace P01R01_Cafeteria.Context
{
    // El BDContext es la sesión de la base de datos
    // Cada DnSet<T> representa una tabla que puedes consultar con LINQ
    public class AppBdContext: DbContext
    {
        public AppBdContext(DbContextOptions<AppBdContext> options): base(options) { }

        public DbSet<Productos_Bd> Productos {  get; set; }
        public DbSet<Clientes_Bd> Clientes { get; set; }
        public DbSet<Pedidos_Bd> Pedidos { get; set; }
        public DbSet<DetallesPedido_Bd> DetallesPedido { get; set; }
        public DbSet<AuditoriaProductos_Bd> Auditoria { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // La columna Categoria es NVARCHAR en SQL: guarda y lee el enum como texto
            modelBuilder.Entity<Productos_Bd>() // Es como decir "Voy a configurar la entidad Productos_Bd"
                    .Property(p => p.Categoria) // Elijes la propiedad a congiruar: "de un producto p, la propiedad Categoria"
                    .HasConversion<string>(); // Le dices: al guardar convierte el enum en texto (Bebida -> 'Bebida', )

            modelBuilder.Entity<Pedidos_Bd>()
                    .Property(p => p.Estado)
                    .HasConversion<string>();
        }

    }
}
