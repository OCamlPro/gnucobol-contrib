##@echo off
## :: somisqf12.bat
export exedir=../bin
export filedir=../files
export takedir=../takefile_linux/tmp

export dd_outfile=$filedir/fsqf01.dat
$exedir/genfile
export dd_outfile=

## :: cobol sort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf12_cbl.srt
export dd_sortwork=$filedir/somisqf12_srt.srt
$exedir/somisqf12b 
export dd_infile=
export dd_outfile=
export dd_sortwork=


## :: gcsort
export dd_infile=$filedir/fsqf01.dat 
export dd_outfile=$filedir/somisqf12_ocs.srt
echo "SORT FIELDS=(8,5,CH,A)                             "                      >$takedir/somisqf12.prm                                          
echo "USE  dd_infile     RECORD F,90 ORG SQ              "                     >>$takedir/somisqf12.prm                                          
echo "GIVE dd_outfile    RECORD F,90 ORG SQ              "                     >>$takedir/somisqf12.prm     
echo "OMIT COND=(8,2,CH,LE,C'MM',AND,13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,32,7,ZD,GE,15)" >>$takedir/somisqf12.prm  
echo "OUTREC FIELDS=(C'FIELD SPEC',               "    >>$takedir/somisqf12.prm        
echo "               11:1,7,                      "    >>$takedir/somisqf12.prm        
echo "               22:X,                        "    >>$takedir/somisqf12.prm        
echo "               C'ALPHA',                    "    >>$takedir/somisqf12.prm        
echo "               8,5,                         "    >>$takedir/somisqf12.prm        
echo "               40:Z,                        "    >>$takedir/somisqf12.prm        
echo "               3C'XYZ',                     "    >>$takedir/somisqf12.prm        
echo "               X'7B',                       "    >>$takedir/somisqf12.prm        
echo "               6Z,                          "    >>$takedir/somisqf12.prm        
echo "               2X'3C2B3E',                  "    >>$takedir/somisqf12.prm        
echo "               X'7D',                       "    >>$takedir/somisqf12.prm        
echo "               32,7,                        "    >>$takedir/somisqf12.prm        
echo "               8X,                          "    >>$takedir/somisqf12.prm        
echo "               C'+',                        "    >>$takedir/somisqf12.prm        
echo "               11X)                         "    >>$takedir/somisqf12.prm        
                                     
$exedir/gcsort TAKE $takedir/somisqf12.prm
export rtc1=$?
export dd_infile=
export dd_outfile=


## :: diffile

export dd_incobol=$filedir/somisqf12_cbl.srt
export dd_ingcsort=$filedir/somisqf12_ocs.srt
$exedir/diffile3
export rtc2=$?
export dd_incobol=
export dd_ingcsort=