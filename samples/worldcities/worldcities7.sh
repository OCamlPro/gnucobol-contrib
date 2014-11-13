rm run-file
rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cobc -x -W worldcities7.cbl commonroutines.cbl
export kmlfile=$FILES/worldcities7.kml
rm $kmlfile
./worldcities7 $FILES/allCountries.txt $FILES/countryInfo.txt $FILES/Vienna.kml
google-earth $kmlfile
rm worldcities7
#lpr -P PRINTQUEUE run-file
#lpr -P PRINTQUEUE report-file
