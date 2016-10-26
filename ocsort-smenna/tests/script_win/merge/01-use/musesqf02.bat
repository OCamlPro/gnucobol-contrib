@echo off
:: musesqf02.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: sort generated data 
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf02_cbl.srt
set dd_sortwork=%filedir%\susesqf02_srt.srt
%exedir%\musesqf02a 
set dd_infile=
set dd_outfile=
set dd_sortwork=

:: clone file
copy /y %filedir%\susesqf02_cbl.srt   %filedir%\fsqf01.dat
copy /y %filedir%\susesqf02_cbl.srt   %filedir%\fsqf02.dat
copy /y %filedir%\susesqf02_cbl.srt   %filedir%\fsqf03.dat
:: empty copy /y "%filedir%\fsqf01 - empty.dat"   %filedir%\fsqf02.dat
:: empty copy /y "%filedir%\fsqf01 - empty.dat"   %filedir%\fsqf03.dat

:: merge
set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\musesqf02_cbl.mrg
set dd_mergework=%filedir%\musesqf02_mrg.mrg
%exedir%\musesqf02b 
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=
set dd_mergework=


:: ocsort

set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\musesqf02_ocs.mrg
echo MERGE FIELDS=(8,5,CH,A)                                                 >%takedir%\musesqf02.prm                                          
:: ok ok 
:: echo SUM FIELDS=(13,3,BI,16,4,FI,20,8,FL,28,4,PD,32,7,ZD)                   >>%takedir%\musesqf02.prm                                          
echo SUM FIELDS=(13,3,BI,       >>%takedir%\musesqf02.prm                                          
echo             16,4,FI,       >>%takedir%\musesqf02.prm                                          
echo             20,8,FL,       >>%takedir%\musesqf02.prm                                          
echo             28,4,PD,       >>%takedir%\musesqf02.prm                                          
echo             32,7,ZD,       >>%takedir%\musesqf02.prm                                          
echo             39,4,FL,       >>%takedir%\musesqf02.prm                                          
echo             43,7,CLO,      >>%takedir%\musesqf02.prm                                          
echo             50,8,CST,      >>%takedir%\musesqf02.prm                                          
echo             58,8,CSL       >>%takedir%\musesqf02.prm                                          
echo             )              >>%takedir%\musesqf02.prm                                          
echo USE  dd_infile1  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf02.prm                                          
echo USE  dd_infile2  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf02.prm                                          
echo USE  dd_infile3  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf02.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                                    >>%takedir%\musesqf02.prm                                          
%exedir%\ocsort TAKE %takedir%\musesqf02.prm
set rtc1=%errorlevel%
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\musesqf02_cbl.mrg
set dd_inocsort=%filedir%\musesqf02_ocs.mrg
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=
