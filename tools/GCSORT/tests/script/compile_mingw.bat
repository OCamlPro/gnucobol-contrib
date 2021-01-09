#: To compile setup program
cobc -x -t ../listing/gctestsetup.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestsetup ../src/gctestsetup.cbl
cobc -x -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gcsysop.exe ../src/gcsysop.c
cobc -m -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestgetop.dll ../src/gctestgetop.cbl
cd ../bin
./gcsysop

