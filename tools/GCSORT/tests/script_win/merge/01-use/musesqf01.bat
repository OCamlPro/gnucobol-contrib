@echo off
:: musesqf01.bat
set takedir=..\takefile_win\tmp

set dd_outfile=..\files\fsqf01.dat
..\bin\genfile
set dd_outfile=

set dd_infile=..\files\fsqf01.dat 
set dd_outfile=..\files\susesqf01_cbl.srt
set dd_sortwork=..\files\susesqf01_srt.srt
..\bin\musesqf01a 
set dd_infile=
set dd_outfile=
set dd_sortwork=

:: clone file
copy /y ..\files\susesqf01_cbl.srt   ..\files\fsqf01.dat
copy /y ..\files\susesqf01_cbl.srt   ..\files\fsqf02.dat
copy /y ..\files\susesqf01_cbl.srt   ..\files\fsqf03.dat

:: merge
set dd_infile1=..\files\fsqf01.dat 
set dd_infile2=..\files\fsqf02.dat 
set dd_infile3=..\files\fsqf03.dat 
set dd_outfile=..\files\musesqf01_cbl.mrg
set dd_mergework=..\files\musesqf01_mrg.mrg
..\bin\musesqf01b 
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=
set dd_mergework=


:: gcsort

set dd_infile1=..\files\fsqf01.dat 
set dd_infile2=..\files\fsqf02.dat 
set dd_infile3=..\files\fsqf03.dat 
set dd_outfile=..\files\musesqf01_ocs.mrg
:: echo MERGE FIELDS=(8,5,CH,A)                                                   >..\takefile_win\susesqf01.prm                                          
echo MERGE FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28,4,PD,A,32,7,ZD,D)  >%takedir%\musesqf01.prm                                          

echo USE  dd_infile1	RECORD F,90 ORG SQ                                    >>%takedir%\musesqf01.prm                                          
echo USE  dd_infile2	RECORD F,90 ORG SQ                                    >>%takedir%\musesqf01.prm                                          
echo USE  dd_infile3	RECORD F,90 ORG SQ                                    >>%takedir%\musesqf01.prm                                          
echo GIVE dd_outfile 	RECORD F,90 ORG SQ                                    >>%takedir%\musesqf01.prm                                          
..\bin\gcsort TAKE %takedir%\musesqf01.prm
set rtc1=%errorlevel%
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=


:: diffile

set dd_incobol=..\files\musesqf01_cbl.mrg
set dd_ingcsort=..\files\musesqf01_ocs.mrg
..\bin\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=
