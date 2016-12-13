@echo off
::
:: soutfsqf02.bat
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
set dd_outfile=%filedir%\soutfsqf02_cbl01.srt
set dd_sortwork=%filedir%\soutfsqf02_srt.srt
%exedir%\soutfsqf02b1
set dd_infile=
set dd_outfile=
set dd_sortwork=
:: file2
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf02_cbl02.srt
set dd_sortwork=%filedir%\soutfsqf02_srt.srt
%exedir%\soutfsqf02b2
set dd_infile=
set dd_outfile=
set dd_sortwork=
:: file3
set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf02_cbl03.srt
set dd_sortwork=%filedir%\soutfsqf02_srt.srt
%exedir%\soutfsqf02b3
set dd_infile=
set dd_outfile=
set dd_sortwork=


set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf02_ocs.srt
set dd_outfil_01=%filedir%\soutfsqf02_ocs01.srt
set dd_outfil_02=%filedir%\soutfsqf02_ocs02.srt
set dd_outfil_03=%filedir%\soutfsqf02_ocs03.srt
set dd_outfil_save=%filedir%\soutfsqf02_ocs_save.srt

echo SORT FIELDS=(8,5,CH,A)                                   >%takedir%\soutfsqf02.prm                                          
echo USE  dd_infile   RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf02.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf02.prm   
echo OUTFIL OMIT =(8,2,CH,EQ,C'AA',AND,32,7,ZD,LT,20),       >>%takedir%\soutfsqf02.prm
echo         FILES=dd_outfil_01                              >>%takedir%\soutfsqf02.prm                                          
echo OUTFIL OMIT =(8,2,CH,EQ,C'GG',AND,32,7,ZD,LT,35),       >>%takedir%\soutfsqf02.prm
echo         FILES=dd_outfil_02                              >>%takedir%\soutfsqf02.prm                                          
echo OUTFIL OMIT =(8,2,CH,EQ,C'EE',AND,32,7,ZD,GT,-10),      >>%takedir%\soutfsqf02.prm
echo         FILES=dd_outfil_03                              >>%takedir%\soutfsqf02.prm                                          
echo OUTFIL FNAMES=dd_outfil_save,SAVE                       >>%takedir%\soutfsqf02.prm                                          

:: gcsort                                       
%exedir%\gcsort TAKE %takedir%\soutfsqf02.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=
set dd_outfil_01=
set dd_outfil_02=
set dd_outfil_03=
set dd_outfil_save=

echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf02_cbl01.srt
set dd_ingcsort=%filedir%\soutfsqf02_ocs01.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf02_cbl02.srt
set dd_ingcsort=%filedir%\soutfsqf02_ocs02.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf02_cbl03.srt
set dd_ingcsort=%filedir%\soutfsqf02_ocs03.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

:: end
:lbend
