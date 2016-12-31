@echo off
:: sinrsqf14.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sinrsqf14_cbl.srt
set dd_sortwork=%filedir%\sinrsqf14_srt.srt
%exedir%\sinrsqf14b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sinrsqf14_ocs.srt

:: original echo SORT FIELDS=(8,5,CH,A)                                         >%takedir%\sinrsqf14.prm                                          
echo SORT FIELDS=(34,5,CH,A)                                         >%takedir%\sinrsqf14.prm                                          
::                                                                 
:: 32,7,ZD,20,8,FL,16,4,FI,28,4,PD,13,3,BI,8,2,CH                  
::                                                                 
echo USE  dd_infile     RECORD F,90 ORG SQ                         >>%takedir%\sinrsqf14.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                         >>%takedir%\sinrsqf14.prm                                          
::                                                                 
::      01 infile-record-cbl.                                      
::           05 in1-seq-record        pic  9(07).                  
::           05 in1-zd-field          pic s9(7).                   
::           05 in1-fl-field          comp-2.                      
::           05 in1-fi-field          pic s9(7) comp.              
::           05 in1-pd-field          pic s9(7) comp-3.            
::           05 in1-bi-field          pic  9(7) comp.              
::           05 in1-ch-field          pic  x(5).                   
:: echo INREC FIELDS(1,7,32,7,20,8,16,4,28,4,13,3,8,5,52Z)       >>%takedir%\sinrsqf14.prm
echo                        *                                                   pos   len    >>%takedir%\sinrsqf14.prm                                                                      
echo    INREC FIELDS(1,7,   *   05 in-seq-record        pic  9(07).              1      7    >>%takedir%\sinrsqf14.prm      
echo                32,7,   *   05 in-ch-field          pic  x(5).               8      5    >>%takedir%\sinrsqf14.prm      
echo                20,8,   *   05 in-bi-field          pic  9(7) comp.         13      3    >>%takedir%\sinrsqf14.prm      
echo                16,4,   *   05 in-fi-field          pic s9(7) comp.         16      4    >>%takedir%\sinrsqf14.prm      
echo                28,4,   *   05 in-fl-field          comp-2.                 20      8    >>%takedir%\sinrsqf14.prm      
echo                13,3,   *   05 in-pd-field          pic s9(7) comp-3.       28      4    >>%takedir%\sinrsqf14.prm      
echo                 8,5,   *   05 in-zd-field          pic s9(7).              32      7    >>%takedir%\sinrsqf14.prm      
::echo                52Z)   *   05 ch-filler             pic  x(52).            39     52  >>%takedir%\sinrsqf14.prm
echo                 39,4, *   FL COMP-1  >>%takedir%\sinrsqf14.prm
echo                 43,7, *   CLO        >>%takedir%\sinrsqf14.prm                                          
echo                 50,8, *   CST        >>%takedir%\sinrsqf14.prm                                          
echo                 58,8, *   CSL        >>%takedir%\sinrsqf14.prm                                          
echo                 66,25)*   Filler     >>%takedir%\sinrsqf14.prm                                          
                                          
::,28,4,13,3,8,5,52Z)       >>%takedir%\sinrsqf14.prm                                          
%exedir%\gcsort TAKE %takedir%\sinrsqf14.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: new record INREC
:: diffile2

set dd_incobol=%filedir%\sinrsqf14_cbl.srt
set dd_ingcsort=%filedir%\sinrsqf14_ocs.srt
%exedir%\diffile2
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=