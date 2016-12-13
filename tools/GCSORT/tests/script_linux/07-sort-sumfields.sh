#:: 07-sumfields
#@echo off
export rtc=0

if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqfbi01.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqfbi03.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqffi01.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqffi03.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqffl01.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqfpd01.sh
fi
if [ $rtc -eq 0 ] ; then    
	 ./sort/07-sumfields/ssumsqfpd03.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqfzd01.sh
fi
if [ $rtc -eq 0 ] ; then     
	./sort/07-sumfields/ssumsqfzd03.sh
fi
if [ $rtc -eq 0 ] ; then    
	./execsort.sh ../takefile_linux/sort/07-sumfields/ssumsqfmlt01_take.prm ssumsqfmlt01
fi
if [ $rtc -eq 0 ] ; then    
	./execsort.sh ../takefile_linux/sort/07-sumfields/ssumsqfmlt02_take.prm ssumsqfmlt02
fi
if [ $rtc -eq 0 ] ; then    
	./execsort.sh ../takefile_linux/sort/07-sumfields/ssumsqfmlt04_take.prm ssumsqfmlt04
fi

