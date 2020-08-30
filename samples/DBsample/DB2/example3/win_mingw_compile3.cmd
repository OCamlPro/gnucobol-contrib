@echo off
setlocal

:: set env. variables
call "C:\GC31-rc1-BDB-M64\bin\cobenv.cmd"

:: delete old files (ignoring errors)
del DB2TEST3.exe    2>NUL
del DB2SQLMSG.dll   2>NUL
del DB2MOD3.dll     2>NUL
del DB2MOD3.bnd     2>NUL
del DB2MOD3.cbl     2>NUL

:: db2cmd -i -w -c db2 [command line parameters]
:: -i : don't open a new console, share the existing console and stdin, stdout handles
:: -c : run the specified command (db2 etc.) and terminate
:: -w : wait until the spawned command process ends

db2cmd -i -w -c db2 -tvf db2_precompile3.sql

echo Press any key to continue...
pause

:: compile
cobc -m -std=mf DB2SQLMSG.cob -Ic:\Programme\IBM\SQLLIB\include\cobol_mf -Lc:\Programme\IBM\SQLLIB\lib -ldb2api
cobc -m -std=mf DB2MOD3.cbl -fnot-reserved=TITLE -Ic:\Programme\IBM\SQLLIB\include\cobol_mf -Lc:\Programme\IBM\SQLLIB\lib -ldb2api
cobc -x DB2TEST3.cob

endlocal
