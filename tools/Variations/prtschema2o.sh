presql2o prtschema2o.scb prtschema2o.cbl
cobc -x prtschema2o.cbl cobmysqlapi.o -L/usr/lib64/mysql -lmysqlclient -lz
exit 0
