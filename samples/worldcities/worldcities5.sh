rm run-file
rm report-file
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
export countryfile=$FILES/countryInfo.txt
cat $FILES/CA.txt $FILES/US.txt > $FILES/CAUS.txt
ocesql worldcities5.cbl worldcities5.cob
export COB_PRE_LOAD=/usr/local/lib/libocesql.so
cobc -x -W worldcities5.cob commonroutines.cbl
./worldcities5 $FILES/CAUS.txt $FILES/countryInfo.txt
rm worldcities5.cob
rm worldcities5
lpr -P $PRINTQUEUE run-file
lpr -P $PRINTQUEUE report-file
