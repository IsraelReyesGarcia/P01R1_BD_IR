USE GenNov
GO
/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261027
DESCRIPCION: CREACIÓN DE TRIGGERS
*/
-- AFTER UPDATE
CREATE OR ALTER TRIGGER TR_AuditarCambioPrecio
ON Productos 
--Nombre de la tabla a auditar
AFTER UPDATE
AS
BEGIN
	IF UPDATE(Precio)
	BEGIN
		INSERT INTO AuditoriaProductos
		(ProductoID, Accion, PrecioAnterior, PrecioNuevo, Usuario)
		SELECT 
			d.ProductoID, 'UPDATE', d.Precio, i.Precio, SYSTEM_USER --Obtiene el usuario de la base de datos actual
			FROM deleted AS d -- Te permite acceder a una tabla temporal para poder acceder al precio antes de que sea modificado
			INNER JOIN inserted AS i
			ON
			d.ProductoID = i.ProductoID
			END
END
GO

-- INSTEAD OF UPDATE
-- ESCRIBIR EL CODIGO DE LOS OTROS 5 TRIGGER
CREATE OR ALTER TRIGGER TR_ValidarPrecioInsteadOfUpdate
ON Productos
INSTEAD OF UPDATE 
AS
BEGIN
IF EXISTS (SELECT 1 FROM inserted WHERE Precio <= 0)
	BEGIN
		THROW 50001, 'El precio debe ser mayor a cero.',1;
END
-- Si pasa la validación, hacemos nosotros el UPDATE que se canceló
UPDATE P
SET
	p.Nombre = i.Nombre,
	p.Categoria = i.Categoria,
	p.Precio = i.Precio,
	p.Stock = i.Stock,
	p.FechaCreacion = i.FechaCreacion
	FROM Productos AS p
	INNER JOIN inserted AS i --valores nuevos que se querían guardar
ON
p.ProductoID = i.ProductoID
END
GO

-- AFTER INSERT
CREATE OR ALTER TRIGGER TR_AuditoriaProductoAfterInsert
ON Productos
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO AuditoriaProductos
		(ProductoID, Accion, PrecioAnterior, PrecioNuevo, Usuario)
	SELECT 
		i.ProductoID,
		'INSERT',
		NULL,			-- No hay precio anterior: El producto es nuevo
		i.Precio,
		SYSTEM_USER
	FROM inserted AS i;
END
GO

-- INSTEAD OF INSERT
CREATE OR ALTER TRIGGER TR_AuditoriaProductoInsteafOfInsert
ON Productos
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM inserted WHERE Precio <=0 OR Precio IS NULL)
	BEGIN
		THROW 50001, 'El precio no puede ser menor a 0', 1;
	END
	-- Si pasa la validación registramos nosotros mísmos el INSERT que se CREO
	INSERT INTO Productos(Nombre, Categoria, Precio, Stock, FechaCreacion)
	SELECT
		i.Nombre,
		i.Categoria,
		i.Precio,
		i.Stock,
		ISNULL(i.FechaCreacion, GETDATE())
	FROM inserted as i;
END
GO


-- AFTER DELETED
CREATE OR ALTER TRIGGER TR_AuditoriaProductoAfterDeleted
ON Productos
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO AuditoriaProductos
		(ProductoID, Accion, PrecioAnterior, PrecioNuevo, Usuario)
	SELECT 
		d.ProductoID,
		'DELETED',
		d.Precio,	-- Precio que tenía al borrarse
		NULL,		-- No hay precio nuevo: el productoya no existe
		SYSTEM_USER
	FROM deleted AS d;
END
GO

-- INSTEAD OF DELETED
-- Normalmente no deben borrar productos que todavía tienen existencias
CREATE OR ALTER TRIGGER TR_ValidarStockInsteadOfDelete
ON Productos
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM deleted WHERE Stock > 0)
	BEGIN 
		THROW 50002, 'No se puede eliminar un producto que todavía tiene stock.',1; -- Son errores, personalizados
	END

	-- Si pasa la validación, hacemos nosotros el DELETE que se canceló
	DELETE P
	FROM PRODUCTOS AS P
	INNER JOIN deleted AS D ON P.ProductoID = d.ProductoID;
END
GO


--=================================
--Triger para TR_GuardarDetalleAfterPedido
--CREATE OR ALTER TRIGGER TR_GuardarDetalleAfterPedido
--ON Pedidos
--AFTER INSERT
--AS
--BEGIN
	--SET NOCCOUNT ON;

--END
--GO