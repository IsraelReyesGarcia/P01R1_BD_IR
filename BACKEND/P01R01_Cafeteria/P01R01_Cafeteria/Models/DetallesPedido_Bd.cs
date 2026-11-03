using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace P01R01_Cafeteria.Models
{
    [Table("DetallesPedido")]
    public class DetallesPedido_Bd
    {
        [Key]
        public int DetalleID { get; set; }
        public int PedidoID { get; set; }
        [JsonIgnore]//Evita que traiga que pedidos traiga sus detalles que a su vez tiene pedidos y se haga un bucle
        public Pedidos_Bd? Pedido { get; set; }
        public int ProductoID { get; set; }
        public int ClienteID { get; set; }
        [JsonIgnore]
        public Clientes_Bd? Cliente { get; set; }
        public int Cantidad { get; set; }
        [Column(TypeName= "decimal(10,2)")]
        public decimal PrecioUnitario { get; set; } 
    }
}
