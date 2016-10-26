@echo off
:: somisqf13.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf13_cbl.srt
set dd_sortwork=%filedir%\somisqf13_srt.srt
%exedir%\somisqf13b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf13_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\somisqf13.prm                                          
echo USE  dd_infile     RECORD F,90 ORG SQ                                    >>%takedir%\somisqf13.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                                    >>%takedir%\somisqf13.prm     
echo OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15) >>%takedir%\somisqf13.prm  
::echo SUM FIELDS=(13,3,BI,16,4,FI,20,8,FL,28,4,PD,32,7,ZD)                     >>%takedir%\somisqf13.prm   
echo SUM FIELDS=(13,3,BI,       >>%takedir%\somisqf13.prm                                          
echo             16,4,FI,       >>%takedir%\somisqf13.prm                                          
echo             20,8,FL,       >>%takedir%\somisqf13.prm                                          
echo             28,4,PD,       >>%takedir%\somisqf13.prm                                          
echo             32,7,ZD,       >>%takedir%\somisqf13.prm                                          
echo             39,4,FL,       >>%takedir%\somisqf13.prm                                          
echo             43,7,CLO,      >>%takedir%\somisqf13.prm                                          
echo             50,8,CST,      >>%takedir%\somisqf13.prm                                          
echo             58,8,CSL)      >>%takedir%\somisqf13.prm                                          
                                                                           
%exedir%\ocsort TAKE %takedir%\somisqf13.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\somisqf13_cbl.srt
set dd_inocsort=%filedir%\somisqf13_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=