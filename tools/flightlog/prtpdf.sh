#!/bin/bash
#
# 30/11/2018 vbc - This may need more changes for log book printing
#                  Needs packages - enscript and ghostscript-common
# 12/12/2018 vbc - Changes made for A4 and letter. There is versions 
#                  of this for both A4 and Letter called:
#                  prtpdf.sh-A4 and prtpdf.sh-Letter
#                  copy to prtpdf.sh the one for your location.
#                  This works for me but you might want to make font size
#                  change to use more of the paper width however only
#                  make ONE change at a time and then test it.
# 13/12/2018 vbc - Tested with Mageia v6 X64 and Raspberry Pi 3B+
#                  using its standard Debian Linux build.
#
enscript --quiet  --no-header -h -L 60 --font=Courier8@8/8 --landscape --margins=30:30:10:10 -M A4 -p - logbook.rpt | ps2pdf14 - logbook.pdf 
exit 0

