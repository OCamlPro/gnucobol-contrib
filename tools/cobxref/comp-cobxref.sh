#!/bin/sh
cobc -x -fmissing-statement=ok cobxref.cbl
chmod +x cobxref
exit

