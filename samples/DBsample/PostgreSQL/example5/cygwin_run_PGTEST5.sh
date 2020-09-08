#!/bin/bash

# log file
# export OCDB_LOGFILE=/tmp/ocesql.log

# If OCDB_LOGLEVEL is set, then the file ocesql.log is created under /tmp
# Possible values:
# - nothing to set -> same as NOLOG
# - NOLOG or nolog
# - ERR or err
# - DEBUG or debug
export OCDB_LOGLEVEL=DEBUG

# If you do not set the OCDB_DB_CHAR environment variable, then "SJIS" will be 
# used as default. See ocesql.c in _ocesqlConnectMain() function.
# If it is not set, then there are errors for example at duplacate key.
export OCDB_DB_CHAR=UTF8

# start program
./PGTEST5
