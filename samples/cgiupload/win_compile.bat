rem delete old files
del C:\Apache2\cgi-bin\cgiupload
del C:\Apache2\htdocs\upload1.html
del C:\Apache2\htdocs\upload2.html
del C:\Apache2\htdocs\upload3.html
del C:\Apache2\htdocs\upload4.html
del C:\Apache2\htdocs\upload5.html
del C:\Apache2\htdocs\upload6.html
del C:\Apache2\htdocs\upload7.html
del cgiupload.exe

rem set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

cd C:\oc_projekt\cgiupload

rem compile with define
cobc -x -free cgiupload.cob -D OS=WINDOWS

rem copy new files in apache directory
copy cgiupload.exe C:\Apache2\cgi-bin\cgiupload
copy upload1.html C:\Apache2\htdocs\upload1.html
copy upload2.html C:\Apache2\htdocs\upload2.html
copy upload3.html C:\Apache2\htdocs\upload3.html
copy upload4.html C:\Apache2\htdocs\upload4.html
copy upload5.html C:\Apache2\htdocs\upload5.html
copy upload6.html C:\Apache2\htdocs\upload6.html
copy upload7.html C:\Apache2\htdocs\upload7.html

pause
