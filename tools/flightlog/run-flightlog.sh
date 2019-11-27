#!/bin/bash
# 18/12/2018 vbc - v1.01 Added backup directory if not exists.
#                        and do backup at end.
# This script requires one parameter = date/time
#
if [ ! -d backups ]; then
   mkdir backups
fi
#
export LC_TIME=en_GB
./flightlog
zip -9 backups/backup-$1.zip *.dat *.seq
exit 0

