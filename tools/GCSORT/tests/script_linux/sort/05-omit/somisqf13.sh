## @echo off
## ## :: somisqf13.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## ## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf13_cbl.srt
export dd_sortwork=$filedir/somisqf13_srt.srt
$exedir/somisqf13b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## ## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf13_ocs.srt
echo " SORT FIELDS=(8,5,CH,A)                                               "     >$takedir/somisqf13.prm                                          
echo " USE  dd_infile     RECORD F,90 ORG SQ                                "    >>$takedir/somisqf13.prm                                          
echo " GIVE dd_outfile    RECORD F,90 ORG SQ                                "    >>$takedir/somisqf13.prm     
echo " OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15)" >>$takedir/somisqf13.prm  
echo " SUM FIELDS=(13,3,BI,     "  >>$takedir/somisqf13.prm                                          
echo "             16,4,FI,     "  >>$takedir/somisqf13.prm                                          
echo "             20,8,FL,     "  >>$takedir/somisqf13.prm                                          
echo "             28,4,PD,     "  >>$takedir/somisqf13.prm                                          
echo "             32,7,ZD,     "  >>$takedir/somisqf13.prm                                          
echo "             39,4,FL,     "  >>$takedir/somisqf13.prm                                          
echo "             43,7,CLO,    "  >>$takedir/somisqf13.prm                                          
echo "             50,8,CST,    "  >>$takedir/somisqf13.prm                                          
echo "             58,8,CSL)    "  >>$takedir/somisqf13.prm                                          
                                                                           
$exedir/gcsort TAKE $takedir/somisqf13.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## ## :: diffile

export dd_incobol=$filedir/somisqf13_cbl.srt
export dd_ingcsort=$filedir/somisqf13_ocs.srt
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=