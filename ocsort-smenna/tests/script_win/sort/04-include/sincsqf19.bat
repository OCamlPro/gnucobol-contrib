@echo off
:: sincsqf19.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf19_cbl.srt
set dd_sortwork=%filedir%\sincsqf19_srt.srt
%exedir%\sincsqf19b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf19_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\sincsqf19.prm                                          
::
echo INCLUDE COND=(8,4,CH,SS,C'DDDD,GGGG,HHHH,JJJJ,OOOO')                     >>%takedir%\sincsqf19.prm                                          
echo USE  dd_infile     RECORD F,90 ORG SQ                                    >>%takedir%\sincsqf19.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                                    >>%takedir%\sincsqf19.prm                                          
%exedir%\ocsort TAKE %takedir%\sincsqf19.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\sincsqf19_cbl.srt
set dd_inocsort=%filedir%\sincsqf19_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=