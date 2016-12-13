@echo off
:: musesqf03.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\musesqf03_cbl.srt
set dd_sortwork=%filedir%\musesqf03_srt.srt
%exedir%\musesqf03a 
set dd_infile=
set dd_outfile=
set dd_sortwork=

:: clone file
copy /y %filedir%\musesqf03_cbl.srt   %filedir%\fsqf01.dat
copy /y %filedir%\musesqf03_cbl.srt   %filedir%\fsqf02.dat
copy /y %filedir%\musesqf03_cbl.srt   %filedir%\fsqf03.dat

:: merge
set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\musesqf03_cbl.mrg
set dd_mergework=%filedir%\musesqf03_mrg.mrg
%exedir%\musesqf03b 
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=
set dd_mergework=


:: gcsort

set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\musesqf03_ocs.mrg
echo MERGE FIELDS=(8,5,CH,A)                                                      >%takedir%\musesqf03.prm                                          
:: echo SORT FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28,4,PD,A,32,7,ZD,D)  >%takedir%\merge\musesqf03.prm                                          
echo SUM FIELDS=(NONE)                                                      >>%takedir%\musesqf03.prm                                          
echo USE  dd_infile1  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf03.prm                                          
echo USE  dd_infile2  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf03.prm                                          
echo USE  dd_infile3  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf03.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf03.prm                                          
%exedir%\gcsort TAKE %takedir%\musesqf03.prm
set rtc1=%errorlevel%
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\musesqf03_cbl.mrg
set dd_ingcsort=%filedir%\musesqf03_ocs.mrg
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=
