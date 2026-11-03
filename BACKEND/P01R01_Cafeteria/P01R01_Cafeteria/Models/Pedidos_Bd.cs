using P01R01_Cafeteria.Models.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01R01_Cafeteria.Models
{
    [Table("Pedidos")]
    public class Pedidos_Bd
    {
        [Key]
        public int PedidoID { get; set; }

        public int ClienteID { get; set; } // La llave foranea
        [ForeignKey(nameof(ClienteID))]
        public Clientes_Bd? Cliente { get; set; } // El objeto relacionado

        public DateTime Fecha { get; set; } = DateTime.Now;

        [Column(TypeName = "decimal(10,2)")]
        public decimal Total { get; set; }

        [EnumDataType(typeof(EstadoPedido))]
        public EstadoPedido Estado { get; set; }

        public List<DetallesPedido_Bd> Detalles { get; set; } = new();
    }
}
