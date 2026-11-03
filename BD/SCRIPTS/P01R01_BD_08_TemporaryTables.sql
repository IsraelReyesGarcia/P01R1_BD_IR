USE GenNov
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: CREACIÓN DE LAS TEMPORARY TABLES

Temporary Table: Tablas que viven en tiempo de sesión del servidor y una vez finalizada la sesión, estas tablas desaparecen con todo y registros
*/

-- Se utilizan para permormance
CREATE TABLE #Productos(
	ProductoID INT PRIMARY KEY,
	Nombre NVARCHAR(150),
	Categoria NVARCHAR(120),
	Precio DECIMAL(10,2),
	Stock INT DEFAULT 0,
	FechaCreacion DATETIME DEFAULT GETDATE()
)

-- DROP TABLE #Productos;

INSERT INTO #Productos (ProductoID,Nombre, Categoria, Precio, Stock, FechaCreacion) VALUES(1,'Capuchino','Bebida',20.00,30,GETDATE());
SELECT * FROM #Productos;