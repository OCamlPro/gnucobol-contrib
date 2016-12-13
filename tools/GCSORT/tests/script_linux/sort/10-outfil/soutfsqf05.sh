## @echo off
## ::
## :: soutfsqf05.bat
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
export dd_outfile=$filedir/soutfsqf05_cbl.srt
export dd_outfile1=$filedir/soutfsqf05_cbl01.srt
export dd_outfile2=$filedir/soutfsqf05_cbl02.srt
export dd_outfile3=$filedir/soutfsqf05_cbl03.srt
export dd_sortwork=$filedir/soutfsqf05_srt.srt
$exedir/soutfsqf05b
export dd_infile=
export dd_outfile=
export dd_outfile1=
export dd_outfile2=
export dd_outfile3=
export dd_sortwork=


export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf05_ocs.srt
export dd_outfil_01=$filedir/soutfsqf05_ocs01.srt
export dd_outfil_02=$filedir/soutfsqf05_ocs02.srt
export dd_outfil_03=$filedir/soutfsqf05_ocs03.srt
export dd_outfil_save=$filedir/soutfsqf05_ocs_save.srt

echo  " SORT FIELDS=(8,5,CH,A)                            "    >$takedir/soutfsqf05.prm                                          
echo  " USE  dd_infile   RECORD F,90 ORG SQ               "   >>$takedir/soutfsqf05.prm                                          
echo  " GIVE dd_outfile  RECORD F,90 ORG SQ               "   >>$takedir/soutfsqf05.prm   
echo  " OUTFIL FNAMES=dd_outfil_01,ENDREC=20              "   >>$takedir/soutfsqf05.prm   
echo  " OUTFIL FNAMES=dd_outfil_02,STARTREC=21,ENDREC=40  "   >>$takedir/soutfsqf05.prm   
echo  " OUTFIL FNAMES=dd_outfil_03,STARTREC=41            "   >>$takedir/soutfsqf05.prm   
## :: gcsort                                       
$exedir/gcsort TAKE $takedir/soutfsqf05.prm
export rtc1=$?
export dd_infile=
export dd_outfile=
export dd_outfil_01=
export dd_outfil_02=
export dd_outfil_03=
export dd_outfil_save=

echo "* ====================================================== *"
## :: diffile
export dd_incobol=$filedir/soutfsqf05_cbl01.srt
export dd_ingcsort=$filedir/soutfsqf05_ocs01.srt
echo $dd_incobol$
echo $dd_ingcsort$
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=

if [ $rtc2  -eq 0 ] ; then
    echo "* ====================================================== *"
    ## :: diffile
    export dd_incobol=$filedir/soutfsqf05_cbl02.srt
    export dd_ingcsort=$filedir/soutfsqf05_ocs02.srt
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
    export dd_incobol=$filedir/soutfsqf05_cbl03.srt
    export dd_ingcsort=$filedir/soutfsqf05_ocs03.srt
    echo $dd_incobol$
    echo $dd_ingcsort$
    $exedir/diffile
    export rtc2=$?
    export dd_incobol=
    export dd_ingcsort=
fi
## :: end
##:lbend
