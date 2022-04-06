@ECHO OFF
:: -- ===================================== --
:: --              TEST CASE
:: -- ===================================== --
set GCSORT_STATISTICS=2

:: --[01] -- Inner Join
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.01.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.01.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.01_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[01] -- Inner Join " %ERRORLEVEL%

:: --[02] -- Unpaired F1 -- Unpaired records from F1 as well as paired records. This is known as a left outer join.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250   USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.02.srt ORG LS  RECORD F,50 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.02.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.02_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[02] -- Unpaired F1  " %ERRORLEVEL%

:: --[03] -- Unpaired F2 -- Unpaired records from F2 as well as paired records. This is known as a right outer join.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.03.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.03.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.03_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[03] -- Unpaired F2  " %ERRORLEVEL%

:: --[04] -- Unpaired F1,F2 -- Unpaired records from F1 and F2 as well as paired records. This is known as a full outer join.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.04.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.04.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.04_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[04] -- Unpaired records from F1 and F2 as well as paired records. " %ERRORLEVEL%

:: --[22] -- Unpaired F1,F2 -- Unpaired records from F1 and F2 as well as paired records.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin21.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin22.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.22.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.22.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.22_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[22] -- Unpaired records from F1 and F2 as well as paired records. " %ERRORLEVEL%


:: --[05] -- Unpaired  -- Unpaired records from F1 and F2 as well as paired records. This is known as a full outer join.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.05.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.05.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.05_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[05] -- Unpaired records from F1 and F2 as well as paired records. " %ERRORLEVEL%

:: 
:: --[06] -- Unpaired F1,ONLY -- Unpaired records from F1.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(F1:1,26) JOIN UNPAIRED,F1,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.06.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.06.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.06_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[06] -- Unpaired F1,ONLY " %ERRORLEVEL%

:: --[07] -- Unpaired F2,ONLY -- Unpaired records from F2.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(F2:1,23) JOIN UNPAIRED,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.07.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.07.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.07_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[07] -- Unpaired F2,ONLY " %ERRORLEVEL%

:: --[08] -- Unpaired F1,F2,ONLY -- Unpaired records from F1 and F2.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.08.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.08.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.08_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[08] -- Unpaired F1,F2,ONLY " %ERRORLEVEL%

:: --[09] -- Unpaired ONLY -- Unpaired records from F1 and F2.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.09.srt ORG LS  RECORD F,250 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.09.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.09_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[09] -- Unpaired ONLY " %ERRORLEVEL%

:: --[10] --Inner Join -- INNER JOIN  F1 and F2.
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.10.srt ORG LS  RECORD F,50 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.10.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpjoin03.10_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[10] -- Inner Join " %ERRORLEVEL%


::::::
:: --  OUTREC after SORT
:: --[11] --Inner Join -- INNER JOIN  F1 and F2.  -- With OUTREC
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.11.srt ORG LS  RECORD F,50  OUTREC FIELDS=(1,1,CHANGE=(7,C'7',28,6),NOMATCH=(2,6),X,35,23,8,19)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.11.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpjoin03.11_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[10] -- Inner Join " %ERRORLEVEL%

