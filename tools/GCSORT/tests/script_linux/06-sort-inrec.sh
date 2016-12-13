
#@echo off
export rtc=0
if [ $rtc -eq 0 ] ; then  
	./execsort.sh ../takefile_linux/sort/06-inrec/sinrsqfch01_take.prm    sinrsqfch01
fi
if [ $rtc -eq 0 ] ; then
     	./execsort.sh ../takefile_linux/sort/06-inrec/sinrsqfmlt01_take.prm   sinrsqfmlt01
fi
if [ $rtc -eq 0 ] ; then
     	./execsort.sh ../takefile_linux/sort/06-inrec/sinrsqfmlt05_take.prm   sinrsqfmlt05
fi
