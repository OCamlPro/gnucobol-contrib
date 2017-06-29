@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

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
   rem set PIP=pip3.exe
   set "PIP=python.exe -m pip"
   echo Using venv from "%pythonpath%"
) else (
   :: check for pip executable
   where /q pip3.exe
   if errorlevel 1 (
      where /q pip.exe
      if errorlevel 0 (
         set PIP=pip.exe
      )
   ) else (
      set PIP=pip3.exe
   )
)

if errorlevel 1 (
   echo ERROR: pip3.exe / pip.exe is missing in PATH
   goto :end
)

:: actual install
echo Installing Dependencies...
echo %PIP% install -r requirements.txt

echo.
%PIP% install -r requirements.txt
rem test: %PIP% install PyInstaller

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal