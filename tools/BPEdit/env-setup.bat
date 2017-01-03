@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

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
if errorlevel 1 (
   echo ERROR: pip3.exe / pip.exe is missing in PATH
   goto :end
)

:: actual install
echo Installing Dependencies...
echo %PIP% install -r requirements.txt

echo.
%PIP% install -r requirements.txt


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal