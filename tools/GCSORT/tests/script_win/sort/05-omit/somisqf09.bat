@echo off
:: somisqf09.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf09_cbl.srt
set dd_sortwork=%filedir%\somisqf09_srt.srt
%exedir%\somisqf09b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf09_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\somisqf09.prm                                          
::
echo OMIT COND=((8,2,CH,LT,C'GG',AND,13,3,BI,LT,15,AND,16,4,FI,GT,6),OR,(20,8,FL,GE,25,AND,28,4,PD,LE,18,AND,32,7,ZD,EQ,12)) >>%takedir%\somisqf09.prm 
echo USE  dd_infile     RECORD F,90 ORG SQ                                    >>%takedir%\somisqf09.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                                    >>%takedir%\somisqf09.prm                                          
%exedir%\gcsort TAKE %takedir%\somisqf09.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\somisqf09_cbl.srt
set dd_ingcsort=%filedir%\somisqf09_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=