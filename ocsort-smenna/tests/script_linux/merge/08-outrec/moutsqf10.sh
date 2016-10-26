## @echo off
## :: moutsqf10a.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/moutsqf10_cbl.srt
export dd_sortwork=$filedir/moutsqf10_srt.srt
$exedir/moutsqf10a
export dd_infile=
export dd_outfile=
export dd_sortwork=

## :: clone file
cp $filedir/moutsqf10_cbl.srt   $filedir/fsqf01.dat
cp $filedir/moutsqf10_cbl.srt   $filedir/fsqf02.dat
cp $filedir/moutsqf10_cbl.srt   $filedir/fsqf03.dat

## :: merge
export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/moutsqf10_cbl.mrg
export dd_mergework=$filedir/moutsqf10_mrg.mrg
$exedir/moutsqf10b 
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=
export dd_mergework=


## :: ocsort

export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/moutsqf10_ocs.mrg
echo " MERGE FIELDS=(28,5,CH,A)                      "      >$takedir/moutsqf10.prm                                          
echo " OUTREC FIELDS=(C'FIELD SPEC',                 "     >>$takedir/moutsqf10.prm     
echo "                11:11,7,                       "     >>$takedir/moutsqf10.prm     
echo "                22:X,                          "     >>$takedir/moutsqf10.prm     
echo "                C'ALPHA',                      "     >>$takedir/moutsqf10.prm     
echo "                28,5,                          "     >>$takedir/moutsqf10.prm     
echo "                40:Z,                          "     >>$takedir/moutsqf10.prm     
echo "                3C'XYZ',                       "     >>$takedir/moutsqf10.prm     
echo "                X'7B',                         "     >>$takedir/moutsqf10.prm     
echo "                6Z,                            "     >>$takedir/moutsqf10.prm     
echo "                2X'3C2B3E',                    "     >>$takedir/moutsqf10.prm     
echo "                X'7D',                         "     >>$takedir/moutsqf10.prm     
echo "                64,7,                          "     >>$takedir/moutsqf10.prm     
echo "                8X,                            "     >>$takedir/moutsqf10.prm     
echo "                C'+',                          "     >>$takedir/moutsqf10.prm     
echo "                11X)                           "     >>$takedir/moutsqf10.prm                                    
echo " USE  dd_infile1  RECORD F,90 ORG SQ           "     >>$takedir/moutsqf10.prm                                                    
echo " USE  dd_infile2  RECORD F,90 ORG SQ           "     >>$takedir/moutsqf10.prm                                                    
echo " USE  dd_infile3  RECORD F,90 ORG SQ           "     >>$takedir/moutsqf10.prm                               
echo " GIVE dd_outfile  RECORD F,90 ORG SQ           "     >>$takedir/moutsqf10.prm                                          
$exedir/ocsort TAKE $takedir/moutsqf10.prm
export rtc1=$?
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/moutsqf10_cbl.mrg
export dd_inocsort=$filedir/moutsqf10_ocs.mrg
$exedir/diffile3
export rtc2=$?
export dd_incobol=
export dd_inocsort=
