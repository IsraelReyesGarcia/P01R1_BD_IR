namespace P01R01_Cafeteria.Models.Dtos
{
    public class PageResult<T>
    {
        public List<T> Items { get; set; } = new();
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; } // Total de registros (con el filtro aplicado)
        public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
    }
}
