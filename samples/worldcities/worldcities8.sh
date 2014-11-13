rm run-file
rm report-file
export PRINTQUEUE=Brother-HL-2170W-wireless
export BROWSER=firefox
export MAPS=google-earth
export SOURCE=http://download.geonames.org/export/dump/
export FILES=$HOME/worldcityfiles
cobc -x -W worldcities8.cbl commonroutines.cbl
rm $FILES/worldcities8.kml
rm temp
./worldcities8 $FILES/countryInfo.txt $FILES/worldcities8.kml
rm worldcities8
rm temp
lpr -P $PRINTQUEUE run-file
lpr -P $PRINTQUEUE report-file
