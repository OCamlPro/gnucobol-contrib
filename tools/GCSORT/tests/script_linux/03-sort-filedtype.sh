##@echo off
export rtc=0

if [ $rtc -eq 0 ] ; then   
	./execsort.sh ../takefile_linux/sort/03-filetype/sflbifbi01_take.prm   sflbifbi01
fi

#:: -eq-eq-eq-eq-eq-eq-eq-eq conversion file type ix
#:: ls -> ix
export inp002ix=../files/inp002ix
if [ $rtc -eq 0 ] ; then    
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflixlsix01_take.prm  sflixlsix01
fi
#:: ix -> sq
export inp002ix=../files/inp002ix
if [ $rtc -eq 0  ]; then   
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflixixsq02_take.prm  sflixixsq02
fi
#:: sq -> ls
if [ $rtc -eq 0  ]; then   
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflixsqls03_take.prm  sflixsqls03
fi
#:: check / compare input first step with output third step
#:: comp (windows) - diff (linux)


#:: -eq-eq-eq-eq-eq-eq-eq-eq conversion file type rl
#:: ls -> rl
if [ $rtc -eq 0 ]; then    
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflrllsrl01_take.prm  sflrllsrl01
fi
#:: rl -> sq
if [ $rtc -eq 0 ]; then    
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflrlrlsq02_take.prm  sflrlrlsq02
fi
#:: sq -> ls
if [ $rtc -eq 0 ]; then    
	./execsort.sh  ../takefile_linux/sort/03-filetype/sflrlsqls03_take.prm  sflrlsqls03
fi
#:: check / compare input first step with output third step
#:: comp (windows) - diff (linux)


