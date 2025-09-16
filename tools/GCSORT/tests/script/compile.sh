#: setup folders
mkdir -p ../bin
mkdir -p ../listing
mkdir -p ../files
mkdir -p ../log
mkdir -p ../takefile/tmp

cd ../bin
COBC_FLAGS="-fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian"

#: To compile setup program
cobc -x $COBC_FLAGS -t ../listing/gctestset.lst -I ../copy -Wall ../src/gctestset.cbl
cobc -x $COBC_FLAGS ../src/gcsysop.c
cobc -m $COBC_FLAGS  ../src/gctestgetop.cbl

./gcsysop
