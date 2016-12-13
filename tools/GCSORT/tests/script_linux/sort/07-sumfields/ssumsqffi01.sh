
## :: 07-sumfields-ssumsqffi01.bat

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqfi01=$filedir/sqfi01
$exedir/iosqfi01
export sqfi01=


./execsort.sh $takedir/sort/07-sumfields/ssumsqffi01_take.prm  ssumsqffi01
export rtc=$?
export sqfi01c=$filedir/sqfi01_07.srt
$exedir/iosqfi01c
./checkerr2.sh  
export rtc=$?
export sqfi01c= 