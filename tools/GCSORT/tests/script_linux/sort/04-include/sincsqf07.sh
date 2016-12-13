## :: @echo off
## :: sincsqf07.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf07_cbl.srt
export dd_sortwork=$filedir/sincsqf07_srt.srt
$exedir/sincsqf07b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf07_ocs.srt

echo "SORT FIELDS=(8,5,CH,A)                                                   " >$takedir/sincsqf07.prm
echo "INCLUDE COND=(8,2,CH,GT,C'GG',AND,13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,32,7,ZD,LT,40)" >>$takedir/sincsqf07.prm
echo "USE  dd_infile     RECORD F,90 ORG SQ  " >>$takedir/sincsqf07.prm                                                                            
echo "GIVE dd_outfile    RECORD F,90 ORG SQ  " >>$takedir/sincsqf07.prm
echo "SUM FIELDS=(NONE)" >>$takedir/sincsqf07.prm
$exedir/gcsort TAKE $takedir/sincsqf07.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/sincsqf07_cbl.srt
export dd_ingcsort=$filedir/sincsqf07_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=