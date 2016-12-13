@echo off
:: susesqf03.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf03_cbl.srt
set dd_sortwork=%filedir%\susesqf03_srt.srt
%exedir%\susesqf03b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf03_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\susesqf03.prm                                          
echo SUM FIELDS=(NONE)                                                        >>%takedir%\susesqf03.prm                                          
echo USE  dd_infile		RECORD F,90 ORG SQ                                    >>%takedir%\susesqf03.prm                                          
echo GIVE dd_outfile 	RECORD F,90 ORG SQ                                    >>%takedir%\susesqf03.prm                                          
%exedir%\gcsort TAKE %takedir%\susesqf03.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\susesqf03_cbl.srt
set dd_ingcsort=%filedir%\susesqf03_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=