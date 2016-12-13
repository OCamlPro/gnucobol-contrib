##@echo off
## :: musesqf01.bat
export takedir=../takefile_linux/tmp

export dd_outfile=../files/fsqf01.dat
../bin/genfile
export dd_outfile=

export dd_infile=../files/fsqf01.dat 
export dd_outfile=../files/susesqf01_cbl.srt
export dd_sortwork=../files/susesqf01_srt.srt
../bin/musesqf01a 
export dd_infile=
export dd_outfile=
export dd_sortwork=

## :: clone file
cp ../files/susesqf01_cbl.srt   ../files/fsqf01.dat
cp ../files/susesqf01_cbl.srt   ../files/fsqf02.dat
cp ../files/susesqf01_cbl.srt   ../files/fsqf03.dat

## :: merge
export dd_infile1=../files/fsqf01.dat 
export dd_infile2=../files/fsqf02.dat 
export dd_infile3=../files/fsqf03.dat 
export dd_outfile=../files/musesqf01_cbl.mrg
export dd_mergework=../files/musesqf01_mrg.mrg
../bin/musesqf01b 
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=
export dd_mergework=


## :: gcsort

export dd_infile1=../files/fsqf01.dat 
export dd_infile2=../files/fsqf02.dat 
export dd_infile3=../files/fsqf03.dat 
export dd_outfile=../files/musesqf01_ocs.mrg
echo "MERGE FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28,4,PD,A,32,7,ZD,D)"   >$takedir/musesqf01.prm                                          
echo "USE  dd_infile1	RECORD F,90 ORG SQ                                    "  >>$takedir/musesqf01.prm                                          
echo "USE  dd_infile2	RECORD F,90 ORG SQ                                    "  >>$takedir/musesqf01.prm                                          
echo "USE  dd_infile3	RECORD F,90 ORG SQ                                    "  >>$takedir/musesqf01.prm                                          
echo "GIVE dd_outfile 	RECORD F,90 ORG SQ                                    "  >>$takedir/musesqf01.prm                                          
../bin/gcsort TAKE $takedir/musesqf01.prm
export rtc1=$?
export dd_infile1=
export dd_infile2=
export dd_infile3=
export dd_outfile=


## :: diffile

export dd_incobol=../files/musesqf01_cbl.mrg
export dd_ingcsort=../files/musesqf01_ocs.mrg
../bin/diffile
export rtc2=$?
export dd_incobol=
export dd_ingcsort=
