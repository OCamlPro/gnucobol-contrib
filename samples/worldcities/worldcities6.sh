rm run-file
rm report-file
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cat $FILES/CA.txt $FILES/US.txt > $FILES/CAUS.txt
ocesql worldcities6.cbl worldcities6.cob
cobc -x -W worldcities6.cob commonroutines.cbl
export COB_PRE_LOAD=/usr/local/lib/libocesql.so
rm $FILES/worldcities6.kml
rm $FILES/worldcities6.csv
export CITY=$FILES/CAUS.txt
export COUNTRY=$FILES/countryInfo.txt
export KML=$FILES/worldcities6.kml
export CSV=$FILES/worldcities6.csv
./worldcities6 $CITY $COUNTRY $KML $CSV
google-earth $KML
rm worldcities6.cob
rm worldcities6
lpr -P PRINTQUEUE run-file
lpr -P PRINTQUEUE report-file
