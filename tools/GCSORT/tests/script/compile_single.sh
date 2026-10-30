#  to compile single program
#  parameter is cobol program name (presents in ../src)

## cobc -x -t ../listing/$1.lst -I ../copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -O2 -o ../bin/$1 ../src/$1.cbl 
cobc -x -std=mf -fbinary-size=2-4-8  -Wall  -fnotrunc -fbinary-byteorder=big-endian -t ../listing/%1.lst -I ../copy -o ../bin/%1.exe ../src/%1.cbl  

