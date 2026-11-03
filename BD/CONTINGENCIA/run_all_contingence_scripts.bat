@echo off
rem This batch file is used to run all scripts in the current directory
setlocal

rem Get the current director
set "SERVER=ISRAEL"
set "AUTH=-E"
set "SQLCMD=sqlcmd -f 65001"
set "SCRIPTS_DIR=%~dp0"
set "DB=GenNov"

echo .
echo ===================================
echo Ejecutando Script 1: Respaldo de los Jobs
echo ===================================

%SQLCMD% -S %SERVER% %AUTH% -C -d msdb -i "%SCRIPTS_DIR%P01R01_BD_A_JOBS.sql" -b
if errorlevel 1 goto error
echo [OK] Script 1 ejecutado con exito

echo .
echo ========================================
echo Ejecutando Script 2: Respaldo de los Triggers
echo ========================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPS_DIR%P01R01_BD_B_TRIGGERS.sql" -b
if errorlevel 1 goto error
echo [OK] Script 2 ejecutado con exito

echo .

echo ===================================
echo Ejecutnado Script 3: Respaldo de los store procedures
echo ===================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_C_SP.sql" -b
if errorlevel 1 goto error
echo [OK] Script 3 ejecutado con exito

echo .

echo =================================
echo Ejecutando Script 4: Respaldo de las Vistas
echo =================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_D_VIEWS.sql" -b
if errorlevel 1 goto error
echo [OK] Script 4 ejecutado con EXITO

echo .

echo ====================================
echo Ejecutando Script 5: Respaldo de los datos
echo ====================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_E_DATA.sql" -b
if errorlevel 1 goto error
echo [OK] Script 5 ejectuado con EXITO

echo .
echo ====================================
echo Ejecutando Script 6: Respaldo de las tablas
echo ====================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_F_TABLES.sql" -b
if errorlevel 1 goto error
echo [OK] Script 6 ejecutado con exito


echo .
echo ======================================
echo Ejecutando Script 7: Respaldo de la BASE DE DATOS
echo ======================================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_G_DATABASE.sql" -b
if errorlevel 1 goto error
echo [OK] Script 9 ejecutado con exito


echo .
echo ===============================
echo EXITO: Todos los scripts se ejecutaron corrrectamente
echo ===============================
goto end

:error
echo .
echo =======================================
echo ERROR: Falló la ejecución del script. Revisa el mensaje anterior.
echo =======================================
endlocal
cmd /k

:end
endlocal
cmd /k