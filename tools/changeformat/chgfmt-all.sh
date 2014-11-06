#!/bin/bash
for i in `ls st0*.cbl`; do changeformat $i ~/cobolsrc/ACAS/stock-fixed/ tofixed; done
exit 0

