
## :: 07-sumfields-ssumsqfbi01.bat

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqbi01=$filedir/sqbi01
$exedir/iosqbi01
export sqbi01=


./execsort.sh $takedir/sort/07-sumfields/ssumsqfbi01_take.prm  ssumsqfbi01
export rtc=$?
export sqbi01c=$filedir/sqbi01_07.srt
$exedir/iosqbi01c
./checkerr2.sh  
export rtc=$?
export sqbi01c= 