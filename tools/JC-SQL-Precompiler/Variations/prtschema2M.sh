presql2M prtschema2M.scb prtschema2M.cbl
cobc -x prtschema2M.cbl cobmysqlapi.o -L/usr/lib64/mysql -lmysqlclient -lz
exit 0
