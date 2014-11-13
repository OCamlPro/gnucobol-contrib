export FILES=$HOME/worldcityfiles
cobc worldcities0.cbl -x -W -fdebugging-line
./worldcities0 $FILES/CA.txt
rm worldcities0
