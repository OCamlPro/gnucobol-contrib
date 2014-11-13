export FILES=$HOME/worldcityfiles
cobc -x -W worldcities1.cbl
./worldcities1 $FILES/CA.txt $FILES/countryInfo.txt
rm worldcities1
