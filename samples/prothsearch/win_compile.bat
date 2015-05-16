:: set directories to match your installation
set progdir=C:\oc_projekt\prothsearch

:: test if directories exist
if not exist "%progdir%\" (
   echo Please set progdir correct, currently set to %progdir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%progdir%\*.obj"    2>NUL
del "%progdir%\*.lib"    2>NUL
del "%progdir%\*.exp"    2>NUL
del "%progdir%\*.exe"    2>NUL
del "%progdir%\*.dll"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"

cd "%progdir%"

:: compile
cobc -c -free prothtest.cob
cobc -x -free prothsearch.cob -o prothsearch.exe prothtest.obj -lC:\GnuCobol\build_windows\Win32\mpir

:eof

pause
