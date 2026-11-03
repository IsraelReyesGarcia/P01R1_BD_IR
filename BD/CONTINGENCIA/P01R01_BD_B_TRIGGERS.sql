USE GenNov
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: CREAR LA CONTINGENCIA DE LOS TRIGGERS


=================================
--	CONTINGENCIA DE TRIGGERS
=================================
-- COMMIT ROLLBACK
*/

--===============================
-- CONTINGENCIA DE TR_ValidarPrecioInsteadOfUpdate
--===============================

BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS (
		SELECT 1 
		FROM sys.objects
		WHERE name = 'TR_ValidarPrecioInsteadOfUpdate'
			AND type = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)

		BEGIN
			-- ELIMINA R: TRIGGER TR_ValidarPrecioInsteadOfUpdate
			DROP TRIGGER dbo.TR_ValidarPrecioInsteadOfUpdate
			PRINT 'Trigger TR_ValidarPrecioInsteadOfUpdate eliminado correctamente'
		END
	ELSE
		BEGIN
			PRINT 'TRIGGER no [dbo1].[TR_ValidarPrecioInsteadOfUpdate] no existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--------------------------------
--===============================
-- CONTINGENCIA DE TR_AuditarCambioPrecio
--===============================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM 
		sys.objects
		WHERE NAME = 'TR_AuditarCambioPrecio'
			AND TYPE = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)
		BEGIN
			-- ELIMINAR R: TR_AuditarCambioPrecio
			DROP TRIGGER dbo.TR_AuditarCambioPrecio
			PRINT 'Trigger TR_AuditarCambioPrecio eliminado correctamente'
		END
	ELSE
		BEGIN
			PRINT 'TRIGGER no [dbo].[TR_AuditarCambioPrecio] NO EXISTE'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

--------------------------------------------------
--===============================
-- CONTINGENCIA DE TR_AuditoriaProductoInsteafOfInsert
--===============================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS (
		SELECT 1 FROM 
		sys.objects
		WHERE NAME = 'TR_AuditoriaProductoInsteafOfInsert'
			AND TYPE = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)
		BEGIN 
			-- ELIMINAR R: TR_AuditoriaProductoInsteafOfInsert
			DROP TRIGGER dbo.TR_AuditoriaProductoInsteafOfInsert
			PRINT 'Trigger TR_AuditoriaProductoInsteafOfInsert eliminado correctamente'
		END
	ELSE 
		BEGIN
			PRINT 'TRIGGER [dbo].[TR_AuditoriaProductoInsteafOfInsert] NO EXISTE'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

-----------------------------------
--===============================
-- CONTINGENCIA DE TR_AuditoriaProductoAfterInsert
--===============================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM 
		sys.objects
		WHERE NAME = 'TR_AuditoriaProductoAfterInsert'
			AND TYPE = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)

		BEGIN 
			-- ELIMINAR R: TR_AuditoriaProductoAfterInsert
			DROP TRIGGER dbo.TR_AuditoriaProductoAfterInsert
			PRINT 'Trigger TR_AuditoriaProductoAfterInsert eliminado correctamente'
		END
	ELSE 
		PRINT 'TRIGGER [dbo].[TR_AuditoriaProductoAfterInsert] NO EXISTE'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		THROW
END CATCH
GO

--------------------------------
--===============================
-- CONTINGENCIA DE TR_ValidarStockInsteadOfDelete
--===============================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM 
		sys.objects
		WHERE NAME = 'TR_ValidarStockInsteadOfDelete'
			AND TYPE = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)
		BEGIN
			-- ELIMINAR R: TR_ValidarStockInsteadOfDelete
			DROP TRIGGER dbo.TR_ValidarStockInsteadOfDelete
			PRINT 'Trigger TR_ValidarStockInsteadOfDelete eliminado correctamente'
		END
	ELSE
		BEGIN
			PRINT 'Trigger [dbo].[TR_ValidarStockInsteadOfDelete] no existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO

------------------------------------
--===============================
-- CONTINGENCIA DE TR_AuditoriaProductoAfterDeleted
--===============================

BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		sys.objects
		WHERE NAME='TR_AuditoriaProductoAfterDeleted'
			AND TYPE = 'TR'
			AND SCHEMA_NAME(schema_id) = 'dbo'
		)
		BEGIN
			DROP TRIGGER dbo.TR_AuditoriaProductoAfterDeleted
			PRINT 'EL Trigger TR_AuditoriaProductoAfterDeleted eliminado correctamente'
		END
	ELSE
		BEGIN
			PRINT 'Trigger [dbo].[TR_AuditoriaProductoAfterDeleted] no existe'
		END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO
