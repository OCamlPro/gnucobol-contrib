## GCSort
## Linux environment
## Generate parser GCSort 
##
#
#
./bison --defines=../parser.h -o ../parser.c parser.y
./flex  --header-file=../scanner.h   --debug  -o ../scanner.c scanner.l
