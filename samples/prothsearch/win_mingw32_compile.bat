:: set directories to match your installation
set progdir=C:\GC22\source\prothsearch

:: test if directories exist
if not exist "%progdir%\" (
   echo Please set progdir correct, currently set to %progdir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%progdir%\*.o"      2>NUL
del "%progdir%\*.obj"    2>NUL
del "%progdir%\*.lib"    2>NUL
del "%progdir%\*.exp"    2>NUL
del "%progdir%\*.exe"    2>NUL
del "%progdir%\*.dll"    2>NUL

:: set env. variables
call "C:\GC22\GC22-VBI\set_env.cmd"

cd "%progdir%"

:: compile
cobc -c -free -O3 -fno-gen-c-decl-static-call prothtest.cob
cobc -x -free -O3 prothsearch.cob prothtest.o

:eof

pause
