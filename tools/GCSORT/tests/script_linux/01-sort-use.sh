#@echo off
export logfile=../log/logexecution.log
export rtc=0
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/01-use/susesqvmlt01_take.prm  susesqvmlt01	
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/01-use/susesqvmlt02_take.prm  susesqvmlt02	
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/01-use/susesqvmlt03_take.prm  susesqvmlt03	
fi

