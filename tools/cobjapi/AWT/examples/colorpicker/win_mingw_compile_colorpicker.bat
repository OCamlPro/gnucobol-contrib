@echo off
setlocal

:: set env. variables for 32 or 64 bit
:: call "C:\GC22\GC22-VBI-32bit\set_env.cmd"
call "C:\GC22\GC22B-64bit\bin\cobenv.cmd"

:: set compiler parameters
set "COBCOBJ=cobjapi.o fileselect.o imageio.o japilib.o"
set "COBCLIB=-lWS2_32"
rem set "verbose=-v"

:: set directories to match your installation (only necessary for systems older than WinXP...)
set "example_dir=%~dp0"
set "src_c_dir=%example_dir%..\..\src_c"
set "src_cobol_dir=%example_dir%..\..\src_cobol"

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
if not exist "%example_dir%\" (
   echo ERROR: Please set example_dir correct, currently set to %example_dir%
   goto :end
)
if not exist "%src_c_dir%\" (
   echo ERROR: Please set src_c_dir correct, currently set to %src_c_dir%
   goto :end
)
if not exist "%src_cobol_dir%\" (
   echo ERROR: Please set src_cobol_dir correct, currently set to %src_cobol_dir%
   goto :end
)

:: change directory
pushd "%example_dir%"

:: delete old files (ignoring errors)
del *.o    2>NUL
del *.lib  2>NUL
del *.exp  2>NUL
del *.exe  2>NUL

echo compile the C programs
cobc -c %verbose% "%src_c_dir%\fileselect.c"
cobc -c %verbose% "%src_c_dir%\imageio.c"
cobc -c %verbose% "%src_c_dir%\japilib.c"

echo compile the cobjapi interface
cobc -c -free -Wno-unfinished %verbose% "%src_cobol_dir%\cobjapi.cob" %*

echo compile the program
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" colorpicker.cob %* %COBCOBJ% %COBCLIB%

echo compilation finished


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
