#@echo off
# ## :: susesqf16.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf16_cbl.srt
export dd_sortwork=$filedir/susesqf16_srt.srt
$exedir/susesqf16b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf16_ocs.srt

## :: Sort references inrec position if present. This phase is executed after INREC.
echo "SORT FIELDS=(8,5,CH,A)                                     "    >$takedir/susesqf16.prm                                          
echo "USE  dd_infile     RECORD F,90 ORG SQ                      "   >>$takedir/susesqf16.prm                                          
echo "GIVE dd_outfile    RECORD F,90 ORG SQ                      "   >>$takedir/susesqf16.prm                                          
echo "INCLUDE COND=(8,2,CH,GT,C'GG',AND,13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,32,7,ZD,LT,40)" >>$takedir/susesqf16.prm
echo "SUM FIELDS=(NONE)                                          "   >>$takedir/susesqf16.prm                                          
echo "OPTION SKIPREC=5                                           "   >>$takedir/susesqf16.prm                                          
echo "STOPAFT=15                                                 "    >>$takedir/susesqf16.prm                                          
$exedir/gcsort TAKE $takedir/susesqf16.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: new record INREC
## :: diffile2

export dd_incobol=$filedir/susesqf16_cbl.srt
export dd_ingcsort=$filedir/susesqf16_ocs.srt
$exedir/diffile2
export rtc2=$?
export dd_incobol=
export dd_ingcsort=