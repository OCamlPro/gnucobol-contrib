## @echo off
export rtc=0
if [ $rtc -eq 0 ] ; then  
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfbi01_take.prm  sftsqfbi01
fi
if [ $rtc -eq 0 ] ; then 
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfbi03_take.prm  sftsqfbi03
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqffl01_take.prm  sftsqffl01
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfpd01_take.prm  sftsqfpd01
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfpd03_take.prm  sftsqfpd03
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfzd01_take.prm  sftsqfzd01
fi
if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/02-formattype/sftsqfzd03_take.prm  sftsqfzd03
fi

