USE GenNov
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECCHA: 20261028
DESCRIPCIÓN: CREACIÓN DE TABLAS TEMPORALES
*/

DECLARE @Productos TABLE(
	ProductoID INT, -- Le estas danto Identidad Referencial
	Nombre NVARCHAR(100),
	Categoria NVARCHAR(50),
	Precio DECIMAL(10,2),
	Stock INT DEFAULT 0,
	FechaCreacion DATETIME DEFAULT GETDATE()
)

INSERT INTO @Productos (Nombre, Categoria, Precio, Stock) VALUES(N'Jugo de naranja', N'Bebida',15.00, 30);

SELECT * FROM @Productos;

DECLARE
@Clientes TABLE(
	ClienteID INT,
	Nombre NVARCHAR(100),
	Email NVARCHAR(100),
	Telefono NVARCHAR(15)
)

INSERT INTO @Clientes (Nombre, Email, Telefono) VALUES('Miguel Contréras','miguelc@gmail.com','2345673452')
SELECT * FROM @Clientes;


DECLARE 
@Pedidos TABLE(
	PedidoID INT,
	ClienteID INT,
	Fecha DATETIME DEFAULT GETDATE(),
	Total DECIMAL(10,2),
	Estado NVARCHAR(20) DEFAULT 'Pendientes'
)

INSERT INTO @Pedidos (ClienteID, Fecha,Total) VALUES(2, GETDATE(),150.00);
SELECT * FROM @Pedidos;
