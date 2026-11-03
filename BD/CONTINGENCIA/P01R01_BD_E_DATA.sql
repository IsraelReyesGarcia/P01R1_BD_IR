USE GenNov
GO

/*
--==================================
-- CONTINGENCIA DE DATOS (Limpieza de tablas)
--==================================

-- COMMIT ROLLBACK
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: LIMPIEZA DE DATOS

ORDEN DE LA ELIMINACIÓN
	1. DetallesPedido
	2. Pedidos
	3. Clientes
	4. Productos
	5. AuditoriaProductos (al final, porque los triggers de Productos puerden generar
	registros de auditoria al borrar)

TRUNCATE no se puiede usare en tablas referneciadar por una FOREIGN KEY,
por eso se usa DELETE
*/

--======================================
-- Limpieza de tabla [DetallesPedido]
--======================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DetallesPedido'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
		-- Limpiza de la tabla DetallesPedido
		DELETE FROM dbo.DetallesPedido;
		PRINT 'Datos de DetallesPedido eliminados correctamen6te'
		END
	ELSE
		PRINT 'La tabla [dbo].[DetallesPedido] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--======================================
-- Limpieza de tabla [Pedidos]
--======================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Pedidos'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
		-- Limpiza de la tabla Pedidos
		DELETE FROM dbo.Pedidos;
		PRINT 'Datos de Pedidos eliminados correctamen6te'
		END
	ELSE
		PRINT 'La tabla [dbo].[Pedidos] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--======================================
-- Limpieza de tabla [Clientes]
--======================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Clientes'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
		-- Limpiza de la tabla Clientes
		DELETE FROM dbo.Clientes;
		PRINT 'Datos de Clientes eliminados correctamente'
		END
	ELSE
		PRINT 'La tabla [dbo].[Clientes] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--======================================
-- Limpieza de tabla [Productos]
--======================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Productos'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
		-- Limpiza de la tabla Productos
		DELETE FROM dbo.Productos;
		PRINT 'Datos de Productos eliminados correctamente'
		END
	ELSE
		PRINT 'La tabla [dbo].[Productos] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--======================================
-- Limpieza de tabla [AuditoriaProductos]
--======================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditoriaProductos'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
		-- Limpiza de la tabla AuditoriaProductos
		DELETE FROM dbo.AuditoriaProductos;
		PRINT 'Datos de AuditoriaProductos eliminados correctamente'
		END
	ELSE
		PRINT 'La tabla [dbo].[AuditoriaProductos] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO