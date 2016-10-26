@echo off
::
:: soutfsqf01.bat
:: Don't checked save file, but only include/omit conditions
::

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win\tmp


set dd_outfile=%filedir%\fsqf01.dat
%exedir%\genfile
set dd_outfile=

:: file1
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf01_cbl01.srt
set dd_sortwork=%filedir%\soutfsqf01_srt.srt
%exedir%\soutfsqf01b1
set dd_infile=
set dd_outfile=
set dd_sortwork=
:: file2
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf01_cbl02.srt
set dd_sortwork=%filedir%\soutfsqf01_srt.srt
%exedir%\soutfsqf01b2
set dd_infile=
set dd_outfile=
set dd_sortwork=
:: file3
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf01_cbl03.srt
set dd_sortwork=%filedir%\soutfsqf01_srt.srt
%exedir%\soutfsqf01b3
set dd_infile=
set dd_outfile=
set dd_sortwork=


set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf01_ocs.srt
set dd_outfil_01=%filedir%\soutfsqf01_ocs01.srt
set dd_outfil_02=%filedir%\soutfsqf01_ocs02.srt
set dd_outfil_03=%filedir%\soutfsqf01_ocs03.srt
set dd_outfil_save=%filedir%\soutfsqf01_ocs_save.srt

echo SORT FIELDS=(8,5,CH,A)                                   >%takedir%\soutfsqf01.prm                                          
echo USE  dd_infile   RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf01.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf01.prm   
echo OUTFIL INCLUDE =(8,2,CH,EQ,C'AA',AND,32,7,ZD,LT,20),    >>%takedir%\soutfsqf01.prm
echo         FILES=dd_outfil_01                              >>%takedir%\soutfsqf01.prm                                          
echo OUTFIL INCLUDE =(8,2,CH,EQ,C'GG',AND,32,7,ZD,LT,35),    >>%takedir%\soutfsqf01.prm
echo         FILES=dd_outfil_02                              >>%takedir%\soutfsqf01.prm                                          
echo OUTFIL INCLUDE =(8,2,CH,EQ,C'EE',AND,32,7,ZD,GT,-10),   >>%takedir%\soutfsqf01.prm
echo         FILES=dd_outfil_03                              >>%takedir%\soutfsqf01.prm                                          
echo OUTFIL FNAMES=dd_outfil_save,SAVE                       >>%takedir%\soutfsqf01.prm                                          

:: ocsort                                       
%exedir%\ocsort TAKE %takedir%\soutfsqf01.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=
set dd_outfil_01=
set dd_outfil_02=
set dd_outfil_03=
set dd_outfil_save=

echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf01_cbl01.srt
set dd_inocsort=%filedir%\soutfsqf01_ocs01.srt
echo %dd_incobol%
echo %dd_inocsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf01_cbl02.srt
set dd_inocsort=%filedir%\soutfsqf01_ocs02.srt
echo %dd_incobol%
echo %dd_inocsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf01_cbl03.srt
set dd_inocsort=%filedir%\soutfsqf01_ocs03.srt
echo %dd_incobol%
echo %dd_inocsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_inocsort=

:: end
:lbend
