#!/bin/bash
#
# 30/11/2018 vbc - This may need more changes for log book printing
#                  Needs packages - enscript and ghostscript-common
# 12/12/2018 vbc - Changes made for A4 and letter. There is versions 
#                  of this for bot A4 and Letter called:
#                  prtpdf.sh-A4 and prtpdf.sh-Letter
#                  copy to prtpdf.sh the one for your location.
#
enscript --quiet  --no-header -h -L 60 --font=Courier9@9/8 --landscape --margins=30:30:10:10 -M A4 -p - logbook.rpt | ps2pdf14 - logbook.pdf 
exit 0

