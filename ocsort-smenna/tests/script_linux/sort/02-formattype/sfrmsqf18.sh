## @echo off
## :: sfrmsqf18.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sfrmsqf18_cbl.srt
export dd_sortwork=$filedir/sfrmsqf18_srt.srt
$exedir/sfrmsqf18b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: ocsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sfrmsqf18_ocs.srt
echo "SORT FIELDS=(8,5,CH,A)                    "  >$takedir/sfrmsqf18.prm                                          
echo "    OMIT COND=(8,2,CH,LE,C'FF',AND,       " >>$takedir/sfrmsqf18.prm
echo "                 39,4,FL,GT,-10,OR,       " >>$takedir/sfrmsqf18.prm
echo "                 43,7,CLO,GT,10,AND,      " >>$takedir/sfrmsqf18.prm
echo "                 50,8,CST,LE,-30,OR,      " >>$takedir/sfrmsqf18.prm
echo "                 58,8,CSL,LE,10)          " >>$takedir/sfrmsqf18.prm
echo "USE  dd_infile		RECORD F,90 ORG SQ  " >>$takedir/sfrmsqf18.prm                                          
echo "GIVE dd_outfile 	RECORD F,90 ORG SQ      " >>$takedir/sfrmsqf18.prm                                          
$exedir/ocsort TAKE $takedir/sfrmsqf18.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/sfrmsqf18_cbl.srt
export dd_inocsort=$filedir/sfrmsqf18_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_inocsort=