using P01R01_Cafeteria.Models.Enums;

namespace P01R01_Cafeteria.Models.Dtos.Pedido
{
    public class PedidoListDto
    {
        public int PedidoID { get; set; }
        public int ClienteID { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public DateTime Fecha { get; set; }
        public decimal Total { get; set; }
        public EstadoPedido Estado { get; set; }
    }
}
