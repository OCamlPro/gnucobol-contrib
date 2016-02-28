@echo off
echo ===============================================================
echo    check if scanner.l or parser.y read-only
echo    win_flex win_bison  compile only if scanner.l or parser.y 
echo    are not read-only
echo ===============================================================

attrib ..\scanner.l > lscan.txt
find /C /I " R "  lscan.txt > nul
if %errorlevel%==0 goto LBBIS
win_flex.exe --header-file=..\scanner.h  -d --nounistd --wincompat -o ..\scanner.c ..\scanner.l
:LBBIS
attrib ..\parser.y > lparser.txt
find /C /I " R "  lparser.txt > nul
if %errorlevel%==0 goto LBEND
win_bison --defines=..\parser.h -o ..\parser.c ..\parser.y
:LBEND
