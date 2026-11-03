using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace P01R01_Cafeteria.Models
{
    [Table("AuditoriaProductos")]
    public class AuditoriaProductos_Bd
    {
        [Key]
        public int AuditoriaID { get; set; } 
        public int ProductoID { get; set; }
        [JsonIgnore]
        public string Accion { get; set; } = string.Empty;
        [Column(TypeName = "decimal(10,2)")]
        public decimal PrecioAnterior { get; set; }
        [Column(TypeName = "decimal(10,2)")]
        public decimal PrecioNuevo { get; set; }
        public string Usuario { get; set; } = string.Empty;
    }
}
