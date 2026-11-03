using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01R01_Cafeteria.Models
{
    [Table("Clientes")]
    public class Clientes_Bd
    {
        [Key]
        public int ClienteID { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
    }

}