::
:::: --  OUTREC after JOIN - FILE SORTED
::JOINKEYS FILES=F1,FIELDS=(1,6,A),SORTED JOINKEYS FILES=F2,FIELDS=(1,6,A),SORTED  REFORMAT FIELDS=(?,F1:1,26,F2:1,23),SORTED USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.10.srt ORG LS  RECORD F,50  OUTREC FIELDS=(1,1,CHANGE=(6,C'2',28,6),NOMATCH=(2,6),X,8,19,35,24)
::
:::: --  OUTREC after SORT - SORTED - STOPAFT=5
::JOINKEYS FILES=F1,FIELDS=(1,6,A),SORTED JOINKEYS FILES=F2,FIELDS=(1,6,A),SORTED,STOPAFT=5  REFORMAT FIELDS=(?,F1:1,26,F2:1,23),SORTED USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpjoin03.10.srt ORG LS  RECORD F,50  OUTREC FIELDS=(1,1,CHANGE=(6,C'2',28,6),NOMATCH=(2,6),X,8,19,35,24)
::
::::---
::::-- Test case inpjoin01_Case_01
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(14,16,A) JOINKEYS FILES=F2,FIELDS=(1,16,A) REFORMAT FIELDS=(F2:22,12,F1:1,12,F2:1,16) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_01.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01.srt ORG LS  RECORD F,50 
::::
::::-- Test case inpjoin01_Case_02   with final sort - SORT FIELDS=(1,6,CH,A)
::::
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_02.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case02.srt ORG LS  RECORD F,50 SORT FIELDS=(1,6,CH,A)
::::
::::-- Test case inpjoin01_Case_01  with final sort - SORT FIELDS=(13,12,CH,A)
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(14,16,A) JOINKEYS FILES=F2,FIELDS=(1,16,A) REFORMAT FIELDS=(F2:22,12,F1:1,12,F2:1,16) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_01.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01.srt ORG LS  RECORD F,50  SORT FIELDS=(13,12,CH,A)
::::-- Inner with sort asc 1 key
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseA.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
::::-- Inner with sort asc 2 keys
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,3,A,4,3,A) JOINKEYS FILES=F2,FIELDS=(1,3,A,4,3,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseB.srt ORG LS RECORD F,50 SORT FIELDS=(1,3,CH,A,4,3,CH,A)
:::: -- Inner with sort asc 2 keys desc
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,3,D,4,3,A) JOINKEYS FILES=F2,FIELDS=(1,3,D,4,3,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseC.srt ORG LS RECORD F,50 SORT FIELDS=(1,3,CH,D,4,3,CH,A)
::
::::-- UNPAIRED F1, F2 with OUTREC
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.outrec.srt ORG LS  RECORD F,50   OUTREC BUILD=(35,16,15,20,1,14)  
::
:: 
..\bin\gcsort TAKE C:\GCSORT\GCSORT_relnew\tests\test_join\join_outfil.prm
::
:: condition for exit in double cycle
::-- Group 1A
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.INNER.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.INNER.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.INNER_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_full_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_full_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_full_outer_join] -- Full Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F1_left_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_F1_left_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_left_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F2_right_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_F2_right_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_right_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_ONLY] -- Unpaired ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F1_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_F1_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F1_ONLY] -- Unpaired F1 ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinA.UNPAIRED_F2_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinA.UNPAIRED_F2_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F2_ONLY] -- Unpaired F2 ONLY " %ERRORLEVEL%

::-- Group 2B
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.INNER.srt ORG LS  RECORD F,30 
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
:: ..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.INNER.srt ORG LS  RECORD F,30 

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.INNER.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.INNER.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.INNER_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_full_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_full_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_full_outer_join] -- Full Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_left_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_F1_left_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_left_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_right_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_F2_right_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_right_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_ONLY] -- Unpaired ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F1_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_F1_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F1_ONLY] -- Unpaired F1 ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinB.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinB.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinB.UNPAIRED_F2_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinB.UNPAIRED_F2_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F2_ONLY] -- Unpaired F2 ONLY " %ERRORLEVEL%

::-- Group 3C -- Last key is identical for F1 and F2
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.INNER.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.INNER.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.INNER.srt C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.INNER_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_full_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_full_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_full_outer_join] -- Full Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_left_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_F1_left_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_left_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_right_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_F2_right_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_right_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_ONLY] -- Unpaired ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F1_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_F1_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F1_ONLY] -- Unpaired F1 ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinC.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinC.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinC.UNPAIRED_F2_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinC.UNPAIRED_F2_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F2_ONLY] -- Unpaired F2 ONLY " %ERRORLEVEL%

::-- Group 4D -- F1 empty
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.INNER.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.INNER.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.INNER.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.INNER_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_full_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_full_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_full_outer_join] -- Full Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_left_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_F1_left_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_left_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_right_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_F2_right_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_right_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_ONLY] -- Unpaired ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F1_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_F1_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F1_ONLY] -- Unpaired F1 ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinD.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinD.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinD.UNPAIRED_F2_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinD.UNPAIRED_F2_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F2_ONLY] -- Unpaired F2 ONLY " %ERRORLEVEL%
::-- Group 5E -- F2 empty
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.INNER.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_left_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
::..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11)                          USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.INNER02.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.INNER02.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.INNER02_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2      USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_full_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_full_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_full_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_full_outer_join] -- Full Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_left_outer_join02.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_left_outer_join02.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_F1_left_outer_join02_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_left_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2         USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_right_outer_join.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_right_outer_join.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_F2_right_outer_join_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_right_outer_join] -- Left Outer Join " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,F2,ONLY USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_ONLY] -- Unpaired ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F1,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_ONLY.srt ORG LS  RECORD F,30
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F1_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_F1_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F1_ONLY] -- Unpaired F1 ONLY " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,2,A) JOINKEYS FILES=F2,FIELDS=(1,2,A)  REFORMAT FIELDS=(?,F1:1,11,F2:1,11) JOIN UNPAIRED,F2,ONLY    USE  C:\GCSORT\GCSORT_relnew\tests\files\F1JoinE.txt ORG LS RECORD F,15  USE  C:\GCSORT\GCSORT_relnew\tests\files\F2JoinE.txt ORG LS RECORD F,15  GIVE C:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_ONLY.srt ORG LS  RECORD F,30 
fc c:\GCSORT\GCSORT_relnew\tests\files\FOutJoinE.UNPAIRED_F2_ONLY.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\FOutJoinE.UNPAIRED_F2_ONLY_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_F2_ONLY] -- Unpaired F2 ONLY " %ERRORLEVEL%


