      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            For Sumfield
      *            Sort/Merge COBOL Program and OCSort data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  iosqfi03.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external sqfi03
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-02s    pic s9(2) comp.
          05 filler     pic x.
          05 msr-02     pic 9(2) comp.
          05 filler     pic x.
          05 msr-04s    pic s9(4) comp.
          05 filler     pic x.
          05 msr-04     pic 9(4) comp.
          05 filler     pic x.
          05 msr-06s    pic s9(6) comp.
          05 filler     pic x.
          05 msr-06     pic 9(6) comp.
          05 filler     pic x.
          05 msr-08s    pic s9(8) comp.
          05 filler     pic x.
          05 msr-08     pic 9(8) comp.
          05 filler     pic x.
          05 msr-14s    pic s9(14) comp.
          05 filler     pic x.
          05 msr-14     pic 9(14) comp.
          05 filler     pic x.
          05 msr-16s    pic s9(16) comp.
          05 filler     pic x.
          05 msr-16     pic 9(16) comp.
          05 filler     pic x.
          05 msr-18s    pic s9(18) comp.
          05 filler     pic x.
          05 msr-18     pic 9(18) comp.
          05 filler     pic x.

       working-storage section.
       01 recordsize			pic 9999.
	   01 wk-tot.
          05 wrkmsr-03s    pic s9(3) comp.
          05 wrkmsr-03     pic 9(3) comp.
          05 wrkmsr-09s    pic s9(9) comp.
          05 wrkmsr-09     pic 9(9) comp.
          05 wrkmsr-18s    pic s9(18) comp.
          05 wrkmsr-18     pic 9(18) comp.

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
	      move all "|"                          to masterseqrecord. 
		  move  33 to msr-02, msr-02s
		  move  5555 to msr-04, msr-04s
		  move 777777 to msr-06, msr-06s
		  move 99999999 to msr-08, msr-08s
		  move 141414141414 to msr-14, msr-14s
		  move 2222222222222222 to msr-16, msr-16s
		  move 444444444444444444 to msr-18, msr-18s
    	  write masterseqrecord.
	      move all "|" to masterseqrecord. 
		  move -33                              to msr-02s
		  move  33                              to msr-02
		  move -5555                            to msr-04s
		  move  5555                            to msr-04
		  move -777777                          to msr-06s
		  move  777777                          to msr-06 
		  move -99999999                        to msr-08s
		  move  99999999                        to msr-08
		  move -141414141414                    to msr-14s
		  move 141414141414                     to msr-14
		  move -2222222222222222	            to msr-16s
		  move  2222222222222222                to msr-16
		  move 444444444444444444               to msr-18s
          multiply -1 by msr-18s
		  move 444444444444444444  to msr-18
    	  write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
