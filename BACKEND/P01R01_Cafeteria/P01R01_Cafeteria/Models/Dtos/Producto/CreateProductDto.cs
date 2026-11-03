using P01R01_Cafeteria.Models.Enums;
using System.ComponentModel.DataAnnotations;

namespace P01R01_Cafeteria.Models.Dtos.Producto
{
    public class CreateProductDto
    {
        [Required]
        [StringLength(100)]
        public string Nombre { get; set; } = string.Empty;
        [EnumDataType(typeof(CategoriaProducto))]
        public CategoriaProducto Categoria { get; set; }
        [Range(0,100000000)]
        public decimal Precio { get; set; }
        [Range(0,100000000)]
        public int Stock { get; set; }
    }
}
