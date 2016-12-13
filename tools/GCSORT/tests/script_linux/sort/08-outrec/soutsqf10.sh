## @echo off
## :: soutsqf10.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutsqf10_cbl.srt
export dd_sortwork=$filedir/soutsqf10_srt.srt
$exedir/soutsqf10b
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile1=$filedir/fsqf01.dat 
export dd_outfile=$filedir/soutsqf10_ocs.srt                                               
echo " SORT FIELDS=(8,5,CH,A)                     "    >$takedir/soutsqf10.prm        
echo " OUTREC FIELDS=(C'FIELD SPEC',              "   >>$takedir/soutsqf10.prm        
echo "                11:1,7,                     "   >>$takedir/soutsqf10.prm        
echo "                22:X,                       "   >>$takedir/soutsqf10.prm        
echo "                C'ALPHA',                   "   >>$takedir/soutsqf10.prm        
echo "                8,5,                        "   >>$takedir/soutsqf10.prm        
echo "                40:Z,                       "   >>$takedir/soutsqf10.prm        
echo "                3C'XYZ',                    "   >>$takedir/soutsqf10.prm        
echo "                X'7B',                      "   >>$takedir/soutsqf10.prm        
echo "                6Z,                         "   >>$takedir/soutsqf10.prm        
echo "                2X'3C2B3E',                 "   >>$takedir/soutsqf10.prm        
echo "                X'7D',                      "   >>$takedir/soutsqf10.prm        
echo "                32,7,                       "   >>$takedir/soutsqf10.prm        
echo "                8X,                         "   >>$takedir/soutsqf10.prm        
echo "                C'+',                       "   >>$takedir/soutsqf10.prm        
echo "                11X)                        "   >>$takedir/soutsqf10.prm        
echo " USE  dd_infile1  RECORD F,90 ORG SQ        "   >>$takedir/soutsqf10.prm        
echo " GIVE dd_outfile  RECORD F,90 ORG SQ        "   >>$takedir/soutsqf10.prm        
$exedir/gcsort TAKE $takedir/soutsqf10.prm
export rtc1=$?
export dd_infile1=
export dd_outfile=


## :: diffile
export dd_incobol=$filedir/soutsqf10_cbl.srt
export dd_ingcsort=$filedir/soutsqf10_ocs.srt
$exedir/diffile3
export rtc2=$?
export dd_incobol=
export dd_ingcsort=