:: ==================================
::-- Test case inpjoin01_Case_01
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(14,16,A) JOINKEYS FILES=F2,FIELDS=(1,16,A) REFORMAT FIELDS=(F2:22,12,F1:1,12,F2:1,16) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_01.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01.srt ORG LS  RECORD F,50 
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.Case01_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join -- Case01 " %ERRORLEVEL%


::-- Test case inpjoin01_Case_02   with final sort - SORT FIELDS=(1,6,CH,A)
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_02.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case02.srt ORG LS  RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case02.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.Case02_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join -- Case02 " %ERRORLEVEL%


::-- Test case inpjoin01_Case_01  with final sort - SORT FIELDS=(13,12,CH,A)
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(14,16,A) JOINKEYS FILES=F2,FIELDS=(1,16,A) REFORMAT FIELDS=(F2:22,12,F1:1,12,F2:1,16) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02_Case_01.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01A.srt ORG LS  RECORD F,50  SORT FIELDS=(13,12,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.Case01A.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.Case01A_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join -- Case01A " %ERRORLEVEL%


::-- JOIN with OUTREC
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A),SORTED JOINKEYS FILES=F2,FIELDS=(1,6,A),SORTED,STOPAFT=5  REFORMAT FIELDS=(?,F1:1,26,F2:1,23),SORTED USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin04_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin04_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpjoin04.10.srt ORG LS  RECORD F,50  OUTREC FIELDS=(1,1,CHANGE=(6,C'2',28,6),NOMATCH=(2,6),X,8,19,35,24)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpjoin04.10.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpjoin04.10_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Sorted -- Case04.10 " %ERRORLEVEL%

::-- Inner Join with INCLUDE
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A),INCLUDE=(1,6,CH,EQ,C'222222') JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin05_Case.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin05_Case.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin05_Case_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Include -- Case05 " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A),INCLUDE=(1,6,CH,EQ,C'222222',OR,1,6,CH,EQ,C'551555') JOINKEYS FILES=F2,FIELDS=(1,6,A),INCLUDE=(1,6,CH,EQ,C'551555')  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin06_Case.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin06_Case.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin06_Case_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Include -- Case06 " %ERRORLEVEL%

::-- Inner Join with OMIT
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A),OMIT=(1,6,CH,EQ,C'222222') JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin05A_Case.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin05A_Case.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin05A_Case_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Omit -- Case05A " %ERRORLEVEL%

..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A),OMIT=(1,6,CH,EQ,C'222222',OR,1,6,CH,EQ,C'551555') JOINKEYS FILES=F2,FIELDS=(1,6,A),OMIT=(1,6,CH,EQ,C'551555')  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin05_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin08_Case.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin08_Case.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin08_Case_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Omit -- Case08 " %ERRORLEVEL%

::-- Inner with sort asc 1 key 
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin07_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin07_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin07_Case.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin07_Case.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin07_Case_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Omit -- Case07 " %ERRORLEVEL%


