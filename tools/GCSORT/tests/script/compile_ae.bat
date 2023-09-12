:: To compile setup program

 cobc -x -t ../listing/%1.lst -I ../copy -Wall -fintrinsics=ALL -fsign=EBCDIC  -fdefault-colseq=EBCDIC -febcdic-table=DEFAULT -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/%1AE ../src/%1.cbl 

