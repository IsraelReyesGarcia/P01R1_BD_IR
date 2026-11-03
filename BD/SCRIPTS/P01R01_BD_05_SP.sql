USE GenNov
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA 20261027
DESCRIPCION: Creación de STORED PROCEDURES
*/

CREATE OR ALTER PROCEDURE spObtenerClientePorId
	@Cliente INT
AS 
BEGIN
	SELECT
		ClienteID,
		Nombre,
		Email,
		Telefono
		FROM Clientes
		WHERE ClienteID=@Cliente
END
GO

CREATE OR ALTER PROCEDURE spInsertarPedido
	@ClienteID INT = 1,
	@Total DECIMAL(10,2) = 500,
	@Estado NVARCHAR(20) = 'Pendiente',
	@NuevoPedidoID INT OUTPUT
AS
BEGIN
	INSERT INTO Pedidos(ClienteID, Total, Estado, Fecha)
	VALUES (@ClienteID, @Total, @Estado, GETDATE());

	-- Obtener el ID del pedido recien creado
	SET @NuevoPedidoID = SCOPE_IDENTITY(); -- Devuelve el id del producto creado

	SELECT @NuevoPedidoID AS PedidoCreado;
END
GO

-------------------- DETONAR EL JOB
CREATE OR ALTER PROCEDURE dbo.spConsultarContenidoTablaGentNov
AS
BEGIN
	-- Cada SELECT trae el contenido completo de una tabla; se muestran como resulsets separados
	SELECT * FROM dbo.Productos;
	SELECT * FROM dbo.Clientes;
	SELECT * FROM dbo.DetallesPedido;
	SELECT * FROM dbo.AuditoriaProductos;
END
GO

--=========================
-- spProductos_Insertar
--=========================
CREATE OR ALTER PROCEDURE dbo.spProductos_Insertar
	@Nombre NVARCHAR(100),
	@Categoria NVARCHAR(50),
	@Precio DECIMAL(10,2),
	@Stock INT,
	@NuevoID INT OUTPUT
AS BEGIN
	SET NOCOUNT ON;

	-- Validaciones de negocio
	IF @Precio <= 0 THROW 50001, 'El precio debe ser mayor a cero',1;
	IF @Stock < 0 THROW 50002, 'El stock no puede ser negativo', 1;
	IF @Categoria NOT IN (N'Bebida', N'Panaderia', N'Postre', N'Desayuno', N'Comida', N'Snack', N'Complemento') THROW 50003, 'La categoria no es válida',1;

	BEGIN TRANSACTION;
	BEGIN TRY
		INSERT INTO Productos (Nombre, Categoria, Precio, Stock) VALUES (@Nombre, @Categoria, @Precio, @Stock);
		SET @NuevoID = SCOPE_IDENTITY();
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
			THROW;
	END CATCH
END
GO