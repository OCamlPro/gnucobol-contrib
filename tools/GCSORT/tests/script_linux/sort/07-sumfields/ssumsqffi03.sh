## :: 07-sumfields-ssumsqffi03

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqfi03=$filedir/sqfi03
$exedir/iosqfi03
export sqfi03=

./execsort.sh $takedir/sort/07-sumfields/ssumsqffi03_take.prm  ssumsqffi03
export rtc=$?
export sqfi03c=$filedir/sqfi03_07.srt
$exedir/iosqfi03c
./checkerr2.sh  
export rtc=$?
export sqfi03c= 