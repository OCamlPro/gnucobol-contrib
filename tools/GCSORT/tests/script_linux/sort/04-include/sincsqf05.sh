## @echo off
##:: sincsqf05.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

##:: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf05_cbl.srt
export dd_sortwork=$filedir/sincsqf05_srt.srt
$exedir/sincsqf05b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


##:: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/sincsqf05_ocs.srt

echo "SORT FIELDS=(8,5,CH,A)                               "  >$takedir/sincsqf05.prm                                          
##::                                                                 
echo "USE  dd_infile     RECORD F,90 ORG SQ                " >>$takedir/sincsqf05.prm                                          
echo "GIVE dd_outfile    RECORD F,90 ORG SQ                " >>$takedir/sincsqf05.prm                                          
##::                                                                 
echo "OUTREC FIELDS(1,7,    " >>$takedir/sincsqf05.prm   
echo "              32,7,   " >>$takedir/sincsqf05.prm   
echo "              20,8,   " >>$takedir/sincsqf05.prm   
echo "              16,4,   " >>$takedir/sincsqf05.prm   
echo "              28,4,   " >>$takedir/sincsqf05.prm   
echo "              13,3,   " >>$takedir/sincsqf05.prm   
echo "               8,5,   " >>$takedir/sincsqf05.prm   
echo "              39,4,   " >>$takedir/sincsqf05.prm
echo "              43,7,   " >>$takedir/sincsqf05.prm                                          
echo "              50,8,   " >>$takedir/sincsqf05.prm                                          
echo "              58,8,   " >>$takedir/sincsqf05.prm                                          
echo "              66,25)  " >>$takedir/sincsqf05.prm                                          

$exedir/gcsort TAKE $takedir/sincsqf05.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


##:: new record INREC
##:: diffile2

export dd_incobol=$filedir/sincsqf05_cbl.srt
export dd_ingcsort=$filedir/sincsqf05_ocs.srt
$exedir/diffile2
export rtc2=$?
export dd_incobol=
export dd_ingcsort=