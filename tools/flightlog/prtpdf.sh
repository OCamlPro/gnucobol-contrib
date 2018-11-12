#!/bin/bash
#
# This needs changing for log book printing
#   as was from mvs JOB o/p
#
enscript --quiet --no-header --font=Courier-Bold@8/8 --truncate-lines --landscape --margins=30:30:40:40 -M A4 --highlight-bars=1 -p - ${i} | ps2pdf14 - ${OUTPUT}.pdf
rm $i
done
