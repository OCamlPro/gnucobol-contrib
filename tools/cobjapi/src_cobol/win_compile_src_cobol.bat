@echo off
setlocal

:: set directories to match your installation (only necessary for systems older than WinXP...)
set %src_cobol_dir%~dp0


:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: check for cobc executable
where /q cobc.exe
if errorlevel 1 (
   echo ERROR: cobc.exe is missing in PATH
   goto :end
)

:: test if directories exist
if not exist %src_cobol_dir%\" (
   echo ERROR: Please set %src_cobol_dircorrect, currently set to %src_cobol_dir%
   goto :end
)

:: change directory
pushd %src_cobol_dir%"

:: delete old files (ignoring errors)
del "*.obj"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

:: compile the cobjapi interface
cobc -c -free -v cobjapi.cob


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal