using P01R01_Cafeteria.Models.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01R01_Cafeteria.Models
{
    [Table("Productos")]
    public class Productos_Bd
    {
        [Key]
        public int ProductoID { get; set; }
        [Required]
        [StringLength(100)]
        public string Nombre { get; set; } = string.Empty;
        [EnumDataType(typeof(CategoriaProducto))]
        public CategoriaProducto Categoria { get; set; }
        [Required]
        [Column(TypeName = "decimal(10,2)")]
        public decimal Precio { get; set; }
        [Required]
        public int Stock { get; set; }
        public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;


    }// Fin de la clase
}// Fin del namespace
