@echo off
::
:: soutfsqf03.bat
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
set dd_outfile=%filedir%\soutfsqf03_cbl.srt
set dd_outfile1=%filedir%\soutfsqf03_cbl01.srt
set dd_outfile2=%filedir%\soutfsqf03_cbl02.srt
set dd_outfile3=%filedir%\soutfsqf03_cbl03.srt
set dd_sortwork=%filedir%\soutfsqf03_srt.srt
%exedir%\soutfsqf03b
set dd_infile=
set dd_outfile=
set dd_outfile1=
set dd_outfile2=
set dd_outfile3=
set dd_sortwork=


set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf03_ocs.srt
set dd_outfil_01=%filedir%\soutfsqf03_ocs01.srt
set dd_outfil_02=%filedir%\soutfsqf03_ocs02.srt
set dd_outfil_03=%filedir%\soutfsqf03_ocs03.srt
set dd_outfil_save=%filedir%\soutfsqf03_ocs_save.srt

echo SORT FIELDS=(8,5,CH,A)                                       >%takedir%\soutfsqf03.prm                                          
echo USE  dd_infile   RECORD F,90 ORG SQ                         >>%takedir%\soutfsqf03.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ                         >>%takedir%\soutfsqf03.prm   
echo OUTFIL FILES=dd_outfil_01,dd_outfil_02,dd_outfil_03,SPLIT,  >>%takedir%\soutfsqf03.prm   
echo INCLUDE=(8,2,CH,EQ,C'AA',AND,32,7,ZD,LT,20)                 >>%takedir%\soutfsqf03.prm   
echo OUTFIL FNAMES=dd_outfil_save,SAVE                           >>%takedir%\soutfsqf03.prm                                          

::echo SORT FIELDS=(8,5,CH,A)                                   >%takedir%\soutfsqf03.prm                                          
::echo USE  dd_infile   RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf03.prm                                          
::echo GIVE dd_outfile  RECORD F,90 ORG SQ                     >>%takedir%\soutfsqf03.prm   
::echo OUTFIL FILES=dd_outfil_01                               >>%takedir%\soutfsqf03.prm                                          
::echo OUTFIL FILES=dd_outfil_02                               >>%takedir%\soutfsqf03.prm                                          
::echo OUTFIL FILES=dd_outfil_03                               >>%takedir%\soutfsqf03.prm                                          
::echo OUTFIL FNAMES=dd_outfil_save,SAVE                       >>%takedir%\soutfsqf03.prm                                          
::echo SPLIT                                                   >>%takedir%\soutfsqf03.prm                                          

:: gcsort                                       
%exedir%\gcsort TAKE %takedir%\soutfsqf03.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=
set dd_outfil_01=
set dd_outfil_02=
set dd_outfil_03=
set dd_outfil_save=

echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf03_cbl01.srt
set dd_ingcsort=%filedir%\soutfsqf03_ocs01.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf03_cbl02.srt
set dd_ingcsort=%filedir%\soutfsqf03_ocs02.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf03_cbl03.srt
set dd_ingcsort=%filedir%\soutfsqf03_ocs03.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

:: end
:lbend
