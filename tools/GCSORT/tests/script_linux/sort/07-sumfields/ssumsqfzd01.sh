## :: 07-sumfields-ssumsqfzd01

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux

export sqzd01=$filedir/sqzd01
$exedir/iosqzd01
export sqzd01=

./execsort.sh $takedir/sort/07-sumfields/ssumsqfzd01_take.prm  ssumsqfpd03
export rtc=$?
export sqzd01c=$filedir/sqzd01_07.srt
$exedir/iosqzd01c
./checkerr2.sh  
export rtc=$?
export sqzd01c= 