Use master
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCI�N: CREACI�N DE CONTINGENCIA DE LA BASE DE DATOS

====================================
-- CONTINGENCIA DE LA BASDE DE DATOS
====================================

NOTAS: 
	- Se ejecuta desde master: no se puede eliminar una DB estando conectado a ella.
	- DROP DATABASE no se puede ejecutar dentro de una transacci�n,
	  por eso este script no se usa GEIN TRANSACTION / COMMIT / ROLLBACK.
	- Se pone la BD en SINGLE_USER WITH ROLLBACK INMEDIATE para cerrar
	  cualquier conexi�n abierta (otras pesta�as de SSMS, jobs, etc.).
*/

BEGIN TRY
	--VALIDATION
	IF EXISTS(SELECT 1 FROM master.dbo.sysdatabases WHERE name = N'GenNov')
		BEGIN
			-- Cerrar conexiones abiertas a la BD
			ALTER DATABASE GenNov SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

			-- Eliminar: base de datos GenNov;
			DROP DATABASE GenNov;
				print 'Base de datos GenNov eliminada correctamente.';
		END
	ELSE 
		BEGIN
			PRINT 'La base de datos [GenNov] no existe.'
		END
END TRY
BEGIN CATCH
	-- Si  falló el DROP, devolver la BD a modo normal
	IF EXISTS(SELECT 1 FROM master.dbo.sysdatabases WHERE name = N'GenNov')
		ALTER DATABASE GenNov SET MULTI_USER;
	THROW;
END CATCH
GO