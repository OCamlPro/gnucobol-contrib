## :: 07-sumfields-ssumsqfpd01

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqpd01=$filedir/sqpd01
$exedir/iosqpd01
export sqpd01=

./execsort.sh $takedir/sort/07-sumfields/ssumsqfpd01_take.prm  ssumsqfpd01
export rtc=$?
export sqpd01c=$filedir/sqpd01_07.srt
$exedir/iosqpd01c
export rtc=$?
./checkerr2.sh  
export sqpd01c= 


