@echo off
echo "Start Script "
::* ----------------------------------------------------------------------------
::* File generated from ocsort_gentestcase
::* ----------------------------------------------------------------------------
::* pathgen     =/mnt/resource/newspace/
::* filename    =filegensq2min.txt
::* organization=SQ
::* record      =F
::* lenmin      =00030
::* lenmax      =00100
::* numrec      =5500000
::* ----------------------------------------------------------------------------
::  * Field : 00001 - Pos=00001, Len=00010, Type=PR
::  * Field : 00002 - Pos=00011, Len=00009, Type=CH, Order=A, KeySequence=1
::  * Field : 00003 - Pos=00020, Len=00003, Type=BI, Order=A, KeySequence=2
::  * Field : 00004 - Pos=00023, Len=00005, Type=PD, Order=A, KeySequence=3
::  * Field : 00005 - Pos=00028, Len=00003, Type=FI, Order=A, KeySequence=4
::  * Field : 00006 - Pos=00031, Len=00009, Type=FX
::  * Field : 00007 - Pos=00040, Len=00010, Type=CH, Order=D, KeySequence=6
::  * Field : 00008 - Pos=00050, Len=00003, Type=FX
::  * Field : 00009 - Pos=00053, Len=00005, Type=CH
::  * Field : 00010 - Pos=00058, Len=00012, Type=ZD, Order=A, KeySequence=5
::* ----------------------------------------------------------------------------
::*                             Key definition
:: * Key   : Order field 00002 - KeySequence=1 - Pos=00011, Len=00009, Type=CH
:: * Key   : Order field 00003 - KeySequence=2 - Pos=00020, Len=00003, Type=BI
:: * Key   : Order field 00004 - KeySequence=3 - Pos=00023, Len=00005, Type=PD
:: * Key   : Order field 00005 - KeySequence=4 - Pos=00028, Len=00003, Type=FI
:: * Key   : Order field 00010 - KeySequence=5 - Pos=00058, Len=00012, Type=ZD
:: * Key   : Order field 00007 - KeySequence=6 - Pos=00040, Len=00010, Type=CH
::* ----------------------------------------------------------------------------
cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS="64" -o ..\bin\TSTCHDATA2 ..\src\TSTCHDATA2.cbl
if %errorlevel = 1 goto lberr
cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS="64" -o ..\bin\TSTCHSORT2 ..\src\TSTCHSORT2.cbl
if %errorlevel = 1 goto lberr
set FGENFILE=..\files\filegensq2min.txt
..\bin\TSTCHDATA2
set OCSORT_MEMSIZE=512000000
set OCSORT_DEBUG=0
set OCSORT_STATISTICS=2
set OCSORT_SLOT=1
set OCSORT_MLT=63
..\bin\ocsort TAKE ../take/filegensq2min.txt.prm
if %errorlevel = 1 goto lberr
:: checkdata sortede by OCSort 
set FGENFILE=..\files\filegensq2min.txt.srt
..\bin\TSTCHSORT2
if %errorlevel = 1 goto lberr
goto lbend
:lberr
echo "Errors check log and steps"
:lbend
echo "End Script "
