## -- ===================================== --
## --              TEST CASE
## -- ===================================== --
echo "** -- Inner Join OK" >tmp01.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE ../files/inpjoin01.txt ORG LS RECORD F,250 USE ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.01.srt ORG LS  RECORD F,250 " >>tmp01.prm
../bin/gcsort TAKE tmp01.prm
echo "** -- Unpaired F1 -- Unpaired records from F1 as well as paired records. This is known as a left outer join." >tmp02.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE ../files/inpjoin01.txt ORG LS RECORD F,250 USE ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.02.srt ORG LS  RECORD F,250 " >>tmp02.prm
../bin/gcsort TAKE tmp02.prm
echo "** -- Unpaired F1 -- Unpaired records from F1 as well as paired records. This is known as a left outer join." >tmp03.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1      USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.03.srt ORG LS  RECORD F,250 " >>tmp03.prm
../bin/gcsort TAKE tmp03.prm
echo "** -- Unpaired F2 -- Unpaired records from F2 as well as paired records. This is known as a right outer join." >tmp04.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F2      USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.04.srt ORG LS  RECORD F,250 " >>tmp04.prm
../bin/gcsort TAKE tmp04.prm
echo "** -- Unpaired F1,F2 -- Unpaired records from F1 and F2 as well as paired records. This is known as a full outer join." >tmp05.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.05.srt ORG LS  RECORD F,250 " >>tmp05.prm
../bin/gcsort TAKE tmp05.prm
echo "** -- Unpaired  -- Unpaired records from F1 and F2 as well as paired records. This is known as a full outer join." >tmp06.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED  USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.06.srt ORG LS  RECORD F,250 " >>tmp06.prm
../bin/gcsort TAKE tmp06.prm
##  
echo "** -- Unpaired F1,ONLY -- Unpaired records from F1." >tmp07.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(F1:1,26) JOIN UNPAIRED,F1,ONLY USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.07.srt ORG LS  RECORD F,250 " >>tmp07.prm
../bin/gcsort TAKE tmp07.prm
echo "** -- Unpaired F2,ONLY -- Unpaired records from F2." >tmp08.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(F2:1,23) JOIN UNPAIRED,F2,ONLY USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.08.srt ORG LS  RECORD F,250 " >>tmp08.prm
../bin/gcsort TAKE tmp08.prm
echo "** -- Unpaired F1,F2,ONLY -- Unpaired records from F1 and F2." >tmp09.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2,ONLY USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.09.srt ORG LS  RECORD F,250 "  >>tmp09.prm
../bin/gcsort TAKE tmp09.prm
echo "** -- Unpaired ONLY -- Unpaired records from F1 and F2." >tmp10.prm
echo "JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,ONLY USE  ../files/inpjoin01.txt ORG LS RECORD F,250  USE  ../files/inpjoin02.txt ORG LS RECORD F,250  GIVE ../files/inpoutjoin.10.srt ORG LS  RECORD F,250 "  >>tmp10.prm
../bin/gcsort TAKE tmp10.prm

