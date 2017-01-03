@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: check for python executable
where /q python.exe
if errorlevel 1 (
   echo ERROR: python.exe is missing in PATH
   goto :end
)

:: change to project directory
pushd %~dp0

:: create paths.ini from template, if missing
if not exist "paths.ini" (
   echo path.ini is created from template, please adjust the paths
   copy "paths.tmpl.ini" "paths.ini"
   echo.
   pause
   echo.
)

:: actual start
python.exe BPEdit.pyw

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal