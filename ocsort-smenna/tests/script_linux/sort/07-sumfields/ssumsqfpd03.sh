## :: 07-sumfields-ssumsqfpd03

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqpd03=$filedir/sqpd03
$exedir/iosqpd03
export sqpd03=

./execsort.sh $takedir/sort/07-sumfields/ssumsqfpd03_take.prm  ssumsqfpd03
export rtc=$?
export sqpd03c=$filedir/sqpd03_07.srt
$exedir/iosqpd03c
./checkerr2.sh  
export rtc=$?
export sqpd03c= 