export rtc=$?
if [ $rtc -eq 25 ] ; then     
	echo "$1 .... (FAILED) "
fi
if [ $rtc -eq 25 ] ; then     
	echo "$1 .... (FAILED) " >>../log/test_failed.log
fi
if [ $rtc -eq 0 ] ; then      
	echo "$1 .... (OK)     "
fi
