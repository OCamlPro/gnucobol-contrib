@echo off
:: sfrmsqf17.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sfrmsqf17_cbl.srt
set dd_sortwork=%filedir%\sfrmsqf17_srt.srt
%exedir%\sfrmsqf17b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sfrmsqf17_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\sfrmsqf17.prm                                          
echo     INCLUDE COND=(8,2,CH,LE,C'FF',AND,         >>%takedir%\sfrmsqf17.prm
echo                  39,4,FL,GT,-10,OR,            >>%takedir%\sfrmsqf17.prm
echo                  43,7,CLO,GT,10,AND,           >>%takedir%\sfrmsqf17.prm
echo                  50,8,CST,LE,-30,OR,            >>%takedir%\sfrmsqf17.prm
echo                  58,8,CSL,LE,10)               >>%takedir%\sfrmsqf17.prm
echo USE  dd_infile		RECORD F,90 ORG SQ          >>%takedir%\sfrmsqf17.prm                                          
echo GIVE dd_outfile 	RECORD F,90 ORG SQ          >>%takedir%\sfrmsqf17.prm                                          
%exedir%\ocsort TAKE %takedir%\sfrmsqf17.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\sfrmsqf17_cbl.srt
set dd_inocsort=%filedir%\sfrmsqf17_ocs.srt
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=