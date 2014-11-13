rm run-file
rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cobc -x -W -free worldcities2.cbl
./worldcities2 $FILES/cities15000.txt $FILES/countryInfo.txt
rm worldcities2
lpr -P $PRINTQUEUE run-file
lpr -P $PRINTQUEUE report-file
