@echo off
:: moutsqf10a.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\moutsqf10_cbl.srt
set dd_sortwork=%filedir%\moutsqf10_srt.srt
%exedir%\moutsqf10a
set dd_infile=
set dd_outfile=
set dd_sortwork=

:: clone file
copy /y %filedir%\moutsqf10_cbl.srt   %filedir%\fsqf01.dat
copy /y %filedir%\moutsqf10_cbl.srt   %filedir%\fsqf02.dat
copy /y %filedir%\moutsqf10_cbl.srt   %filedir%\fsqf03.dat

:: merge
set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\moutsqf10_cbl.mrg
set dd_mergework=%filedir%\moutsqf10_mrg.mrg
%exedir%\moutsqf10b 
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=
set dd_mergework=


:: ocsort

set dd_infile1=%filedir%\fsqf01.dat 
set dd_infile2=%filedir%\fsqf02.dat 
set dd_infile3=%filedir%\fsqf03.dat 
set dd_outfile=%filedir%\moutsqf10_ocs.mrg
echo MERGE FIELDS=(28,5,CH,A)                            >%takedir%\moutsqf10.prm                                          
echo OUTREC FIELDS=(C'FIELD SPEC',                      >>%takedir%\moutsqf10.prm     
echo                11:11,7,                            >>%takedir%\moutsqf10.prm     
echo                22:X,                               >>%takedir%\moutsqf10.prm     
echo                C'ALPHA',                           >>%takedir%\moutsqf10.prm     
echo                28,5,                               >>%takedir%\moutsqf10.prm     
echo                40:Z,                               >>%takedir%\moutsqf10.prm     
echo                3C'XYZ',                            >>%takedir%\moutsqf10.prm     
echo                X'7B',                              >>%takedir%\moutsqf10.prm     
echo                6Z,                                 >>%takedir%\moutsqf10.prm     
echo                2X'3C2B3E',                         >>%takedir%\moutsqf10.prm     
echo                X'7D',                              >>%takedir%\moutsqf10.prm     
echo                64,7,                               >>%takedir%\moutsqf10.prm     
echo                8X,                                 >>%takedir%\moutsqf10.prm     
echo                C'+',                               >>%takedir%\moutsqf10.prm     
echo                11X)                                >>%takedir%\moutsqf10.prm                                    
echo USE  dd_infile1  RECORD F,90 ORG SQ                >>%takedir%\moutsqf10.prm                                                    
echo USE  dd_infile2  RECORD F,90 ORG SQ                >>%takedir%\moutsqf10.prm                                                    
echo USE  dd_infile3  RECORD F,90 ORG SQ                >>%takedir%\moutsqf10.prm                               
echo GIVE dd_outfile  RECORD F,90 ORG SQ                >>%takedir%\moutsqf10.prm                                          
%exedir%\ocsort TAKE %takedir%\moutsqf10.prm
set rtc1=%errorlevel%
set dd_infile1=
set dd_infile2=
set dd_infile3=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\moutsqf10_cbl.mrg
set dd_inocsort=%filedir%\moutsqf10_ocs.mrg
%exedir%\diffile3
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=
