## @echo off
## ::
## :: soutfsqf02.bat
## :: Don't checked save file, but only include/omit conditions
## ::

export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp


export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: file1
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf02_cbl01.srt
export dd_sortwork=$filedir/soutfsqf02_srt.srt
$exedir/soutfsqf02b1
export dd_infile=
export dd_outfile=
export dd_sortwork=
## :: file2
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf02_cbl02.srt
export dd_sortwork=$filedir/soutfsqf02_srt.srt
$exedir/soutfsqf02b2
export dd_infile=
export dd_outfile=
export dd_sortwork=
## :: file3
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf02_cbl03.srt
export dd_sortwork=$filedir/soutfsqf02_srt.srt
$exedir/soutfsqf02b3
export dd_infile=
export dd_outfile=
export dd_sortwork=


export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf02_ocs.srt
export dd_outfil_01=$filedir/soutfsqf02_ocs01.srt
export dd_outfil_02=$filedir/soutfsqf02_ocs02.srt
export dd_outfil_03=$filedir/soutfsqf02_ocs03.srt
export dd_outfil_save=$filedir/soutfsqf02_ocs_save.srt

echo "SORT FIELDS=(8,5,CH,A)                               "    >$takedir/soutfsqf02.prm                                          
echo "USE  dd_infile   RECORD F,90 ORG SQ                  "   >>$takedir/soutfsqf02.prm                                          
echo "GIVE dd_outfile  RECORD F,90 ORG SQ                  "   >>$takedir/soutfsqf02.prm   
echo "OUTFIL OMIT =(8,2,CH,EQ,C'AA',AND,32,7,ZD,LT,20),    "   >>$takedir/soutfsqf02.prm
echo "        FILES=dd_outfil_01                           "   >>$takedir/soutfsqf02.prm                                          
echo "OUTFIL OMIT =(8,2,CH,EQ,C'GG',AND,32,7,ZD,LT,35),    "   >>$takedir/soutfsqf02.prm
echo "        FILES=dd_outfil_02                           "   >>$takedir/soutfsqf02.prm                                          
echo "OUTFIL OMIT =(8,2,CH,EQ,C'EE',AND,32,7,ZD,GT,-10),   "   >>$takedir/soutfsqf02.prm
echo "        FILES=dd_outfil_03                           "   >>$takedir/soutfsqf02.prm                                          
echo "OUTFIL FNAMES=dd_outfil_save,SAVE                    "   >>$takedir/soutfsqf02.prm                                          

## :: gcsort                                       
$exedir/gcsort TAKE $takedir/soutfsqf02.prm
export rtc1=$?
export dd_infile=
export dd_outfile=
export dd_outfil_01=
export dd_outfil_02=
export dd_outfil_03=
export dd_outfil_save=

echo "* ====================================================== *"
## :: diffile
export dd_incobol=$filedir/soutfsqf02_cbl01.srt
export dd_ingcsort=$filedir/soutfsqf02_ocs01.srt
echo $dd_incobol$
echo $dd_ingcsort$
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=

if [ $rtc2 -eq 0 ] ; then
    echo "* ====================================================== *"
    ## :: diffile
    export dd_incobol=$filedir/soutfsqf02_cbl02.srt
    export dd_ingcsort=$filedir/soutfsqf02_ocs02.srt
    echo $dd_incobol$
    echo $dd_ingcsort$
    $exedir/diffile
    export rtc2=$?
    export dd_incobol=
    export dd_ingcsort=
fi
if [ $rtc2 -eq 0 ] ; then
    echo "* ====================================================== *"
    ## :: diffile
    export dd_incobol=$filedir/soutfsqf02_cbl03.srt
    export dd_ingcsort=$filedir/soutfsqf02_ocs03.srt
    echo $dd_incobol$
    echo $dd_ingcsort$
    $exedir/diffile
    export rtc2=$?
    export dd_incobol=
    export dd_ingcsort=
fi
## :: end
##:lbend
