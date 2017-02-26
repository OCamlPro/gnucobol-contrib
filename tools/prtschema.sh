presql prtschema.scb prtschema.cbl
cobc -x prtschema.cbl cobmysqlapi.o -L/usr/lib64/mysql -lmysqlclient -lz
exit 0
