#  @echo off
## ::
## :: soutfsqf01.bat
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
export dd_outfile=$filedir/soutfsqf01_cbl01.srt
export dd_sortwork=$filedir/soutfsqf01_srt.srt
$exedir/soutfsqf01b1
export dd_infile=
export dd_outfile=
export dd_sortwork=
## :: file2
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf01_cbl02.srt
export dd_sortwork=$filedir/soutfsqf01_srt.srt
$exedir/soutfsqf01b2
export dd_infile=
export dd_outfile=
export dd_sortwork=
## :: file3
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf01_cbl03.srt
export dd_sortwork=$filedir/soutfsqf01_srt.srt
$exedir/soutfsqf01b3
export dd_infile=
export dd_outfile=
export dd_sortwork=


export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf01_ocs.srt
export dd_outfil_01=$filedir/soutfsqf01_ocs01.srt
export dd_outfil_02=$filedir/soutfsqf01_ocs02.srt
export dd_outfil_03=$filedir/soutfsqf01_ocs03.srt
export dd_outfil_save=$filedir/soutfsqf01_ocs_save.srt

echo " SORT FIELDS=(8,5,CH,A)                                "   >$takedir/soutfsqf01.prm                                          
echo " USE  dd_infile   RECORD F,90 ORG SQ                   "  >>$takedir/soutfsqf01.prm                                          
echo " GIVE dd_outfile  RECORD F,90 ORG SQ                   "  >>$takedir/soutfsqf01.prm   
echo " OUTFIL INCLUDE =(8,2,CH,EQ,C'AA',AND,32,7,ZD,LT,20),  "  >>$takedir/soutfsqf01.prm
echo "         FILES=dd_outfil_01                            "  >>$takedir/soutfsqf01.prm                                          
echo " OUTFIL INCLUDE =(8,2,CH,EQ,C'GG',AND,32,7,ZD,LT,35),  "  >>$takedir/soutfsqf01.prm
echo "         FILES=dd_outfil_02                            "  >>$takedir/soutfsqf01.prm                                          
echo " OUTFIL INCLUDE =(8,2,CH,EQ,C'EE',AND,32,7,ZD,GT,-10), "  >>$takedir/soutfsqf01.prm
echo "         FILES=dd_outfil_03                            "  >>$takedir/soutfsqf01.prm                                          
echo " OUTFIL FNAMES=dd_outfil_save,SAVE                     "  >>$takedir/soutfsqf01.prm                                          

## :: ocsort                                       
$exedir/ocsort TAKE $takedir/soutfsqf01.prm
export rtc1=$?
export dd_infile=
export dd_outfile=
export dd_outfil_01=
export dd_outfil_02=
export dd_outfil_03=
export dd_outfil_save=

echo "* ====================================================== *"
## :: diffile
export dd_incobol=$filedir/soutfsqf01_cbl01.srt
export dd_inocsort=$filedir/soutfsqf01_ocs01.srt
echo  $dd_incobol 
echo  $dd_inocsort 
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_inocsort=

if [ $rtc2 -eq 0 ] ; then
    echo "* ====================================================== *"
    ## :: diffile
    export dd_incobol=$filedir/soutfsqf01_cbl02.srt
    export dd_inocsort=$filedir/soutfsqf01_ocs02.srt
    echo $dd_incobol
    echo $dd_inocsort
    $exedir/diffile
    export rtc2=$?
    export dd_incobol=
    export dd_inocsort=
fi
if [ $rtc2 -eq 0 ] ; then
    echo "* ====================================================== *"
    ## :: diffile
    export dd_incobol=$filedir/soutfsqf01_cbl03.srt
    export dd_inocsort=$filedir/soutfsqf01_ocs03.srt
    echo $dd_incobol
    echo $dd_inocsort
    $exedir/diffile
    export rtc2=$?
    export dd_incobol=
    export dd_inocsort=
fi
## :: end
##:lbend
