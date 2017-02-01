:: To compile setup program
cobc -x -t ../listing/gctestsetup.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/gctestsetup ../src/gctestsetup.CBL 
