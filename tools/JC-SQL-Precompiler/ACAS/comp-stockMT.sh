presql2M stockMT.scb stockMT.cbl
cobc -m stockMT.cbl cobmysqlapi.o -L/usr/lib64 -lmysqlclient -lz

