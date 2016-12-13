
###:: @echo off

export GCSORT_STATISTICS=1


if [ -e ../log/test_failed.log ] ; 
	then rm  ../log/test_failed.log
fi
if [ -e ../log/ferr.log ] ; 
	then rm  ../log/ferr.log 
fi
echo "* ======================== *"
echo "  start Group 1"
echo "* ======================== *"

./01-sort-use.sh
./02-sort-formattype.sh
./03-sort-filedtype.sh
./04-sort-include.sh
./05-sort-omit.sh
./06-sort-inrec.sh
./07-sort-sumfields.sh
./08-sort-outrec.sh
./09-sort-option.sh
./10-sort-outfil.sh

echo "* ======================== *"
echo "  end Group 1"
echo "* ======================== *"

##::##:::
##::@echo off
export rtc1=0
export rtc2=0
export logfile=../log/logexecution.log
if [ -e ../log/logexecution.log ] ; then
	rm  ../log/logexecution.log
fi
if [ -e ../log/ferr.log ] ; then
	rm  ../log/ferr.log
fi



echo "* ======================== *"
echo "  start Group 2             "
echo "* ======================== *"
echo "* ======================== *"
echo "* SORT                     *"
echo "* ======================== *"
echo "* ======================== *"
echo "  01-use/susesqf01          "
echo "* ======================== *"
./sort/01-use/susesqf01.sh  >>$logfile
./checkerr.sh
echo "* ======================== *"
echo "  01-use/susesqf02	      "                             
echo "* ======================== *"
./sort/01-use/susesqf02.sh  >>$logfile	                       
./checkerr.sh 
echo "* ======================== *"
echo "  01-use/susesqf03	      "                            
echo "* ======================== *"
./sort/01-use/susesqf03.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  01-use/susesqf16          "
echo "* ======================== *"
./sort/01-use/susesqf16.sh  >>$logfile                         
./checkerr.sh 

echo "* ======================== *"
echo "  02-formattype/sfrmsqf17   "
echo "* ======================== *"
./sort/02-formattype/sfrmsqf17.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  02-formattype/sfrmsqf18   "
echo "* ======================== *"
./sort/02-formattype/sfrmsqf18.sh  >>$logfile                         
./checkerr.sh 

echo "* ======================== *"
echo "  04-include/sincsqf04      "                            
echo "* ======================== *"
./sort/04-include/sincsqf04.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  04-include/sincsqf05      "                            
echo "* ======================== *"
./sort/04-include/sincsqf05.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  04-include/sincsqf06      "                            
echo "* ======================== *"
./sort/04-include/sincsqf06.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  04-include/sincsqf07      "                            
echo "* ======================== *"
./sort/04-include/sincsqf07.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  04-include/sincsqf08      "                            
echo "* ======================== *"
./sort/04-include/sincsqf08.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  04-include/sincsqf19      "                            
echo "* ======================== *"
./sort/04-include/sincsqf19.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  05-omit/somisqf09         "                         
echo "* ======================== *"
./sort/05-omit/somisqf09.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  05-omit/somisqf11         "                     
echo "* ======================== *"
./sort/05-omit/somisqf11.sh  >>$logfile
./checkerr.sh 
echo "* ======================== *"
echo "  05-omit/somisqf12         "                     
echo "* ======================== *"
./sort/05-omit/somisqf12.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  05-omit/somisqf13         "                     
echo "* ======================== *"
./sort/05-omit/somisqf13.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  06-inrec/sinrsqf14        "                          
echo "* ======================== *"
./sort/06-inrec/sinrsqf14.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  06-inrec/sinrsqf15        "                          
echo "* ======================== *"
./sort/06-inrec/sinrsqf15.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  08-outrec/soutsqf10       "                           
echo "* ======================== *"
./sort/08-outrec/soutsqf10.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  10-outfil/soutfsqf01      "                            
echo "* ======================== *"
./sort/10-outfil/soutfsqf01.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  10-outfil/soutfsqf02      "
echo "* ======================== *"
./sort/10-outfil/soutfsqf02.sh  >>$logfile
./checkerr.sh 
echo "* ======================== *"
echo "  10-outfil/soutfsqf03      "
echo "* ======================== *"
./sort/10-outfil/soutfsqf03.sh  >>$logfile
./checkerr.sh 
echo "* ======================== *"
echo "  10-outfil/soutfsqf04      "
echo "* ======================== *"
./sort/10-outfil/soutfsqf04.sh  >>$logfile
./checkerr.sh 
echo "* ======================== *"
echo "  10-outfil/soutfsqf05      "
echo "* ======================== *"
./sort/10-outfil/soutfsqf05.sh  >>$logfile
./checkerr.sh 

## ##:: merge            
echo "* ======================== *"
echo "* ======================== *"
echo "* MERGE                    *"
echo "* ======================== *"
echo "* ======================== *"
echo "  01-use/musesqf01          "                      
echo "* ======================== *"
./merge/01-use/musesqf01.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  01-use/musesqf02          "                       
echo "* ======================== *"
./merge/01-use/musesqf02.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  01-use/musesqf03          "                       
echo "* ======================== *"
./merge/01-use/musesqf03.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  08-outrec/moutsqf10       "                           
echo "* ======================== *"
./merge/08-outrec/moutsqf10.sh  >>$logfile                         
./checkerr.sh 
echo "* ======================== *"
echo "  end Group 2               "
echo "* ======================== *"

echo "* ======================== *"
if [ ! -e ../log/test_failed.log ] ; then 
	 echo " Group 1   TEST PASSED "
fi
if [ -e ../log/test_failed.log  ] ; then
	echo " Group 1   TEST FAILED "
fi
echo "* ======================== *"
if [ -e ../log/ferr.log ] ; then 
	 echo " Group 2   TEST FAILED "
fi
if [ ! -e ../log/ferr.log ] ; then
	 echo " Group 2   TEST PASSED "
fi
echo "* ======================== *"
