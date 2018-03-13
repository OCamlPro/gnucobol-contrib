@echo off
setlocal

:: set env. variables for 32 or 64 bit
:: call "C:\GC22\GC22-VBI-32bit\set_env.cmd"
call "C:\GC22\GC22B-64bit\bin\cobenv.cmd"

:: set directories to match your installation (only necessary for systems older than WinXP...)
set src_c_dir=%~dp0

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
if not exist "%src_c_dir%\" (
   echo ERROR: Please set src_c_dir correct, currently set to %src_c_dir%
   goto :end
)

:: change directory
pushd "%src_c_dir%"

:: delete old files (ignoring errors)
del *.o      2>NUL

echo compile the C programs
cobc.exe -c %verbose% fileselect.c
cobc.exe -c %verbose% imageio.c
cobc.exe -c %verbose% japilib.c

echo compilation finished


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
