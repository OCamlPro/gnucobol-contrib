## @echo off
## :: musesqf03.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/musesqf03_cbl.srt
export dd_sortwork=$filedir/musesqf03_srt.srt
$exedir/musesqf03a 
export dd_infile=
export dd_outfile=
export dd_sortwork=

## :: clone file
cp $filedir/musesqf03_cbl.srt   $filedir/fsqf01.dat
cp $filedir/musesqf03_cbl.srt   $filedir/fsqf02.dat
cp $filedir/musesqf03_cbl.srt   $filedir/fsqf03.dat

## :: merge
export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/musesqf03_cbl.mrg
export dd_mergework=$filedir/musesqf03_mrg.mrg
$exedir/musesqf03b 
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=
export dd_mergework=


## :: ocsort

export dd_infile1=$filedir/fsqf01.dat 
export dd_infile2=$filedir/fsqf02.dat 
export dd_infile3=$filedir/fsqf03.dat 
export dd_outfile=$filedir/musesqf03_ocs.mrg
echo "MERGE FIELDS=(8,5,CH,A)                                       "        >$takedir/musesqf03.prm                                          
echo "SUM FIELDS=(NONE)                                             "       >>$takedir/musesqf03.prm                                          
echo "USE  dd_infile1  RECORD F,90 ORG SQ                           "       >>$takedir/musesqf03.prm                                          
echo "USE  dd_infile2  RECORD F,90 ORG SQ                           "       >>$takedir/musesqf03.prm                                          
echo "USE  dd_infile3  RECORD F,90 ORG SQ                           "       >>$takedir/musesqf03.prm                                          
echo "GIVE dd_outfile  RECORD F,90 ORG SQ                           "       >>$takedir/musesqf03.prm                                          
$exedir/ocsort TAKE $takedir/musesqf03.prm
export rtc1=$?
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/musesqf03_cbl.mrg
export dd_inocsort=$filedir/musesqf03_ocs.mrg
$exedir/diffile
export rtc2=$?
export dd_incobol=
export dd_inocsort=
