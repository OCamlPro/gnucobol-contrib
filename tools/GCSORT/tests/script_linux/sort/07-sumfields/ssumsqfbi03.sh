
## :: 07-sumfields-ssumsqfbi03.bat

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqbi03=$filedir/sqbi03
$exedir/iosqbi03
export sqbi03=

./execsort.sh $takedir/sort/07-sumfields/ssumsqfbi03_take.prm  ssumsqfbi03
export rtc=$?
export sqbi03c=$filedir/sqbi03_07.srt
$exedir/iosqbi03c
./checkerr2.sh  
export rtc=$?
export sqbi03c= 