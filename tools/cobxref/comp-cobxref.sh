#!/bin/sh
# 11/01/25 added  -D_FORTIFY_SOURCE=1
#
cobc -x cobxref.cbl -D_FORTIFY_SOURCE=1
chmod +x cobxref
exit
