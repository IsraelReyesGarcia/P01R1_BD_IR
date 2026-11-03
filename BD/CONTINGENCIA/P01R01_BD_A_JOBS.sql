use msdb
go

/*
PROYECTO: P01R01_BD_IR
AUTOR: ISRAEL REYES
FECHA: 20261028
DESCRIPCIÓN: Eliminar los jobs
*/


IF EXISTS(SELECT 1 FROM dbo.sysjobs WHERE name = 'JExecSPGenNOVv2')
	BEGIN 
		EXEC dbo.sp_delete_job
		@job_name = N'JExecSPGenNovv2',
		@delete_unused_schedule = 1 --;
		--@force_delete = 1;
	print 'Jon y sus recuros asociados eliminados';

	-- borrar duplicados
	DECLARE @SCHEDULE_ID INT;
	DECLARE cur CURSOR FOR
	SELECT @SCHEDULE_ID FROM msdb.dbo.sysschedules WHERE name = N'ScheduleJExecSPGenNOVv2';
	OPEN cur;
	FETCH NEXT FROM cur INTO @SCHEDULE_ID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.sp_delete_jobschedule @SCHEDULE_ID = @SCHEDULE_ID,
		@FORCE_DELETE = 1
		FETCH NEXT FROM cur INTO @SCHEDULE_ID;
	END
	CLOSE cur
		DEALLOCATE cur;
		PRINT 'Se borraron duplicates'
	END
