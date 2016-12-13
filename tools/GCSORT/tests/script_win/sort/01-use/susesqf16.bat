@echo off
:: susesqf16.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf16_cbl.srt
set dd_sortwork=%filedir%\susesqf16_srt.srt
%exedir%\susesqf16b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf16_ocs.srt

:: Sort references inrec position if present. This phase is executed after INREC.
echo SORT FIELDS=(8,5,CH,A)                                         >%takedir%\susesqf16.prm                                          
::                                                                 
echo USE  dd_infile     RECORD F,90 ORG SQ                         >>%takedir%\susesqf16.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                         >>%takedir%\susesqf16.prm                                          
echo INCLUDE COND=(8,2,CH,GT,C'GG',AND,13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,32,7,ZD,LT,40) >>%takedir%\susesqf16.prm
echo SUM FIELDS=(NONE)                                             >>%takedir%\susesqf16.prm                                          
echo OPTION SKIPREC=5                                              >>%takedir%\susesqf16.prm                                          
echo STOPAFT=15                                                     >>%takedir%\susesqf16.prm                                          
%exedir%\gcsort TAKE %takedir%\susesqf16.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: new record INREC
:: diffile2

set dd_incobol=%filedir%\susesqf16_cbl.srt
set dd_ingcsort=%filedir%\susesqf16_ocs.srt
%exedir%\diffile2
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=