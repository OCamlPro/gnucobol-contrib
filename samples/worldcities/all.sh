export FILES=$HOME/worldcityfiles
cobc worldcities0.cbl -x -W -fdebugging-line
./worldcities0 $FILES/CA.txt
rm worldcities0
export FILES=$HOME/worldcityfiles
cobc -x -W worldcities1.cbl
./worldcities1 $FILES/CA.txt $FILES/countryInfo.txt
rm worldcities1
rm run-file
rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cobc -x -W -free worldcities2.cbl
./worldcities2 $FILES/cities15000.txt $FILES/countryInfo.txt
rm worldcities2
#lpr -P $PRINTQUEUE run-file
#lpr -P $PRINTQUEUE report-file
#rm run-file
#rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
# Valid continent entries are
# Africa
# Asia
# Europe
# NorthAmerica
# Oceania
# SouthAmerica
# Antarctica
cobc -x -W worldcities3.cbl commonroutines.cbl
./worldcities3 $FILES/allCountries.txt $FILES/countryInfo.txt ErrorContinent
./worldcities3 $FILES/allCountries.txt $FILES/countryInfo.txt Oceania
rm worldcities3
#lpr -P $PRINTQUEUE run-file
#lpr -P $PRINTQUEUE report-file
#rm run-file
#rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cat $FILES/CA.txt $FILES/US.txt > $FILES/CAUS.txt
cobc -x -W worldcities4.cbl commonroutines.cbl
./worldcities4 $FILES/CAUS.txt $FILES/countryInfo.txt
rm worldcities4
#lpr -P $PRINTQUEUE run-file
#lpr -P $PRINTQUEUE report-file
#rm run-file
#rm report-file
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
#lpr -P $PRINTQUEUE run-file
#lpr -P $PRINTQUEUE report-file
#rm run-file
#rm report-file
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
#lpr -P PRINTQUEUE run-file
#lpr -P PRINTQUEUE report-file
#rm run-file
#rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cobc -x -W worldcities7.cbl commonroutines.cbl
export kmlfile=$FILES/worldcities7.kml
rm $kmlfile
./worldcities7 $FILES/allCountries.txt $FILES/countryInfo.txt $FILES/Vienna.kml
google-earth $kmlfile
rm worldcities7
##lpr -P PRINTQUEUE run-file
##lpr -P PRINTQUEUE report-file
#rm run-file
#rm report-file
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
