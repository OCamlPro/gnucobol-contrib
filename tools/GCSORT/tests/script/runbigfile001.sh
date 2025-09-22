##--
## --
##        BigFile
##--

CHECK=time
# for Linux only, and must be installed
command -v perf 1>/dev/null && CHECK="perf stat"

FILES=../files
#FILES=/tmp   # often fastest storage

## - Generate big file
export dd_outfile=$FILES/sqbig01.dat
## huge  export numrek=015000000
## big   
export numrek=001000000
## small export numrek=000000100
##              
../bin/genbigfile
##--
##--
##-- GCSort
$CHECK ../bin/gcsort       SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ
$CHECK ../bin/gcsort -mt=2 SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ
#$CHECK ../bin/gcsort -mt=3 SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ
#$CHECK ../bin/gcsort -mt=4 SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ
#$CHECK ../bin/gcsort -mt=6 SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ
#$CHECK ../bin/gcsort -mt=8 SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  $FILES/sqbig01.dat     RECORD F,90 ORG SQ GIVE $FILES/sqbig01_gcs.srt   RECORD F,90 ORG SQ

##--cobol sbig001.cbl

##-- Sort GnuCOBOL
export dd_infile=$FILES/sqbig01.dat
export dd_outfile=$FILES/sqbig01_cbl.srt
export dd_sortwork=$FILES/sqbig01_srt.srt
$CHECK ../bin/sbig001






##-- Difference Sort GnuCOBOL / GCSORT 
export dd_incobol=$FILES/sqbig01_cbl.srt
export dd_ingcsort=$FILES/sqbig01_gcs.srt
../bin/diffile2

##-- View file
## export dd_incobol=$FILES/sqbig01_gcs.srt
##../bin/viewfile
