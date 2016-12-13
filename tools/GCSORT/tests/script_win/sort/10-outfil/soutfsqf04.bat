@echo off
::
:: soutfsqf04.bat
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
set dd_outfile=%filedir%\soutfsqf04_cbl.srt
%exedir%\soutfsqf04b
set dd_infile=
set dd_outfile=
set dd_outfile1=
set dd_outfile2=
set dd_outfile3=
set dd_sortwork=


set dd_infile=%filedir%\fsqf01.dat 
set dd_outfile=%filedir%\soutfsqf04_ocs.srt
set dd_outfil1=%filedir%\soutfsqf04_ocs01.srt
echo SORT FIELDS=(8,5,CH,A)                >%takedir%\soutfsqf04.prm                                          
echo USE  dd_infile   RECORD F,90 ORG SQ  >>%takedir%\soutfsqf04.prm                                          
echo GIVE dd_outfile  RECORD F,90 ORG SQ  >>%takedir%\soutfsqf04.prm   
echo OUTFIL FILES=dd_outfil1,              >>%takedir%\soutfsqf04.prm   
echo OUTREC=        (1,7,                 >>%takedir%\soutfsqf04.prm   
echo                32,7,                 >>%takedir%\soutfsqf04.prm   
echo                20,8,                 >>%takedir%\soutfsqf04.prm   
echo                16,4,                 >>%takedir%\soutfsqf04.prm   
echo                28,4,                 >>%takedir%\soutfsqf04.prm   
echo                13,3,                 >>%takedir%\soutfsqf04.prm   
echo                 8,5,                 >>%takedir%\soutfsqf04.prm   
:: echo                52Z)                  >>%takedir%\soutfsqf04.prm        
echo                39,4, *   FL COMP-1  >>%takedir%\soutfsqf04.prm
echo                43,7, *   CLO        >>%takedir%\soutfsqf04.prm                                          
echo                50,8, *   CST        >>%takedir%\soutfsqf04.prm                                          
echo                58,8, *   CSL        >>%takedir%\soutfsqf04.prm                                          
echo                66,25)*   Filler     >>%takedir%\soutfsqf04.prm                                          

:: gcsort                                       
%exedir%\gcsort TAKE %takedir%\soutfsqf04.prm
set rtc1=%errorlevel%
set dd_infile=
set dd_outfile=
set dd_outfil_save=

echo * ====================================================== *
:: diffile2  Outrec
set dd_incobol=%filedir%\soutfsqf04_cbl.srt
set dd_ingcsort=%filedir%\soutfsqf04_ocs01.srt
echo %dd_incobol%
echo %dd_ingcsort%
%exedir%\diffile2
set rtc2=%errorlevel%
set dd_incobol=
set dd_ingcsort=
