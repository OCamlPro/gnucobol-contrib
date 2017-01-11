@echo off
setlocal

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

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
del *.obj    2>NUL

:: compile the C programs
cobc.exe -c -v fileselect.c
cobc.exe -c -v imageio.c
cobc.exe -c -v japilib.c


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
