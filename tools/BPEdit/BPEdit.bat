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
if exist "%~dp0\python\Scripts\activate.bat" (
   call "%~dp0\python\Scripts\activate.bat"
   echo Using venv from "%~dp0\python"
) else (
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