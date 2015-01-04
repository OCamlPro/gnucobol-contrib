:: set directories to match your installation
set src_cobol_dir="C:\oc_projekt\cobjapi\src_cobol"

:: test if directories exist
if not exist "%src_cobol_dir%\" (
   echo Please set src_cobol_dir correct, currently set to %src_cobol_dir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%src_cobol_dir%\*.obj"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

:: change directory
cd %src_cobol_dir%

:: compile the cobjapi interface
cobc -c -free -v %src_cobol_dir%\cobjapi.cob


:eof

pause
