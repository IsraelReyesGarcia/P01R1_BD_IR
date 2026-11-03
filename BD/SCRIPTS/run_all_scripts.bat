@echo off
rem This batch file is used to run all scripts in the current directory.
setlocal

rem Get the current directory
set "SERVER=ISRAEL"
set "AUTH=-E"
set "SQLCMD=sqlcmd -f 65001"
set "SCRIPTS_DIR=%~dp0"

echo .
echo =======================
echo Ejecutando Scripts 1: Crear base de datos
echo =======================

%SQLCMD% -S %SERVER% %AUTH% -C -d master -i "%SCRIPTS_DIR%P01R01_BD_01_CreateDatabase.sql" -b
if errorlevel 1 goto error
echo [OK] Script 1 ejecutado con exito

rem Cambia por el nombre de la base de datos en el script
set "DB=GenNov"

echo .

echo ==================
echo Ejecutando Script 2: Crear tablas
echo ==================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_02_CreateTable.sql" -b
if errorlevel 1 goto error
echo [OK] Script 2 ejecutado con exito

echo.

echo ==========================
echo Ejecutando Script 3: Carga inicial
echo ==========================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPS_DIR%P01R01_BD_03_InitialCharge.sql" -b
if errorlevel 1 goto error
echo [OK] Script 3 ejecutado con exito

echo .

echo ===========================
echo Ejecutando Script 4: Crear Vistas
echo ==========================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_04_Views.sql" -b
if errorlevel 1 goto error
echo [OK] Script 4 ejecutado con exito

echo .

echo ============================
echo Ejecutando Script 5: Crear Procedimientos Almacenados
echo ============================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_05_SP.sql" -b
if errorlevel 1 goto error
echo [OK] Script 5 ejecutado con exito

echo .

echo =============================
echo Ejecutando Script 6: Crear Triggers
echo =============================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_06_TRIGGERS.sql"
if errorlevel 1 goto error
echo [OK] Script 6 ejecutado con exito

echo .

echo ==============================
echo Ejecutando Script 7: Crear Tablas temporales con tablas de tipo variable
echo ==============================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_07_TemporalTables.sql"
if errorlevel 1 goto error
echo [OK] Script 7 ejecutado con exito

echo .

echo ===============================
echo Ejecutando Script 8: Crear Tablas temporales que viven en sesión
echo ==============================

%SQLCMD% -S %SERVER% %AUTH% -C -d %DB% -i "%SCRIPTS_DIR%P01R01_BD_08_TemporaryTables.sql"
if errorlevel 1 goto error
echo [OK] Script 8 ejecutado con exito

echo.


echo =================================
echo Ejecutando Script 9: Crear Jobs
echo =================================

%SQLCMD% -S %SERVER% %AUTH% -C -d msdb -i "%SCRIPTS_DIR%P01R01_BD_09_Jobs.sql"
if errorlevel 1 goto error
echo [OK] Script 9 ejecutado con exito

echo.
echo =================================
echo EXITO: Todos los scripts se ejecutaron correcramente
echo =================================
goto end

:error
echo.
echo ================================
echo ERROR: Fallo la ejecución del script. Revisa el mensaje anterior.
echo ================================
endlocal
cmd /k

:end
endlocal
cmd /k