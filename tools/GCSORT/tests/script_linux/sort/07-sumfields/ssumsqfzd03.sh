## :: 07-sumfields-ssumsqfzd03

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqzd03=$filedir/sqzd03
$exedir/iosqzd03
export sqzd03=

./execsort.sh $takedir/sort/07-sumfields/ssumsqfzd03_take.prm  ssumsqfpd03
export rtc=$?
export sqzd03c=$filedir/sqzd03_07.srt
$exedir/iosqzd03c
./checkerr2.sh  
export rtc=$?
export sqzd03c= 