## * ----------------------------------------------------------------------------
## * File generated from ocsort_gentestcase
## * ----------------------------------------------------------------------------
## * pathgen     =../files\
## * filename    =filegen.LS
## * organization=LS
## * record      =F
## * lenmin      =00030
## * lenmax      =00100
## * numrec      =00100
## * ----------------------------------------------------------------------------
##  * Field : 00001 - Pos=00001, Len=00005, Type=PR, Order=D, KeySequence=1
##  * Field : 00002 - Pos=00006, Len=00005, Type=ZD, Order=A, KeySequence=2
##  * Field : 00003 - Pos=00011, Len=00009, Type=CH, Order=A, KeySequence=3
##  * Field : 00004 - Pos=00020, Len=00003, Type=CH
##  * Field : 00005 - Pos=00023, Len=00003, Type=ZD
##  * Field : 00006 - Pos=00026, Len=00010, Type=FX
##  * Field : 00007 - Pos=00036, Len=00010, Type=CH
##  * Field : 00008 - Pos=00046, Len=00003, Type=FX
##  * Field : 00009 - Pos=00049, Len=00005, Type=CH
##  * Field : 00010 - Pos=00054, Len=00012, Type=ZD
## * ----------------------------------------------------------------------------
## *                             Key definition
##  * Key   : Order field 00001 - KeySequence=1 - Pos=00001, Len=00005, Type=PR
##  * Key   : Order field 00002 - KeySequence=2 - Pos=00006, Len=00005, Type=ZD
##  * Key   : Order field 00003 - KeySequence=3 - Pos=00011, Len=00009, Type=CH
##* ----------------------------------------------------------------------------
linux  export LD_LIBRARY_PATH=/usr/local/lib
export RTC=0
if [ "$RTC" == "0" ] ; then 	
      cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS="64" -o ../bin/TSTCHDATAL3 ../src/TSTCHDATAL3.cbl
	export RTC=$?
else
	export RTC=1
fi
if [ "$RTC" == "0" ] ; then 	
     cobc -x -std=mf -debug -Wall -D_FILE_OFFSET_BITS="64" -o ../bin/TSTCHSORTL3 ../src/TSTCHSORTL3.cbl
	export RTC=$?
else
	export RTC=1
fi
if [ "$RTC" == "0" ] ; then 	
      export FGENFILE=../files\filegen.LS
      ../bin/TSTCHDATAL3
	    export RTC=$?
else
	    export RTC=1
fi
if [ "$RTC" == "0" ] ; then 	
EXPORT OCSORT_PATHTMP=./
EXPORT OCSORT_MEMSIZE=512000000
EXPORT OCSORT_DEBUG=0
EXPORT OCSORT_STATISTICS=2
EXPORT OCSORT_SLOT=1
EXPORT OCSORT_MLT=63
      ../bin/ocsort TAKE  ../take/filegen.LS.prm
	export RTC=$?
else
	export RTC=1
fi
##  checkdata sortede by OCSort 
if [ "$RTC" == "0" ] ; then 	
      export FGENFILE=../files\filegen.LS.srt
     ../bin/TSTCHSORTL3
	export RTC=$?
else
	export RTC=1
fi
if [ "$RTC" == "0" ] ; then 	
     echo "Script OK"
else
	   echo "Script KO"
fi
