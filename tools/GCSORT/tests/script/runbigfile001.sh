##--
## --
##        BigFile
##--
## - Generate big file
export dd_outfile=../files/sqbig01.dat
## big 
export numrek=001000000
## small export numrek=000000100
##              
../bin/genbigfile
##--
##--
##-- GCSort
time ../bin/gcsort SORT FIELDS=\(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A\) USE  ../files/sqbig01.dat     RECORD F,90 ORG SQ GIVE ../files/sqbig01_gcs.srt   RECORD F,90 ORG SQ

##--cobol sbig001.cbl

##-- Sort GnuCOBOL
export dd_infile=../files/sqbig01.dat
export dd_outfile=../files/sqbig01_cbl.srt
export dd_sortwork=../files/sqbig01_srt.srt
time ../bin/sbig001





##-- Difference Sort GnuCOBOL / GCSORT 
export dd_incobol=../files/sqbig01_cbl.srt
export dd_ingcsort=../files/sqbig01_gcs.srt
../bin/diffile2

##-- View file
## export dd_incobol=../files/sqbig01_gcs.srt
##../bin/viewfile
