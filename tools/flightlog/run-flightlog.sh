#!/bin/bash
export LC_TIME=en_GB
./flightlog
zip -9 backup-$1.zip *.dat *.seq
exit 0

