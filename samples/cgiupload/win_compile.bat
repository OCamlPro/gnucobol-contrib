:: set directories to match your installation
set cgibin=C:\Apache2\cgi-bin
set htdocs=C:\Apache2\htdocs
set progdir=C:\oc_projekt

:: test if directories exist
if not exist "%cgibin%\" (
   echo Please set cgibin correct, currently set to %cgibin%
   goto :eof
)
if not exist "%htdocs%\" (
   echo Please set htdocs correct, currently set to %htdocs%
   goto :eof
)
if not exist "%progdir%\" (
   echo Please set progdir correct, currently set to %progdir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%cgibin%\cgiupload"    2>NUL
del "%htdocs%\upload1.html" 2>NUL
del "%htdocs%\upload2.html" 2>NUL
del "%htdocs%\upload3.html" 2>NUL
del "%htdocs%\upload4.html" 2>NUL
del "%htdocs%\upload5.html" 2>NUL
del "%htdocs%\upload6.html" 2>NUL
del "%htdocs%\upload7.html" 2>NUL
del "cgiupload.exe"         2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

cd "%progdir%\cgiupload"

:: compile with define
cobc -x -free cgiupload.cob -D OS=WINDOWS

:: copy new files in apache directory
copy cgiupload.exe "%cgibin%\cgiupload"
copy upload1.html  "%htdocs%\upload1.html"
copy upload2.html  "%htdocs%\upload2.html"
copy upload3.html  "%htdocs%\upload3.html"
copy upload4.html  "%htdocs%\upload4.html"
copy upload5.html  "%htdocs%\upload5.html"
copy upload6.html  "%htdocs%\upload6.html"
copy upload7.html  "%htdocs%\upload7.html"

:eof

pause
