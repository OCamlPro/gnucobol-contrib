
## :: 07-sumfields-ssumsqffl01.bat

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqfl01=$filedir/sqfl01
$exedir/iosqfl01
export sqfl01=

./execsort.sh $takedir/sort/07-sumfields/ssumsqffl01_take.prm  ssumsqffl01
export rtc=$?
export sqfl01c=$filedir/sqfl01_07.srt
$exedir/iosqfl01c
./checkerr2.sh  
export rtc=$?
export sqfl01c= 