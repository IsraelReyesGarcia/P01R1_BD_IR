USE GenNov
GO -- Es lotear tu código, es decir define donde termina una instrucción

/*
PROYECTO: P01R01_BD_IS
AUTOR: ISRAEL REYES
FECHA: 20261027
DESCRIPCIONES: CREACIÓN DE TABLAS

-- ACID: Transacciones en la base de datos
	-- Atomicidad: O se ejecuta todo el código o no se ejecuta nada
	-- Concistencia: Los datos siempre deben ser válidos o validaciones
	-- Aislamiento: Las transacciones son independientes (Uso del GO)
	-- Durabilidad: Que los cambios persistan en la base de datos (COMMIT DB)
*/

BEGIN TRANSACTION 
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Productos' AND TABLE_SCHEMA = 'dbo')
		BEGIN 
				CREATE TABLE Productos(
					ProductoID INT PRIMARY KEY IDENTITY(1,1), -- Le estas dando Identidad Referencial
					Nombre NVARCHAR(100) NOT NULL,
					Categoria NVARCHAR(50) NOT NULL,
					Precio DECIMAL(10,2) NOT NULL,
					Stock INT DEFAULT 0,
					FechaCreacion DATETIME DEFAULT GETDATE()
				)
				PRINT 'La tabla Productos fue creada correctamente'
		END

		ELSE 
		BEGIN
			PRINT 'La tabla [dbo].[Productos] ya existe'
		END
	COMMIT TRANSACTION; --Confirmar cambios
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;	--	Revierte la transacción
			THROW;					--	Devuelve el error
	END CATCH
GO
-------------------------------------
-- COMMIT Y ROLLBACK
BEGIN TRANSACTION
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Clientes' AND TABLE_SCHEMA = 'dbo')
		BEGIN

			-- Tabla Clientes
			CREATE TABLE Clientes(
				ClienteID INT PRIMARY KEY IDENTITY(1,1),
				Nombre NVARCHAR(100) NOT NULL,
				Email NVARCHAR(100) NOT NULL,
				Telefono NVARCHAR(15)
			);
		PRINT 'Tabla: Clientes creada correctamente';
		END
	ELSE 
		BEGIN
			PRINT 'La tabla [dbo].[Clientes] ya existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

----------------------------
-- COMMIT Y ROOLBACK
BEGIN TRANSACTION 
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Pedidos' AND TABLE_SCHEMA='dbo')
		BEGIN 
			CREATE TABLE Pedidos(
				PedidoID INT PRIMARY KEY IDENTITY(1,1),
				ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
				Fecha DATETIME DEFAULT GETDATE(),
				Total DECIMAL(10,2) NOT NULL,
				Estado NVARCHAR(20) DEFAULT 'Pendientes'
			);
		PRINT 'Tabla: Pedidos fue creada correctamente'
		END
	ELSE 
	BEGIN 
		PRINT 'La tabla [dbo].[Pedidos] ya existe'
	END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

---------------------------
-- COMMIT Y ROLLBACK
BEGIN TRANSACTION 
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DetallesPedido' AND TABLE_SCHEMA = 'dbo')
		BEGIN 
				CREATE TABLE DetallesPedido(
					DetalleID INT PRIMARY KEY IDENTITY(1,1), -- Le estas dando Identidad Referencial
					PedidoID INT FOREIGN KEY REFERENCES Pedidos(PedidoID),
					ProductoID INT FOREIGN KEY REFERENCES Productos(ProductoID),
					ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
					Cantidad int NOT NULL,
					PrecioUnitario DECIMAL(10,2) NOT NULL
				)
				PRINT 'La tabla DetallesPedido fue creada correctamente'
		END

		ELSE 
		BEGIN
			PRINT 'La tabla [dbo].[DetallesPedido] ya existe'
		END
	COMMIT TRANSACTION; --Confirmar cambios
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;	--	Revierte la transacción
			THROW;					--	Devuelve el error
	END CATCH
GO

-----------------------------------------------------------
-- COMMIT ROLLBACK
BEGIN TRANSACTION
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditoriaProductos' AND TABLE_SCHEMA = 'dbo')
	BEGIN
		CREATE TABLE AuditoriaProductos(
			AuditoriaID INT PRIMARY KEY IDENTITY(1,1),
			ProductoID INT,
			Accion NVARCHAR(20),
			PrecioAnterior DECIMAL(10,2),
			PrecioNuevo DECIMAL(10,2),
			Usuario NVARCHAR(100),
			Fecha DATETIME DEFAULT GETDATE()
		);
		PRINT 'TABLA AuditoriaProductos CREADA CORRECTAMENTE'
	END
	ELSE BEGIN
		PRINT 'LA TABLA AuditoriaProductos CREADA CORRECTAMENTE'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO
