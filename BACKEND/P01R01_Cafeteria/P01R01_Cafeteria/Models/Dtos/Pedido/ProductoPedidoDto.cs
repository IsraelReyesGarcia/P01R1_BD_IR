using System.ComponentModel.DataAnnotations;

namespace P01R01_Cafeteria.Models.Dtos.Pedido
{
    public class ProductoPedidoDto
    {
        public int ProductoID { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "La cantidad debe ser mayor a 0")]
        public int Cantidad { get; set; }
        //public decimal PrecioUnitario { get; set; }

    }
}
