# @echo off
## :: susesqf02.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf02_cbl.srt
export dd_sortwork=$filedir/susesqf02_srt.srt
$exedir/susesqf02b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/susesqf02_ocs.srt
echo "SORT FIELDS=(8,5,CH,A)                                                   " >$takedir/susesqf02.prm                                          
## ::echo SUM FIELDS=(13,3,BI,16,4,FI,20,8,FL,28,4,PD,32,7,ZD)                     >>$takedir/susesqf02.prm                                          
echo "SUM FIELDS=(13,3,BI,      " >>$takedir/susesqf02.prm                                          
echo "            16,4,FI,      " >>$takedir/susesqf02.prm                                          
echo "            20,8,FL,      " >>$takedir/susesqf02.prm                                          
echo "            28,4,PD,      " >>$takedir/susesqf02.prm                                          
echo "            32,7,ZD,      " >>$takedir/susesqf02.prm                                          
echo "            39,4,FL,      " >>$takedir/susesqf02.prm                                          
echo "            43,7,CLO,     " >>$takedir/susesqf02.prm                                          
echo "            50,8,CST,     " >>$takedir/susesqf02.prm                                          
echo "            58,8,CSL      " >>$takedir/susesqf02.prm                                          
echo "            )             " >>$takedir/susesqf02.prm                                          
echo "USE  dd_infile		RECORD F,90 ORG SQ                               " >>$takedir/susesqf02.prm                                          
echo "GIVE dd_outfile 	RECORD F,90 ORG SQ                                   " >>$takedir/susesqf02.prm                                          
$exedir/gcsort TAKE $takedir/susesqf02.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/susesqf02_cbl.srt
export dd_ingcsort=$filedir/susesqf02_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=