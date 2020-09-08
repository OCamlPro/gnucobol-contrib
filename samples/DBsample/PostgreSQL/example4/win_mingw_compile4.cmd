@echo off
setlocal

:: set env. variables
call "C:\GC31-rc1-BDB-M64\bin\cobenv.cmd"

:: SQLCA: SQL Communications Area for Ocesql
set "OC_COPY=C:\gnucobol_prog\msys2-64bit-psql-ocesql\Open-COBOL-ESQL-1.2\copy"
set "OC_PRE=C:\gnucobol_prog\msys2-64bit-psql-ocesql\Open-COBOL-ESQL-1.2\ocesql"
set "OC_DBLIB=C:\gnucobol_prog\msys2-64bit-psql-ocesql\Open-COBOL-ESQL-1.2\dblib"
set "PSQL_LIB=C:\gnucobol_prog\msys2-64bit-psql-ocesql\psql-lib\lib"


:: delete old files (ignoring errors)
del PGTEST4.exe 2>NUL
del PGMOD4.cob  2>NUL

:: SQL precompile
%OC_PRE%\ocesql PGMOD4.cbl PGMOD4.cob

echo Press any key to continue...
pause

:: static compile
cobc -x PGTEST4.cob PGMOD4.cob PGSQLMSG.cob %OC_DBLIB%\ocdb.o %OC_DBLIB%\ocdblog.o %OC_DBLIB%\ocdbutil.o %OC_DBLIB%\ocesql.o %OC_DBLIB%\ocpgsql.o -I%OC_COPY% -L%OC_DBLIB% -locesql -L%PSQL_LIB% -lpq

endlocal
