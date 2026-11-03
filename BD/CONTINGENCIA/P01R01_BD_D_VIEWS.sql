USE GenNov
go

/*
PROYECTO:P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: RESPALDO DE LAS VISTAS
*/

--===============================
-- Respaldo de VWVistaResumenVentas
--===============================
BEGIN TRANSACTION;
BEGIN TRY
	IF EXISTS(
		SELECT 1 FROM
		INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'VWVistaResumenVentas'
			AND TABLE_SCHEMA = 'dbo'
		)
		BEGIN
			-- Eliminar la vista VWVistaResumenVentas
			DROP VIEW.dbo.VWVistaResumenVentas;
			PRINT 'La vista VWVistaResumenVentas fue eliminada correctamente'
		END
	ELSE 
		PRINT 'La vista [dbo].[VWVistaResumenVentas] no existe'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW
END CATCH
GO