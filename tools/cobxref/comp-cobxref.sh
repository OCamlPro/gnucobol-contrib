#!/bin/sh
cobc -x -O2 cobxref.cbl get-reserved-lists.cbl
chmod +x cobxref
if [ ! -d ~/bin ]; then
	 mkdir ~/bin
fi
cp -vpf cobxref ~/bin
echo "cobxref compiled and stored in your bin directory"
exit

