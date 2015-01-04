:: set directories to match your installation
set src_c_dir="C:\oc_projekt\cobjapi\src_c"

:: test if directories exist
if not exist "%src_c_dir%\" (
   echo Please set src_c_dir correct, currently set to %src_c_dir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%src_c_dir%\*.obj"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

:: change directory
cd %src_c_dir%

:: compile the C programs
cobc -c -v %src_c_dir%\fileselect.c
cobc -c -v %src_c_dir%\imageio.c
cobc -c -v %src_c_dir%\japilib.c


:eof

pause
