USE GenNov
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: CONTINGENCIA DE LOS STORE PROCEDURES
*/

--===========================================
-- Backup de spObtenerClientePorId
--===========================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS (
		SELECT 1 FROM
		INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'spObtenerClientePorId'
		AND ROUTINE_SCHEMA = 'dbo'
		)

		BEGIN
			-- Eliminar: Procedimiento spObtenerClientePorId
			DROP PROCEDURE dbo.spObtenerClientePorId;
			PRINT 'Procedimiento spObtenerClientePorId eliminaod correctamente.';
		END
	ELSE 
		BEGIN
			PRINT 'El procedimiento [dbo].[spObtenerClientePorId] no existe.'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW
END CATCH
GO

--===========================================
-- Backup de spInsertarPedido
--===========================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'spInsertarPedido'
			AND ROUTINE_SCHEMA = 'dbo'
		)
		BEGIN
			-- Eliminar spInsertarPedido
			DROP PROCEDURE dbo.spInsertarPedido
			PRINT 'El procedimiento spInsertarPedido fue eliminado correctamente'
		END
	ELSE 
		PRINT 'El procedimiento [dbo].[spInsertarPedido] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		THROW 
END CATCH
GO

--===========================================
-- Backup de spInsertarPedido
--===========================================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'spConsultarContenidoTablaGentNov'
			AND ROUTINE_SCHEMA = 'dbo'
		)
		BEGIN
			-- Eliminar el procedimiento spConsultarContenidoTablaGentNov
			DROP PROCEDURE dbo.spConsultarContenidoTablaGentNov
			PRINT 'El procedimiento spConsultarContenidoTablaGentNov fue eliminado correctamente'
		END
	ELSE
		PRINT 'El procedimiento [dbo].[spConsultarContenidoTablaGentNov] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO