@echo off
:: susesqf02.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf02_cbl.srt
set dd_sortwork=%filedir%\susesqf02_srt.srt
%exedir%\susesqf02b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\susesqf02_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\susesqf02.prm                                          
::echo SUM FIELDS=(13,3,BI,16,4,FI,20,8,FL,28,4,PD,32,7,ZD)                     >>%takedir%\susesqf02.prm                                          
echo SUM FIELDS=(13,3,BI,       >>%takedir%\susesqf02.prm                                          
echo             16,4,FI,       >>%takedir%\susesqf02.prm                                          
echo             20,8,FL,       >>%takedir%\susesqf02.prm                                          
echo             28,4,PD,       >>%takedir%\susesqf02.prm                                          
echo             32,7,ZD,       >>%takedir%\susesqf02.prm                                          
echo             39,4,FL,       >>%takedir%\susesqf02.prm                                          
echo             43,7,CLO,      >>%takedir%\susesqf02.prm                                          
echo             50,8,CST,      >>%takedir%\susesqf02.prm                                          
echo             58,8,CSL       >>%takedir%\susesqf02.prm                                          
echo             )              >>%takedir%\susesqf02.prm                                          
echo USE  dd_infile		RECORD F,90 ORG SQ                                    >>%takedir%\susesqf02.prm                                          
echo GIVE dd_outfile 	RECORD F,90 ORG SQ                                    >>%takedir%\susesqf02.prm                                          
%exedir%\ocsort TAKE %takedir%\susesqf02.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\susesqf02_cbl.srt
set dd_inocsort=%filedir%\susesqf02_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=