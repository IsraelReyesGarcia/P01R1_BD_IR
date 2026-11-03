using P01R01_Cafeteria.Models.Enums;
using System.ComponentModel.DataAnnotations;

namespace P01R01_Cafeteria.Models.Dtos.Pedido
{
    public class CrearPedidoDto
    {
        [Range(1, int.MaxValue, ErrorMessage = "El cliente es obligatorio")]
        public int ClienteID { get; set; }

        [MinLength(1, ErrorMessage = "El pedido debe tener al menos un producto")]
        public List<ProductoPedidoDto> Productos { get; set; } = new();

        [EnumDataType(typeof(EstadoPedido))]
        public EstadoPedido Estado { get; set; }
    }
}
