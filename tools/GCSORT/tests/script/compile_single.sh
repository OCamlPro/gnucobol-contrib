#: to compile single program
#: parameter is cobol program name (presents in ../src)

cobc -x -t ../listing/$1.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ../bin/$1 ../src/$1.cbl 

