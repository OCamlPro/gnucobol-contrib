@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: use venv from local dist directory, if available
set "currpath=%~dp0"
set "pythonpath=%currpath%python"
if exist "%pythonpath%\Scripts\activate.bat" (
   call "%pythonpath%\Scripts\activate.bat"
   echo Using venv from "%pythonpath%"
) else (
   :::echo "%pythonpath%\Scripts\activate.bat" doesn't exist
   :: check for python executable
   where /q python.exe
   if errorlevel 1 (
      echo ERROR: python.exe is missing in PATH
      goto :end
   )
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
echo Starting BPEdit
echo.
python.exe BPEdit.pyw

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal