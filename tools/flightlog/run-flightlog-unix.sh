#!/bin/bash
#
# 29/11/2018 vbc - v1.0. for Flightlog & Unix date format.
#                        Clears the setting for this run.
# 18/12/2018 vbc - v1.01 Added backup directory if not exists.
#                        do backup at end.
# This script requires one parameter = date/time
#
if [ ! -d backups ]; then
   mkdir backups
fi
#
export LC_TIME=
./flightlog
zip -9 backups/backup-$1.zip *.dat *.seq
exit 0
#

