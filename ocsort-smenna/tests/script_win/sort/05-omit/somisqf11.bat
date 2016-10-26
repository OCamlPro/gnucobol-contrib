@echo off
:: somisqf11.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf11_cbl.srt
set dd_sortwork=%filedir%\somisqf11_srt.srt
%exedir%\somisqf11b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf11_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\somisqf11.prm                                          
::
echo OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15) >>%takedir%\somisqf11.prm  
:: test echo INCLUDE COND=(8,2,CH,EQ,C'GG')  >>%takedir%\somisqf11.prm                                          
echo USE  dd_infile     RECORD F,90 ORG SQ                                    >>%takedir%\somisqf11.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                                    >>%takedir%\somisqf11.prm                                          
%exedir%\ocsort TAKE %takedir%\somisqf11.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\somisqf11_cbl.srt
set dd_inocsort=%filedir%\somisqf11_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=