:: set directories to match your installation
set progdir=C:\oc_projekt\cobsha3

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
cobc -c -free KECCAK.cob
cobc -m -free SHA3-224.cob KECCAK.obj
cobc -m -free SHA3-256.cob KECCAK.obj
cobc -m -free SHA3-384.cob KECCAK.obj
cobc -m -free SHA3-512.cob KECCAK.obj
cobc -m -free SHAKE128.cob KECCAK.obj
cobc -m -free SHAKE256.cob KECCAK.obj
cobc -x -free TESTSHA3.cob

:eof

pause
