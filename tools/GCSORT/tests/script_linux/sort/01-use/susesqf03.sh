##@echo off
## :: susesqf03.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf03_cbl.srt
export dd_sortwork=$filedir/susesqf03_srt.srt
$exedir/susesqf03b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf03_ocs.srt
echo "SORT FIELDS=(8,5,CH,A)                                         "           >$takedir/susesqf03.prm                                          
echo "SUM FIELDS=(NONE)                                              "          >>$takedir/susesqf03.prm                                          
echo "USE  dd_infile   RECORD F,90 ORG SQ                            "             >>$takedir/susesqf03.prm                                          
echo "GIVE dd_outfile  RECORD F,90 ORG SQ                            "         >>$takedir/susesqf03.prm                                          
$exedir/gcsort TAKE $takedir/susesqf03.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/susesqf03_cbl.srt
export dd_ingcsort=$filedir/susesqf03_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=