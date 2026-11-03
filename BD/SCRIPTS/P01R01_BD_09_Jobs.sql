use msdb
GO

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: CREACIÓN DE JOBS

-- Definición: Son tareas programadas del lado del servidor del SQL

ACID
*/

-- 1. Crear un job
BEGIN TRANSACTION;
	BEGIN TRY 
		IF NOT EXISTS(SELECT 1 FROM dbo.sysjobs WHERE name = 'JExecSPGenNOVv2')
			BEGIN 
				-- 1. Crear jobs
				EXEC sp_add_job
					@job_name = N'JExecSPGenNOVv2', -- Nombre del JOB
					@enabled = 1, -- habilitar el job
					@description = N'Ejecuta el sp cada 5 minutos';
					--@start_step_ip=1,
					--@owner_login_name=N'sa';
					
-- 2. Crear el step(paso) que ejecuta el stored  procedure
				EXEC sp_add_jobstep
					@job_name=N'JExecSPGenNOVv2',
					@step_name=N'Ejecutar mi SP',
					@subsystem=N'TSQL',
					@command=N'EXEC dbo.spConsultarContenidoTablaGentNov', -- comando que ejecuta el procedimiento
					@database_name = N'GenNov', --Reemplaza con tu base de datos
					--@on_succes_action = 1 -- Continuar con el sigueinte paso o terminar si es el único
					@retry_attempts = 3,
					--@on_fall_action = 2; -- Parar el job si falla
					@retry_interval = 1;

-- 3. Crear el schedule (programación) para que se ejecute cada hora
				EXEC sp_add_schedule
					--@job_name = N'JExecSPGenNOVv2', -- nombre del job
					--@name = N'Respaldo_cada_hora' -- Nombre de la programación
					@schedule_name = N'ScheduleJExecSPGenNOVv2',
					--@enable = 1, -- Habilitar la programación
					@freq_type = 4, -- Frecuencia diaria
					@freq_interval = 1, -- Ejecutar todos los días
					@freq_subday_type= 4, -- Unidad: Minutos 
					@freq_subday_interval = 5, -- ejecutar cada 5 minutos
					@active_start_time = 000000, -- Hora de inicio (formato HHMMSS), empieza a media noche
					@active_end_time = 235959

-- 4. Agregar el job al servidor
				EXEC sp_attach_schedule
					@job_name = N'JExecSPGenNOVv2',
					@schedule_name = N'ScheduleJExecSPGenNOVv2'

-- 5. Agregar el job al server para que el SQLservr Agent lo ejecute
				EXEC sp_add_jobserver
					@job_name = N'JExecSPGenNOVv2',
					@server_name = N'ISRAEL'
			END
COMMIT TRANSACTION
	END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
		PRINT ERROR_MESSAGE();
END CATCH
GO
					
