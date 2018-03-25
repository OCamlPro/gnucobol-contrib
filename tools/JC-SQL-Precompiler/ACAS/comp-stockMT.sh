presql2 stockMT.scb stockMT.cbl
cobc -m stockMT.cbl cobmysqlapi.o -L/usr/local/mysql/lib -lmysqlclient -lz

