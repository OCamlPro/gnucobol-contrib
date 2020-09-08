@echo off
setlocal

:: set env. variables
call "C:\GC31-rc1-BDB-M64\bin\cobenv.cmd"

:: log file
set "OCDB_LOGFILE=C:\\gnucobol_prog\\DBsample\\PostgreSQL\\example5\\ocesql.log"

:: If OCDB_LOGLEVEL is set, then the file ocesql.log is created
:: Possible values:
:: - nothing to set -> same as NOLOG
:: - NOLOG or nolog
:: - ERR or err
:: - DEBUG or debug
set "OCDB_LOGLEVEL=DEBUG"

:: If you do not set the OCDB_DB_CHAR environment variable, then "SJIS" will be 
:: used as default. See ocesql.c in _ocesqlConnectMain() function.
:: If it is not set, then there are errors for example at duplacate key.
set "OCDB_DB_CHAR=UTF8"

set "PATH=C:\gnucobol_prog\msys2-64bit-psql-ocesql\psql-lib\bin;%PATH%"

:: start program
PGTEST5.exe

endlocal
