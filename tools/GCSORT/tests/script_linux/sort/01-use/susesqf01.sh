##::@echo off
##:: susesqf01.bat

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp


export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf01_cbl.srt
export dd_sortwork=$filedir/susesqf01_srt.srt
$exedir/susesqf01b 
export dd_infile=
export dd_outfile=
export dd_sortwork=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf01_ocs.srt
echo "SORT FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28,4,PD,A,32,7,ZD,D)" >$takedir/susesqf01.prm                                          
echo "USE  dd_infile   RECORD F,90 ORG SQ                                    " >>$takedir/susesqf01.prm                                          
echo "GIVE dd_outfile  RECORD F,90 ORG SQ                                    " >>$takedir/susesqf01.prm                                          
$exedir/gcsort TAKE $takedir/susesqf01.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/susesqf01_cbl.srt
export dd_ingcsort=$filedir/susesqf01_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=