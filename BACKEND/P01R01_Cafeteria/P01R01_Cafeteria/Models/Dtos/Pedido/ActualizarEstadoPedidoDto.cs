using P01R01_Cafeteria.Models.Enums;
using System.ComponentModel.DataAnnotations;

namespace P01R01_Cafeteria.Models.Dtos.Pedido
{
    public class ActualizarEstadoPedidoDto
    {
        [EnumDataType(typeof(EstadoPedido), ErrorMessage = "El estado no es válido")]
        public EstadoPedido Estado { get; set; }
    }
}
