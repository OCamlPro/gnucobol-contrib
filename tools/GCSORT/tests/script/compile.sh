#: To compile setup program
cobc -x -t ../listing/gctestset.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestset ../src/gctestset.cbl
cobc -x -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gcsysop ../src/gcsysop.c
cobc -m -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestgetop.so ../src/gctestgetop.cbl
cd ../bin
./gcsysop


