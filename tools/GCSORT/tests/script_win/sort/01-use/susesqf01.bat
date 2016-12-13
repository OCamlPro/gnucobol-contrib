::@echo off
:: susesqf01.bat

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp


set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf01_cbl.srt
set dd_sortwork=%filedir%\susesqf01_srt.srt
%exedir%\susesqf01b 
set dd_infile=
set dd_outfile=
set dd_sortwork=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf01_ocs.srt
echo SORT FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28,4,PD,A,32,7,ZD,D) >%takedir%\susesqf01.prm                                          
echo USE  dd_infile   RECORD F,90 ORG SQ                                     >>%takedir%\susesqf01.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                                     >>%takedir%\susesqf01.prm                                          
%exedir%\gcsort TAKE %takedir%\susesqf01.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\susesqf01_cbl.srt
set dd_ingcsort=%filedir%\susesqf01_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=