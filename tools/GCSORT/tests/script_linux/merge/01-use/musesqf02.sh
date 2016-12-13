##@echo off
## :: musesqf02.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: sort generated data 
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf02_cbl.srt
export dd_sortwork=$filedir/susesqf02_srt.srt
$exedir/musesqf02a 
export dd_infile=
export dd_outfile=
export dd_sortwork=

## :: clone file
cp  $filedir/susesqf02_cbl.srt   $filedir/fsqf01.dat
cp  $filedir/susesqf02_cbl.srt   $filedir/fsqf02.dat
cp  $filedir/susesqf02_cbl.srt   $filedir/fsqf03.dat

## :: merge
export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/musesqf02_cbl.mrg
export dd_mergework=$filedir/musesqf02_mrg.mrg
$exedir/musesqf02b 
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=
export dd_mergework=


## :: gcsort

export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/musesqf02_ocs.mrg
echo " MERGE FIELDS=(8,5,CH,A)                                         "       >$takedir/musesqf02.prm                                          
echo " SUM FIELDS=(13,3,BI,                                            "      >>$takedir/musesqf02.prm                                          
echo "             16,4,FI,                                            "      >>$takedir/musesqf02.prm                                          
echo "             20,8,FL,                                            "      >>$takedir/musesqf02.prm                                          
echo "             28,4,PD,                                            "      >>$takedir/musesqf02.prm                                          
echo "             32,7,ZD,                                            "      >>$takedir/musesqf02.prm                                          
echo "             39,4,FL,                                            "      >>$takedir/musesqf02.prm                                          
echo "             43,7,CLO,                                           "      >>$takedir/musesqf02.prm                                          
echo "             50,8,CST,                                           "      >>$takedir/musesqf02.prm                                          
echo "             58,8,CSL                                            "      >>$takedir/musesqf02.prm                                          
echo "             )                                                   "      >>$takedir/musesqf02.prm                                          
echo " USE  dd_infile1  RECORD F,90 ORG SQ                             "      >>$takedir/musesqf02.prm                                          
echo " USE  dd_infile2  RECORD F,90 ORG SQ                             "      >>$takedir/musesqf02.prm                                          
echo " USE  dd_infile3  RECORD F,90 ORG SQ                             "      >>$takedir/musesqf02.prm                                          
echo " GIVE dd_outfile  RECORD F,90 ORG SQ                             "      >>$takedir/musesqf02.prm                                          
$exedir/gcsort TAKE $takedir/musesqf02.prm
export rtc1=$?
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/musesqf02_cbl.mrg
export dd_ingcsort=$filedir/musesqf02_ocs.mrg
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=
