## @echo off
## ::
## :: soutfsqf04.bat
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
export dd_outfile=$filedir/soutfsqf04_cbl.srt
$exedir/soutfsqf04b
export dd_infile=
export dd_outfile=
export dd_outfile1=
export dd_outfile2=
export dd_outfile3=
export dd_sortwork=


export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutfsqf04_ocs.srt
export dd_outfil1=$filedir/soutfsqf04_ocs01.srt
echo "SORT FIELDS=(8,5,CH,A)               "  >$takedir/soutfsqf04.prm                                          
echo "USE  dd_infile   RECORD F,90 ORG SQ  " >>$takedir/soutfsqf04.prm                                          
echo "GIVE dd_outfile  RECORD F,90 ORG SQ  " >>$takedir/soutfsqf04.prm   
echo "OUTFIL FILES=dd_outfil1,             " >>$takedir/soutfsqf04.prm   
echo "OUTREC=        (1,7,                 " >>$takedir/soutfsqf04.prm   
echo "               32,7,                 " >>$takedir/soutfsqf04.prm   
echo "               20,8,                 " >>$takedir/soutfsqf04.prm   
echo "               16,4,                 " >>$takedir/soutfsqf04.prm   
echo "               28,4,                 " >>$takedir/soutfsqf04.prm   
echo "               13,3,                 " >>$takedir/soutfsqf04.prm   
echo "                8,5,                 " >>$takedir/soutfsqf04.prm   
echo "               39,4, *   FL COMP-1   " >>$takedir/soutfsqf04.prm
echo "               43,7, *   CLO         " >>$takedir/soutfsqf04.prm                                          
echo "               50,8, *   CST         " >>$takedir/soutfsqf04.prm                                          
echo "               58,8, *   CSL         " >>$takedir/soutfsqf04.prm                                          
echo "               66,25)*   Filler      " >>$takedir/soutfsqf04.prm                                          

## :: ocsort                                       
$exedir/ocsort TAKE $takedir/soutfsqf04.prm
export rtc1=$?
export dd_infile=
export dd_outfile=
export dd_outfil_save=

echo "* ====================================================== *"
## :: diffile2  Outrec
export dd_incobol=$filedir/soutfsqf04_cbl.srt
export dd_inocsort=$filedir/soutfsqf04_ocs01.srt
echo $dd_incobol$
echo $dd_inocsort$
$exedir/diffile2
export rtc2=$?
export dd_incobol=
export dd_inocsort=
