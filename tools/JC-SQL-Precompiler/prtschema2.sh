presql prtschema2.scb prtschema2.cbl
cobc -x prtschema2.cbl cobmysqlapi.o -L/usr/lib64/mysql -lmysqlclient -lz
exit 0
