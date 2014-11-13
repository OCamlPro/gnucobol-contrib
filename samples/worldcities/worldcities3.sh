rm run-file
rm report-file
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
lpr -P $PRINTQUEUE run-file
lpr -P $PRINTQUEUE report-file
