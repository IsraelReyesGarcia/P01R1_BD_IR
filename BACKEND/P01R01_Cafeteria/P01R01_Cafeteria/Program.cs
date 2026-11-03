using Microsoft.EntityFrameworkCore;
using P01R01_Cafeteria.Context;
using P01R01_Cafeteria.Services;
var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("Conexion") ?? throw new InvalidOperationException("Connection string 'AppBdContext' not found.");

builder.Services.AddDbContext<AppBdContext>(options => options.UseSqlServer(connectionString));
builder.Services.AddScoped<ProductoService>();
// Add services to the container.

builder.Services.AddControllers();
// Agregar políticas de CORS
builder.Services.AddCors(options =>
    options.AddPolicy("AllowReact", policy =>
    {
        policy.WithOrigins("http://localhost:3000", "http://localhost:5173")
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials(); // Necesario para el WidthCredentials de Axios
    })
);

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowReact");
app.UseAuthorization();

app.MapControllers();

app.Run();
