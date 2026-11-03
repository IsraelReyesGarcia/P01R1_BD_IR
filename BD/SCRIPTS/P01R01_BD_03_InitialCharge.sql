USE GenNov
GO

/*
PROYECTO: P01R01_DB_IR
AUTOR: ISRAEL REYES
FECHA: 20261027
Description: Carga Inicial
*/

INSERT INTO productos(Nombre, Categoria, Precio,Stock)
VALUES ('CAFE AMERICANO','BEBIDAS', 20.5, 5),
	   ('Capuchino', 'Bebidas', 45.00, 100),
	   ('Croissant', 'Panaderia', 25.00,50)
	  GO

INSERT INTO Productos(Nombre, Categoria, Precio, Stock)
VALUES ('Pan de concha', 'Panaderia', 10.00, 200),
	   ('Pan de canela', 'Panaderia', 60.00, 100)
GO

INSERT INTO Clientes (Nombre, Email, Telefono)
VALUES ('Juan Pérez', 'juan@gmail.com', '5534576894'),
	('Pamela', 'pamela@gmail.com', '9671245786')
	GO


INSERT INTO Pedidos (ClienteId, Total, Estado)
VALUES (1, 125.50, 'Completado')
GO