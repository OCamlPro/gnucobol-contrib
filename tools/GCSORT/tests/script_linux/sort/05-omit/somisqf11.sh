##@echo off
## :: somisqf11.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf11_cbl.srt
export dd_sortwork=$filedir/somisqf11_srt.srt
$exedir/somisqf11b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf11_ocs.srt
echo " SORT FIELDS=(8,5,CH,A)                                                 "  >$takedir/somisqf11.prm                                          
echo " OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15)" >>$takedir/somisqf11.prm  
echo " USE  dd_infile     RECORD F,90 ORG SQ                                  " >>$takedir/somisqf11.prm                                          
echo " GIVE dd_outfile    RECORD F,90 ORG SQ                                  " >>$takedir/somisqf11.prm                                          
$exedir/gcsort TAKE $takedir/somisqf11.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/somisqf11_cbl.srt
export dd_ingcsort=$filedir/somisqf11_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=