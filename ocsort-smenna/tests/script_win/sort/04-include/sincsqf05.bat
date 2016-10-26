@echo off
:: sincsqf05.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf05_cbl.srt
set dd_sortwork=%filedir%\sincsqf05_srt.srt
%exedir%\sincsqf05b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sincsqf05_ocs.srt

echo SORT FIELDS=(8,5,CH,A)                                         >%takedir%\sincsqf05.prm                                          
::                                                                 
echo USE  dd_infile     RECORD F,90 ORG SQ                         >>%takedir%\sincsqf05.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                         >>%takedir%\sincsqf05.prm                                          
::                                                                 
echo OUTREC FIELDS(1,7, >>%takedir%\sincsqf05.prm   
echo                32,7,    >>%takedir%\sincsqf05.prm   
echo                20,8,    >>%takedir%\sincsqf05.prm   
echo                16,4,    >>%takedir%\sincsqf05.prm   
echo                28,4,    >>%takedir%\sincsqf05.prm   
echo                13,3,    >>%takedir%\sincsqf05.prm   
echo                 8,5,    >>%takedir%\sincsqf05.prm   
::echo                52Z)  >>%takedir%\sincsqf05.prm                                          
echo                39,4,    >>%takedir%\sincsqf05.prm
echo                43,7,    >>%takedir%\sincsqf05.prm                                          
echo                50,8,    >>%takedir%\sincsqf05.prm                                          
echo                58,8,    >>%takedir%\sincsqf05.prm                                          
echo                66,25)   >>%takedir%\sincsqf05.prm                                          

%exedir%\ocsort TAKE %takedir%\sincsqf05.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: new record INREC
:: diffile2

set dd_incobol=%filedir%\sincsqf05_cbl.srt
set dd_inocsort=%filedir%\sincsqf05_ocs.srt
%exedir%\diffile2
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=