if [ $rtc1 -gt  0 ] ;  then   
	echo "error sort ....... (ko) " $rtc1 "  ERROR "
fi
if [ $rtc2 -gt  0 ] ;  then   
	echo "error diff file .. (ko) " $rtc2  " ERROR "
fi
if [ $rtc1 -eq 0 ] ;   then   
	echo "      sort ....... (ok) " $rtc1 
fi
if [ $rtc2 -eq 0 ] ;   then   
	echo "      diff file .. (ok) " $rtc2 
fi

if [ $rtc1 -gt  0 ] ;  then  
	echo "error " >>../log/ferr.log
fi
if [ $rtc2 -gt  0 ] ;  then  
	echo "error " >>../log/ferr.log
fi

