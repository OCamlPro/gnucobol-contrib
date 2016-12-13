## @echo off
## :: sincsqf19.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf19_cbl.srt
export dd_sortwork=$filedir/sincsqf19_srt.srt
$exedir/sincsqf19b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf19_ocs.srt
echo "SORT FIELDS=(8,5,CH,A)                                                   " >$takedir/sincsqf19.prm                                          
echo "INCLUDE COND=(8,4,CH,SS,C'DDDD,GGGG,HHHH,JJJJ,OOOO')"                     >>$takedir/sincsqf19.prm                                          
echo "USE  dd_infile     RECORD F,90 ORG SQ   "                                 >>$takedir/sincsqf19.prm                                          
echo "GIVE dd_outfile    RECORD F,90 ORG SQ   "                                 >>$takedir/sincsqf19.prm                                          
$exedir/gcsort TAKE $takedir/sincsqf19.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/sincsqf19_cbl.srt
export dd_ingcsort=$filedir/sincsqf19_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=