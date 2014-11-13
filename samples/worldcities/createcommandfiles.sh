rm all.sh
cobc -x worldcities0.cbl
./worldcities0 techtonics
chmod +x worldcities0.sh
cat worldcities0.sh >> all.sh
cobc -x worldcities1.cbl
./worldcities1 techtonics
chmod +x worldcities1.sh
cat worldcities1.sh >> all.sh
cobc -x worldcities2.cbl
./worldcities2 techtonics
chmod +x worldcities2.sh
cat worldcities2.sh >> all.sh
cobc -x worldcities3.cbl commonroutines.cbl
./worldcities3 techtonics
chmod +x worldcities3.sh
cat worldcities3.sh >> all.sh
cobc -x worldcities4.cbl commonroutines.cbl
./worldcities4 techtonics
chmod +x worldcities4.sh
cat worldcities4.sh >> all.sh
ocesql worldcities5.cbl worldcities5.cob
cobc -x worldcities5.cob commonroutines.cbl
./worldcities5 techtonics
chmod +x worldcities5.sh
cat worldcities5.sh >> all.sh
ocesql worldcities6.cbl worldcities6.cob
cobc -x worldcities6.cob commonroutines.cbl
./worldcities6 techtonics
chmod +x worldcities6.sh
cat worldcities6.sh >> all.sh
cobc -x worldcities7.cbl commonroutines.cbl
./worldcities7 techtonics
chmod +x worldcities7.sh
cat worldcities7.sh >> all.sh
cobc -x worldcities8.cbl commonroutines.cbl
./worldcities8 techtonics
chmod +x worldcities8.sh
cat worldcities8.sh >> all.sh
chmod +x all.sh
