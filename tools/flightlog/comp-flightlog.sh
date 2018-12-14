#!/bin/bash
#
# 19/11/18 vbc - v1.0 compiles Flightlog
#
#  But check if ~/bin exists for user.
#
if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi
#
#   Now change permissions and move the executable to users bin dir
#    but not the scripts - lets not clutter up the ~/bin dir.
#    User can copy if required.
#
cobc -x flight.cbl
#
#    Could do a test that compile return no error before the mv
#
chmod u+x *.sh
chmod u+x flightlog
cp -vf flightlog ~/bin
#
exit 0
