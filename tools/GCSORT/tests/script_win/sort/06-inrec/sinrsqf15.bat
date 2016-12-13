@echo off
:: sinrsqf15.bat
set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp

set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: cobol sort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sinrsqf15_cbl.srt
set dd_sortwork=%filedir%\sinrsqf15_srt.srt
%exedir%\sinrsqf15b 
set dd_infile=
set dd_outfile=
set dd_sortwork=


:: gcsort
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\sinrsqf15_ocs.srt

:: Sort references inrec position if present. This phase is executed after INREC.
echo SORT FIELDS=(34,5,CH,A)                                        >%takedir%\sinrsqf15.prm                                          
::                                                                 
echo USE  dd_infile     RECORD F,90 ORG SQ                         >>%takedir%\sinrsqf15.prm                                          
echo GIVE dd_outfile    RECORD F,90 ORG SQ                         >>%takedir%\sinrsqf15.prm                                          
::                                                                 
::      05 in-seq-record        pic  9(07).              1      7      
::      05 in-ch-field          pic  x(5).               8      5      
::      05 in-bi-field          pic  9(7) comp.         13      3      
::      05 in-fi-field          pic s9(7) comp.         16      4      
::      05 in-fl-field          comp-2.                 20      8      
::      05 in-pd-field          pic s9(7) comp-3.       28      4      
::      05 in-zd-field          pic s9(7).              32      7      
echo                       *                                                   pos   len  >>%takedir%\sinrsqf15.prm   
echo INREC    FIELDS(1,7,  *   05 out-seq-record        pic  9(07).             1     7   >>%takedir%\sinrsqf15.prm
echo                32,7,  *   05 out-zd-field          pic s9(7).              8     7   >>%takedir%\sinrsqf15.prm
echo                20,8,  *   05 out-fl-field          comp-2.                15     8   >>%takedir%\sinrsqf15.prm
echo                16,4,  *   05 out-fi-field          pic s9(7) comp.        23     4   >>%takedir%\sinrsqf15.prm
echo                28,4,  *   05 out-pd-field          pic s9(7) comp-3.      27     4   >>%takedir%\sinrsqf15.prm
echo                13,3,  *   05 out-bi-field          pic  9(7) comp.        31     3   >>%takedir%\sinrsqf15.prm
echo                 8,5,  *   05 out-ch-field          pic  x(5).             34     5   >>%takedir%\sinrsqf15.prm
::echo                52Z)   *   05 ch-filler             pic  x(52).            39     52  >>%takedir%\sinrsqf15.prm
echo                 39,4, *   FL COMP-1  >>%takedir%\sinrsqf15.prm
echo                 43,7, *   CLO        >>%takedir%\sinrsqf15.prm                                          
echo                 50,8, *   CST        >>%takedir%\sinrsqf15.prm                                          
echo                 58,8, *   CSL        >>%takedir%\sinrsqf15.prm                                          
echo                 66,25)*   Filler     >>%takedir%\sinrsqf15.prm                                          
%exedir%\gcsort TAKE %takedir%\sinrsqf15.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=


:: new record INREC
:: diffile2

set dd_incobol=%filedir%\sinrsqf15_cbl.srt
set dd_ingcsort=%filedir%\sinrsqf15_ocs.srt
%exedir%\diffile2
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=