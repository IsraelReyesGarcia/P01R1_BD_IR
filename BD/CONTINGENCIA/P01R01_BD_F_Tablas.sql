use GenNov
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
*/

--=========================
-- Respaldo de [DetallesPedido]
--=========================
BEGIN TRANSACTION
BEGIN TRY
	IF EXISTS(
		SELECT  1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DetallesPedido' AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
			--Eliminar tabla: DetallesPedido
			DROP TABLE dbo.DetallesPedido;
			print 'Tabla DetallesPedido eliminada correctamente.';
		END
	ELSE 
		BEGIN
			PRINT 'La tabla [dbo].[DetallesPedido] no existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--=========================
-- Respaldo de [Pedidos]
--=========================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(SELECT 1	 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Pedidos' AND TABLE_SCHEMA = 'dbo')
		BEGIN
			-- Eliminar la tabla [Pedidos]
			DROP TABLE dbo.Pedidos
			PRINT 'La tabla [Pedidos] a sido eliminado correctamente'
		END
	ELSE
		PRINT 'La [dbo].[Pedidos] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--=========================
-- Respaldo de [Clientes]
--=========================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Clientes' AND TABLE_SCHEMA = 'dbo')
		BEGIN
			-- Eliminar la tabla [Clientes]
			DROP TABLE dbo.Clientes
			PRINT 'La tabla [dbo].[Clientes] ha sido eliminada correctamente'
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

--=========================
-- Respaldo de [Productos]
--=========================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Productos' AND TABLE_SCHEMA='dbo')
		BEGIN
			-- Eliminar la tabla [Productos]
			DROP TABLE dbo.Productos
			PRINT 'La tabla [Productos] fue eliminada correctamente'
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

--=========================
-- Respaldo de [AuditoriaProductos]
--=========================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditoriaProductos' AND TABLE_SCHEMA = 'dbo')
		BEGIN
			-- ELIMINAR LA TABLA AuditoriaProductos
			DROP TABLE dbo.AuditoriaProductos
			PRINT 'La tabla [AuditoriaProductos] fue eliminada correctamente'
		END
	ELSE 
		BEGIN
			PRINT 'La tabla [AuditoriaProductos] no existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO