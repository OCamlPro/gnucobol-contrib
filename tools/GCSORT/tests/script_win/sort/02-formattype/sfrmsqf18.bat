@echo off
:: sfrmsqf18.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sfrmsqf18_cbl.srt
set dd_sortwork=%filedir%\sfrmsqf18_srt.srt
%exedir%\sfrmsqf18b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sfrmsqf18_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\sfrmsqf18.prm                                          
echo     OMIT COND=(8,2,CH,LE,C'FF',AND,         >>%takedir%\sfrmsqf18.prm
echo                  39,4,FL,GT,-10,OR,            >>%takedir%\sfrmsqf18.prm
echo                  43,7,CLO,GT,10,AND,           >>%takedir%\sfrmsqf18.prm
echo                  50,8,CST,LE,-30,OR,            >>%takedir%\sfrmsqf18.prm
echo                  58,8,CSL,LE,10)               >>%takedir%\sfrmsqf18.prm
echo USE  dd_infile		RECORD F,90 ORG SQ          >>%takedir%\sfrmsqf18.prm                                          
echo GIVE dd_outfile 	RECORD F,90 ORG SQ          >>%takedir%\sfrmsqf18.prm                                          
%exedir%\gcsort TAKE %takedir%\sfrmsqf18.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\sfrmsqf18_cbl.srt
set dd_ingcsort=%filedir%\sfrmsqf18_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=