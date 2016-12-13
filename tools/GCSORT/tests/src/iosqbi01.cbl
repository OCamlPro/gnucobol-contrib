      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            For Sumfield
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  iosqbi.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqbi01
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-03s    pic s9(3) comp.
          05 filler     pic x.
          05 msr-03     pic  9(3) comp.
          05 filler     pic x.
          05 msr-05s    pic s9(5) comp.
          05 filler     pic x.
          05 msr-05     pic  9(5) comp.
          05 filler     pic x.
          05 msr-07s    pic s9(7) comp.
          05 filler     pic x.
          05 msr-07     pic  9(7) comp.
          05 filler     pic x.
          05 msr-09s    pic  s9(9) comp.
          05 filler     pic x.
          05 msr-09     pic  9(9) comp.
          05 filler     pic x.
          05 msr-11s    pic  s9(11) comp.
          05 filler     pic x.
          05 msr-11     pic  9(11) comp.
          05 filler     pic x.
          05 msr-13s    pic  s9(13) comp.
          05 filler     pic x.
          05 msr-13     pic  9(13) comp.
          05 filler     pic x.
          05 msr-15s    pic  s9(15) comp.
          05 filler     pic x.
          05 msr-15     pic  9(15) comp.
          05 filler     pic x.
          05 msr-17s    pic  s9(17) comp.
          05 filler     pic x.
          05 msr-17     pic  9(17) comp.
          05 filler     pic x.
          05 msr-18s    pic s9(18) comp.
          05 filler     pic x.
          05 msr-18     pic  9(18) comp.
          05 filler     pic x.

       working-storage section.
       01 recordsize			pic 9999.
	   01 wk-tot.
          05 wrkmsr-03s    pic s9(3) comp.
          05 wrkmsr-03     pic  9(3) comp.
          05 wrkmsr-09s    pic s9(9) comp.
          05 wrkmsr-09     pic  9(9) comp.
          05 wrkmsr-18s    pic s9(18) comp.
          05 wrkmsr-18     pic  9(18) comp.

       procedure division.
       begin.
	      move zero to recordsize
		  move 58 to 	wrkmsr-03s, wrkmsr-03
						wrkmsr-09s, wrkmsr-09
						wrkmsr-18s, wrkmsr-18
          move recordsize  to wrkmsr-03s
		  move wrkmsr-18s  to recordsize
		
          open output masterseqfile.
	   prdi-00.
	      move all "|"      to masterseqrecord. 
		  move 333                to msr-03,msr-03s
		  move 55555              to msr-05, msr-05s
		  move 7777777            to msr-07, msr-07s
		  move 999999999          to msr-09, msr-09s
		  move 44444444444        to msr-11s
		  move 44444444444        to msr-11
		  move 6666666666666      to msr-13s
		  move 6666666666666      to msr-13
		  move 222222222222222    to msr-15s
		  move 222222222222222    to msr-15
		  move 88888888888888888  to msr-17s
		  move 88888888888888888  to msr-17
		  move 222222222222222222 to msr-18, msr-18s
    	  write masterseqrecord.
	      move all "|"		       to masterseqrecord. 
		  move -333                to msr-03s
		  move  333                to msr-03
		  move -55555              to msr-05s
		  move  55555              to msr-05
		  move -7777777            to msr-07s
		  move  7777777            to msr-07 
		  move -999999999          to msr-09s
		  move  999999999          to msr-09
		  move -44444444444        to msr-11s
		  move  44444444444        to msr-11
		  move -6666666666666      to msr-13s
		  move  6666666666666      to msr-13
		  move -222222222222222    to msr-15s
		  move  222222222222222    to msr-15
		  move -88888888888888888  to msr-17s
		  move  88888888888888888  to msr-17
		  move -222222222222222222 to msr-18s
		  move  222222222222222222 to msr-18
    	  write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
