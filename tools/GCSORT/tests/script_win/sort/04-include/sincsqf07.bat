@echo off
:: sincsqf07.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf07_cbl.srt
set dd_sortwork=%filedir%\sincsqf07_srt.srt
%exedir%\sincsqf07b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf07_ocs.srt

echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\sincsqf07.prm
echo INCLUDE COND=(8,2,CH,GT,C'GG',AND,13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,32,7,ZD,LT,40) >>%takedir%\sincsqf07.prm
echo USE  dd_infile     RECORD F,90 ORG SQ   >>%takedir%\sincsqf07.prm                                                                            
echo GIVE dd_outfile    RECORD F,90 ORG SQ   >>%takedir%\sincsqf07.prm
echo SUM FIELDS=(NONE) >>%takedir%\sincsqf07.prm
%exedir%\gcsort TAKE %takedir%\sincsqf07.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\sincsqf07_cbl.srt
set dd_ingcsort=%filedir%\sincsqf07_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=