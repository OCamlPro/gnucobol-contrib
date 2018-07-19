#!/bin/bash

# SQLCA: SQL Communications Area for Ocesql
COPY=/home/$USER/Open-COBOL-ESQL-1.1/copy
SCR=/usr/local/share/gnucobol/copy
OC_OBJ=/home/$USER/Open-COBOL-ESQL-1.1/dblib

# clean
rm PGTEST3
rm PGMOD3.cob

# SQL precompile
ocesql PGMOD3.cbl PGMOD3.cob

# static compile
cobc -x PGTEST3.cob PGMOD3.cob PGSQLMSG.cob $OC_OBJ/ocdb.o $OC_OBJ/ocdblog.o $OC_OBJ/ocdbutil.o $OC_OBJ/ocesql.o $OC_OBJ/ocpgsql.o -I$COPY -I$SCR -locesql -lpq
