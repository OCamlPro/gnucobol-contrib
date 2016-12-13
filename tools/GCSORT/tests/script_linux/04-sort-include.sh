#!/bin/bash

# @echo off
export rtc=0
if [ $rtc -eq 0 ] ; then   
	  ./execsort.sh ../takefile_linux/sort/04-include/sincsqfch01_take.prm   sincsqfch01
fi
if [ $rtc -eq 0 ] ; then  
	   ./execsort.sh ../takefile_linux/sort/04-include/sincsqfbi01_take.prm   sincsqfbi01
fi
if [ $rtc -eq 0 ] ; then 
	    ./execsort.sh ../takefile_linux/sort/04-include/sincsqffi01_take.prm   sincsqffi01
fi
if [ $rtc -eq 0 ] ; then    
	 ./execsort.sh ../takefile_linux/sort/04-include/sincsqffl01_take.prm   sincsqffl01
fi
if [ $rtc -eq 0 ] ; then   
	  ./execsort.sh ../takefile_linux/sort/04-include/sincsqfpd01_take.prm   sincsqfpd01
fi
if [ $rtc -eq 0 ] ; then   
	  ./execsort.sh ../takefile_linux/sort/04-include/sincsqfzd01_take.prm   sincsqfzd01
fi
if [ $rtc -eq 0 ] ; then   
	  ./execsort.sh ../takefile_linux/sort/04-include/sincsqfmlt03_take.prm  sincsqfmlt03
fi


