:: To compile setup program
:: cobc -x -t ../listing/gctestset.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestset ../src/gctestset.cbl 
:: cobc -x -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gcsysop.exe ../src/gcsysop.c
:: cobc -m -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestgetop.dll ../src/gctestgetop.cbl


 cobc -x -t ../listing/%1.lst -I ../copy -Wall -fintrinsics=ALL -fsign=EBCDIC  -fdefault-colseq=EBCDIC -febcdic-table=DEFAULT -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/%1 ../src/%1.cbl 

