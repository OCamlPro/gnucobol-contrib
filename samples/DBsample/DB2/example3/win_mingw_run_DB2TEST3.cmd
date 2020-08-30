@echo off
setlocal

:: set env. variables
call "C:\GC31-rc1-BDB-M64\bin\cobenv.cmd"

set COB_LIBRARY_PATH=c:\Programme\IBM\SQLLIB\BIN
set COB_PRE_LOAD=db2agapi64

:: start program
DB2TEST3.exe

endlocal
