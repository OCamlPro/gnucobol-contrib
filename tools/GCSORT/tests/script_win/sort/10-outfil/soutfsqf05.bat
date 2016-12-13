@echo off
::
:: soutfsqf05.bat
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
set dd_outfile=%filedir%\soutfsqf05_cbl.srt
set dd_outfile1=%filedir%\soutfsqf05_cbl01.srt
set dd_outfile2=%filedir%\soutfsqf05_cbl02.srt
set dd_outfile3=%filedir%\soutfsqf05_cbl03.srt
set dd_sortwork=%filedir%\soutfsqf05_srt.srt
%exedir%\soutfsqf05b
set dd_infile=
set dd_outfile=
set dd_outfile1=
set dd_outfile2=
set dd_outfile3=
set dd_sortwork=


set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf05_ocs.srt
set dd_outfil_01=%filedir%\soutfsqf05_ocs01.srt
set dd_outfil_02=%filedir%\soutfsqf05_ocs02.srt
set dd_outfil_03=%filedir%\soutfsqf05_ocs03.srt
set dd_outfil_save=%filedir%\soutfsqf05_ocs_save.srt

echo    SORT FIELDS=(8,5,CH,A)                                 >%takedir%\soutfsqf05.prm                                          
echo    USE  dd_infile   RECORD F,90 ORG SQ                   >>%takedir%\soutfsqf05.prm                                          
echo    GIVE dd_outfile  RECORD F,90 ORG SQ                   >>%takedir%\soutfsqf05.prm   
echo    OUTFIL FNAMES=dd_outfil_01,ENDREC=20                  >>%takedir%\soutfsqf05.prm   
echo    OUTFIL FNAMES=dd_outfil_02,STARTREC=21,ENDREC=40      >>%takedir%\soutfsqf05.prm   
echo    OUTFIL FNAMES=dd_outfil_03,STARTREC=41                >>%takedir%\soutfsqf05.prm   
:: gcsort                                       
%exedir%\gcsort TAKE %takedir%\soutfsqf05.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=
set dd_outfil_01=
set dd_outfil_02=
set dd_outfil_03=
set dd_outfil_save=

echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf05_cbl01.srt
set dd_ingcsort=%filedir%\soutfsqf05_ocs01.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf05_cbl02.srt
set dd_ingcsort=%filedir%\soutfsqf05_ocs02.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

if "%rtc2%" NEQ 0 goto lbend
echo * ====================================================== *
:: diffile
set dd_incobol=%filedir%\soutfsqf05_cbl03.srt
set dd_ingcsort=%filedir%\soutfsqf05_ocs03.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=

:: end
:lbend