::-- Inner with sort asc 1 key
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseA.srt ORG LS RECORD F,50 SORT FIELDS=(1,6,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseA.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin95_CaseA_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Sort Fields -- Case95A " %ERRORLEVEL%

::-- Inner with sort asc 2 keys
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,3,A,4,3,A) JOINKEYS FILES=F2,FIELDS=(1,3,A,4,3,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseB.srt ORG LS RECORD F,50 SORT FIELDS=(1,3,CH,A,4,3,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseB.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin95_CaseB_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join Sort Fields -- Case95B " %ERRORLEVEL%


::-- Inner with sort desc
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,3,D,4,3,A) JOINKEYS FILES=F2,FIELDS=(1,3,D,4,3,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_01.txt ORG LS RECORD F,50  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin95_Case_02.txt ORG LS RECORD F,50  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseC.srt ORG LS RECORD F,50 SORT FIELDS=(1,3,CH,D,4,3,CH,A)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin95_CaseC.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin95_CaseC_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED_Inner_join] -- Inner Join SKey Desc  -- Case95C " %ERRORLEVEL%


::-- UNPAIRED F1, F2 with OUTFIL
:: problema slash JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.txt.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=F1ONLY,INCLUDE=(1,1,CH,EQ,C'1'),    BUILD=(1,14)  OUTFIL FNAMES=F2ONLY,INCLUDE=(1,1,CH,EQ,C'2'),    BUILD=(15,20)  OUTFIL FNAMES=BOTH,INCLUDE=(15,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), BUILD=(1,14,/,15,20)
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin50.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F1ONLY50.outfil,INCLUDE=(1,1,CH,EQ,C'1'),    BUILD=(1,14)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F2ONLY50.outfil,INCLUDE=(1,1,CH,EQ,C'2'),    BUILD=(15,20)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\BOTH50.outfil,INCLUDE=(1,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), BUILD=(1,14,15,20)
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin50.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin50_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case50 output" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F1ONLY50.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F1ONLY50_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case50 F1 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F2ONLY50.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F2ONLY50_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case50 F2 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\BOTH50.outfil    C:\GCSORT\GCSORT_relnew\tests\files_cmp\BOTH50_OK.outfil   
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case50 BOTH outfil" %ERRORLEVEL%

::-- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL
:: problema slash JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.txt.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=F1ONLY,INCLUDE=(1,1,CH,EQ,C'1'),    BUILD=(1,14)  OUTFIL FNAMES=F2ONLY,INCLUDE=(1,1,CH,EQ,C'2'),    BUILD=(15,20)  OUTFIL FNAMES=BOTH,INCLUDE=(15,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), BUILD=(1,14,/,15,20)
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.txt.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F1ONLY51.outfil,INCLUDE=(1,1,CH,EQ,C'1'),    BUILD=(1,14)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F2ONLY51.outfil,INCLUDE=(1,1,CH,EQ,C'2'),    BUILD=(15,20)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\BOTH51.outfil,INCLUDE=(1,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), BUILD=(1,14,15,20)  
::  fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin51.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin51_OK.srt
::  if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case51 output" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F1ONLY51.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F1ONLY51_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case51 F1 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F2ONLY51.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F2ONLY51_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case51 F2 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\BOTH51.outfil    C:\GCSORT\GCSORT_relnew\tests\files_cmp\BOTH51_OK.outfil   
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- Unpaired F1, F2 outfil  -- Case51 BOTH outfil" %ERRORLEVEL%

::-- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL
:: problema slash JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.txt.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=F1ONLY,INCLUDE=(1,1,CH,EQ,C'1'),    BUILD=(1,14)  OUTFIL FNAMES=F2ONLY,INCLUDE=(1,1,CH,EQ,C'2'),    BUILD=(15,20)  OUTFIL FNAMES=BOTH,INCLUDE=(15,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), BUILD=(1,14,/,15,20)
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.txt.srt ORG LS  RECORD F,250   OPTION COPY  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F1ONLY52.outfil,INCLUDE=(1,1,CH,EQ,C'1'),OUTREC BUILD=(1,14)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\F2ONLY52.outfil,INCLUDE=(1,1,CH,EQ,C'2'),OUTREC BUILD=(15,20)  OUTFIL FNAMES=C:\GCSORT\GCSORT_relnew\tests\files\BOTH52.outfil,INCLUDE=(1,1,CH,NE,C'1',AND,1,1,CH,NE,C'2'), OUTREC BUILD=(1,14,15,20)  
::  fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin52.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin52_OK.srt
::  if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL  -- Case51 output" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F1ONLY52.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F1ONLY52_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL  -- Case51 F1 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\F2ONLY52.outfil  C:\GCSORT\GCSORT_relnew\tests\files_cmp\F2ONLY52_OK.outfil 
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL  -- Case51 F2 outfil" %ERRORLEVEL%
fc c:\GCSORT\GCSORT_relnew\tests\files\BOTH52.outfil    C:\GCSORT\GCSORT_relnew\tests\files_cmp\BOTH52_OK.outfil   
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPAIRED F1, F2 with OUTFIL and BUILD for OUTFIL  -- Case51 BOTH outfil" %ERRORLEVEL%

::-- UNPAIRED F1, F2 with OUTREC
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.outrec.srt ORG LS  RECORD F,50   OUTREC BUILD=(35,16,15,20,1,14)  
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.outrec.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.outrec_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPAIRED F1, F2 with OUTREC  -- Outrec " %ERRORLEVEL%

::-- UNPAIRED F1, F2 with no OUTREC
..\bin\gcsort JOINKEYS FILES=F1,FIELDS=(1,6,A) JOINKEYS FILES=F2,FIELDS=(1,6,A)  REFORMAT FIELDS=(?,F1:1,26,F2:1,23) JOIN UNPAIRED,F1,F2 USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin01.txt ORG LS RECORD F,250  USE  C:\GCSORT\GCSORT_relnew\tests\files\inpjoin02.txt ORG LS RECORD F,250  GIVE C:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.NOoutrec.srt ORG LS  RECORD F,50   OUTREC BUILD=(35,16,15,20,1,14)  
fc c:\GCSORT\GCSORT_relnew\tests\files\inpoutjoin.NOoutrec.srt C:\GCSORT\GCSORT_relnew\tests\files_cmp\inpoutjoin.NOoutrec_OK.srt
if %ERRORLEVEL% GTR 1 echo "ERRORE --[UNPAIRED F1, F2] -- UNPUNPAIRED F1, F2 with no OUTREC  -- No OUTREC " %ERRORLEVEL%
