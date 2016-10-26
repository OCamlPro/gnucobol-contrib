@echo off
:: soutsqf10.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutsqf10_cbl.srt
set dd_sortwork=%filedir%\soutsqf10_srt.srt
%exedir%\soutsqf10b
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile1=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutsqf10_ocs.srt                                               
echo SORT FIELDS=(8,5,CH,A)                           >%takedir%\soutsqf10.prm        
echo OUTREC FIELDS=(C'FIELD SPEC',                   >>%takedir%\soutsqf10.prm        
echo                11:1,7,                          >>%takedir%\soutsqf10.prm        
echo                22:X,                            >>%takedir%\soutsqf10.prm        
echo                C'ALPHA',                        >>%takedir%\soutsqf10.prm        
echo                8,5,                             >>%takedir%\soutsqf10.prm        
echo                40:Z,                            >>%takedir%\soutsqf10.prm        
echo                3C'XYZ',                         >>%takedir%\soutsqf10.prm        
echo                X'7B',                           >>%takedir%\soutsqf10.prm        
echo                6Z,                              >>%takedir%\soutsqf10.prm        
echo                2X'3C2B3E',                      >>%takedir%\soutsqf10.prm        
echo                X'7D',                           >>%takedir%\soutsqf10.prm        
echo                32,7,                            >>%takedir%\soutsqf10.prm        
echo                8X,                              >>%takedir%\soutsqf10.prm        
echo                C'+',                            >>%takedir%\soutsqf10.prm        
echo                11X)                             >>%takedir%\soutsqf10.prm        
echo USE  dd_infile1  RECORD F,90 ORG SQ             >>%takedir%\soutsqf10.prm        
echo GIVE dd_outfile  RECORD F,90 ORG SQ             >>%takedir%\soutsqf10.prm        
%exedir%\ocsort TAKE %takedir%\soutsqf10.prm
set rtc1=%errorlevel%
set dd_infile1=
set dd_outfile=


:: diffile
set dd_incobol=%filedir%\soutsqf10_cbl.srt
set dd_inocsort=%filedir%\soutsqf10_ocs.srt
%exedir%\diffile3
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=
