rm run-file
rm report-file
# Enter your print queue name here
export PRINTQUEUE=Brother-HL-2170W-wireless
export FILES=$HOME/worldcityfiles
cat $FILES/CA.txt $FILES/US.txt > $FILES/CAUS.txt
cobc -x -W worldcities4.cbl commonroutines.cbl
./worldcities4 $FILES/CAUS.txt $FILES/countryInfo.txt
rm worldcities4
lpr -P $PRINTQUEUE run-file
lpr -P $PRINTQUEUE report-file
