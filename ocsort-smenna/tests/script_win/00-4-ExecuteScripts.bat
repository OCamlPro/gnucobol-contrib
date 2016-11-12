
:: 
@echo off

SET OCSORT_STATISTICS=1


if exist ..\log\test_failed.log del ..\log\test_failed.log
if exist ..\log\ferr.log        del ..\log\ferr.log 
echo * ======================== *
echo   start Group 1
echo * ======================== *

call 01-sort-use.bat
call 02-sort-formattype.bat
call 03-sort-filedtype.bat
call 04-sort-include.bat
call 05-sort-omit.bat
call 06-sort-inrec.bat
call 07-sort-sumfields.bat
call 08-sort-outrec.bat
call 09-sort-option.bat
call 10-sort-outfil.bat

echo * ======================== *
echo   end Group 1
echo * ======================== *

:::::
::@echo off
set rtc1=0
set rtc2=0
set logfile=..\log\logexecution.log
if exist ..\log\logexecution.log del ..\log\logexecution.log
if exist ..\log\ferr.log  del ..\log\ferr.log



echo * ======================== *
echo   start Group 2
echo * ======================== *
echo * ======================== *
echo * SORT                     *
echo * ======================== *
:: exec all tests call genfile
:: sort
echo * ======================== *
echo   01-use\susesqf01 
echo * ======================== *
call sort\01-use\susesqf01  >>%logfile%
call checkerr 
echo * ======================== *
echo   01-use\susesqf02	                                   
echo * ======================== *
call sort\01-use\susesqf02  >>%logfile%	                       
call checkerr 
echo * ======================== *
echo   01-use\susesqf03	                                   
echo * ======================== *
call sort\01-use\susesqf03  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   01-use\susesqf16
echo * ======================== *
call sort\01-use\susesqf16  >>%logfile%                         
call checkerr 

echo * ======================== *
echo   02-formattype\sfrmsqf17
echo * ======================== *
call sort\02-formattype\sfrmsqf17  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   02-formattype\sfrmsqf18
echo * ======================== *
call sort\02-formattype\sfrmsqf18  >>%logfile%                         
call checkerr 

echo * ======================== *
echo   04-include\sincsqf04                                  
echo * ======================== *
call sort\04-include\sincsqf04  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   04-include\sincsqf05                                  
echo * ======================== *
call sort\04-include\sincsqf05  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   04-include\sincsqf06                                  
echo * ======================== *
call sort\04-include\sincsqf06  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   04-include\sincsqf07                                  
echo * ======================== *
call sort\04-include\sincsqf07  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   04-include\sincsqf08                                  
echo * ======================== *
call sort\04-include\sincsqf08  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   04-include\sincsqf19                                 
echo * ======================== *
call sort\04-include\sincsqf19  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   05-omit\somisqf09                                  
echo * ======================== *
call sort\05-omit\somisqf09  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   05-omit\somisqf11                              
echo * ======================== *
call sort\05-omit\somisqf11  >>%logfile%
call checkerr 
echo * ======================== *
echo   05-omit\somisqf12                              
echo * ======================== *
call sort\05-omit\somisqf12  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   05-omit\somisqf13                              
echo * ======================== *
call sort\05-omit\somisqf13  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   06-inrec\sinrsqf14                                  
echo * ======================== *
call sort\06-inrec\sinrsqf14  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   06-inrec\sinrsqf15                                  
echo * ======================== *
call sort\06-inrec\sinrsqf15  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   08-outrec\soutsqf10                                  
echo * ======================== *
call sort\08-outrec\soutsqf10  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   10-outfil\soutfsqf01                                  
echo * ======================== *
call sort\10-outfil\soutfsqf01  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   10-outfil\soutfsqf02
echo * ======================== *
call sort\10-outfil\soutfsqf02  >>%logfile%
call checkerr 
echo * ======================== *
echo   10-outfil\soutfsqf03
echo * ======================== *
call sort\10-outfil\soutfsqf03  >>%logfile%
call checkerr 
echo * ======================== *
echo   10-outfil\soutfsqf04
echo * ======================== *
call sort\10-outfil\soutfsqf04  >>%logfile%
call checkerr 
echo * ======================== *
echo   10-outfil\soutfsqf05
echo * ======================== *
call sort\10-outfil\soutfsqf05  >>%logfile%
call checkerr 


:: merge            
echo * ======================== *
echo * ======================== *
echo * MERGE                    *
echo * ======================== *
echo * ======================== *
echo   01-use\musesqf01                                 
echo * ======================== *
call merge\01-use\musesqf01  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   01-use\musesqf02                                  
echo * ======================== *
call merge\01-use\musesqf02  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   01-use\musesqf03                                  
echo * ======================== *
call merge\01-use\musesqf03  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   08-outrec\moutsqf10                                  
echo * ======================== *
call merge\08-outrec\moutsqf10  >>%logfile%                         
call checkerr 
echo * ======================== *
echo   end Group 2
echo * ======================== *

echo * ======================== *
if NOT exist ..\log\test_failed.log  echo  Group 1   TEST PASSED 
if     exist ..\log\test_failed.log  echo  Group 1   TEST FAILED 
echo * ======================== *
if     exist ..\log\ferr.log  echo  Group 2   TEST FAILED 
if NOT exist ..\log\ferr.log  echo  Group 2   TEST PASSED 
echo * ======================== *



