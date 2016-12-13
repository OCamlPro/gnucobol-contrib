##@echo off
## :: somisqf09.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf09_cbl.srt
export dd_sortwork=$filedir/somisqf09_srt.srt
$exedir/somisqf09b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf09_ocs.srt
echo " SORT FIELDS=(8,5,CH,A)                                                 "   >$takedir/somisqf09.prm                                          
echo " OMIT COND=((8,2,CH,LT,C'GG',AND,13,3,BI,LT,15,AND,16,4,FI,GT,6),OR,(20,8,FL,GE,25,AND,28,4,PD,LE,18,AND,32,7,ZD,EQ,12))" >>$takedir/somisqf09.prm 
echo " USE  dd_infile      RECORD F,90 ORG SQ                                  "  >>$takedir/somisqf09.prm                                          
echo " GIVE dd_outfile     RECORD F,90 ORG SQ                                  "  >>$takedir/somisqf09.prm                                          
$exedir/gcsort TAKE $takedir/somisqf09.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/somisqf09_cbl.srt
export dd_ingcsort=$filedir/somisqf09_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=