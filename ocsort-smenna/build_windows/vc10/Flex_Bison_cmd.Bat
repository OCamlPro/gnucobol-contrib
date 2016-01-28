
:  echo set COB_CONFIG_DIR=D:\OpenCOBOL_Set\config 
:  set COB_CONFIG_DIR=D:\OpenCOBOL_Set\config
:  rem
:  echo set COB_COPY_DIR=D:\OpenCOBOL_Set\copy 
:  set COB_COPY_DIR=D:\OpenCOBOL_Set\copy
:  rem
:  echo set COB_LIBRARY_PATH=D:\OpenCOBOL_Set\bin  
:  set COB_LIBRARY_PATH=D:\OpenCOBOL_Set\bin;D:\OpenCOBOL_Set\tp-cobol-debugger;
:  rem
:  echo set COB_SCREEN_ESC=Y 
:  set COB_SCREEN_ESC=Y
:  rem
:  echo set COB_SCREEN_EXCEPTIONS=Y 
:  set COB_SCREEN_EXCEPTIONS=Y
:  rem
:  REM - check for PATH contains "D:\OpenCOBOL_Set\bin" --
:  echo %PATH% > D:\OpenCOBOL_Set\echopath.txt
:  find /C /I "D:\OpenCOBOL_Set\bin" D:\OpenCOBOL_Set\echopath.txt > D:\OpenCOBOL_Set\echofind.txt 
:  if %errorlevel%==0 goto NEXT1
:  set PATH=%path%;D:\OpenCOBOL_Set\bin
:  echo PATH has been updated with D:\OpenCOBOL_Set\bin
:  goto NEXT2
:  :NEXT1
:  echo PATH already includes D:\OpenCOBOL_Set\bin
:  :NEXT2 
:  if exist D:\OpenCOBOL_Set\echopath.txt erase D:\OpenCOBOL_Set\echopath.txt
:  if exist D:\OpenCOBOL_Set\echofind.txt erase D:\OpenCOBOL_Set\echofind.txt
:  echo.
:  echo OpenCOBOL 1.1 Windows XP environment variables installed.     
:  echo.
echo ===============================================================
echo    check if scanner.l or parser.y read-only
echo    win_flex win_bison  compile only if scanner.l or parser.y 
echo    are not read-only
echo ===============================================================

attrib scanner.l > lscan.txt
find /C /I " R "  lscan.txt > nul
if %errorlevel%==0 goto LBBIS
win_flex.exe --header-file=scanner.h  -d --nounistd --wincompat -o scanner.c scanner.l
:LBBIS
attrib parser.y > lparser.txt
find /C /I " R "  lparser.txt > nul
if %errorlevel%==0 goto LBEND
win_bison --defines=parser.h -o parser.c parser.y
:LBEND
