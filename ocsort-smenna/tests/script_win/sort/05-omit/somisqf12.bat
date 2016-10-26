@echo off
:: somisqf12.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf12_cbl.srt
set dd_sortwork=%filedir%\somisqf12_srt.srt
%exedir%\somisqf12b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: ocsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\somisqf12_ocs.srt
echo SORT FIELDS=(8,5,CH,A)                                                    >%takedir%\somisqf12.prm                                          
echo USE  dd_infile     RECORD F,90 ORG SQ                                    >>%takedir%\somisqf12.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                                    >>%takedir%\somisqf12.prm     
echo OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15) >>%takedir%\somisqf12.prm  
echo OUTREC FIELDS=(C'FIELD SPEC',                   >>%takedir%\somisqf12.prm        
echo                11:1,7,                          >>%takedir%\somisqf12.prm        
echo                22:X,                            >>%takedir%\somisqf12.prm        
echo                C'ALPHA',                        >>%takedir%\somisqf12.prm        
echo                8,5,                             >>%takedir%\somisqf12.prm        
echo                40:Z,                            >>%takedir%\somisqf12.prm        
echo                3C'XYZ',                         >>%takedir%\somisqf12.prm        
echo                X'7B',                           >>%takedir%\somisqf12.prm        
echo                6Z,                              >>%takedir%\somisqf12.prm        
echo                2X'3C2B3E',                      >>%takedir%\somisqf12.prm        
echo                X'7D',                           >>%takedir%\somisqf12.prm        
echo                32,7,                            >>%takedir%\somisqf12.prm        
echo                8X,                              >>%takedir%\somisqf12.prm        
echo                C'+',                            >>%takedir%\somisqf12.prm        
echo                11X)                             >>%takedir%\somisqf12.prm        
                                     
%exedir%\ocsort TAKE %takedir%\somisqf12.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: diffile

set dd_incobol=%filedir%\somisqf12_cbl.srt
set dd_inocsort=%filedir%\somisqf12_ocs.srt
%exedir%\diffile3
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=