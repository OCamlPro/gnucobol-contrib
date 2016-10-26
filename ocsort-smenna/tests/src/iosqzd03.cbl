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
       program-id.  iosqzd03.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external sqzd03
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-02s    pic s9(2) .
          05 filler     pic x.
          05 msr-02     pic 9(2) .
          05 filler     pic x.
          05 msr-04s    pic s9(4) .
          05 filler     pic x.
          05 msr-04     pic 9(4) .
          05 filler     pic x.
          05 msr-06s    pic s9(6) .
          05 filler     pic x.
          05 msr-06     pic 9(6) .
          05 filler     pic x.
          05 msr-08s    pic s9(8) .
          05 filler     pic x.
          05 msr-08     pic 9(8) .
          05 filler     pic x.
          05 msr-10s    pic s9(10) .
          05 filler     pic x.
          05 msr-10     pic 9(10) .
          05 filler     pic x.
          05 msr-14s    pic s9(14) .
          05 filler     pic x.
          05 msr-14     pic 9(14) .
          05 filler     pic x.
          05 msr-18s    pic s9(18) .
          05 filler     pic x.
          05 msr-18     pic 9(18) .
          05 filler     pic x.
          05 msr-20s    pic s9(20) .
          05 filler     pic x.
          05 msr-20     pic 9(20) .
          05 filler     pic x.
          05 msr-22s    pic s9(22) .
          05 filler     pic x.
          05 msr-22     pic 9(22) .
          05 filler     pic x.
          05 msr-24s    pic s9(24) .
          05 filler     pic x.
          05 msr-24     pic 9(24) .
          05 filler     pic x.
          05 msr-28s    pic s9(28) .
          05 filler     pic x.
          05 msr-28     pic 9(28) .
          05 filler     pic x.
          05 msr-30s    pic s9(30) .
          05 filler     pic x.
          05 msr-30     pic 9(30) .
          05 filler     pic x.

       working-storage section.
       01 recordsize			pic 9999.
	   01 wk-tot.
          05 wrkmsr-03s    pic s9(3) .
          05 wrkmsr-03     pic 9(3) .
          05 wrkmsr-09s    pic s9(9) .
          05 wrkmsr-09     pic 9(9) .
          05 wrkmsr-18s    pic s9(18) .
          05 wrkmsr-18     pic 9(18) .

       procedure division.
       begin.
	      move zero to recordsize
          move recordsize  to wrkmsr-03s
		  move wrkmsr-18s  to recordsize
		
          open output masterseqfile.
	   prdi-00.
	      move  all "|"       to masterseqrecord. 
		  move 22                	to msr-02, msr-02s
		  move 4444              	to msr-04, msr-04s
		  move 66666                to msr-06, msr-06s
		  move 8888888             to msr-08, msr-08s
		  move 1010101010           to msr-10, msr-10s
		  move 14141414141414       to msr-14, msr-14s
		  move 181818181818181818   to msr-18, msr-18s
		  move 20202020202020202020   			
					to msr-20
		  move 20202020202020202020   			
					to msr-20s
      *   multiply -1 by msr-20s          
		  move 2222222222222222222222
						to msr-22s
		  move 2222222222222222222222
						to msr-22
		  move  242424242424242424242424
						to msr-24s
		  move  242424242424242424242424
						to msr-24
		  move 2828282828282828282828282828
						to msr-28s
		  move 2828282828282828282828282828
						to msr-28
		  move 444444444444444444444444444444
						to msr-30s
		  move 444444444444444444444444444444
						to msr-30
    	  write masterseqrecord.
	      move  all "|"        to masterseqrecord. 
		  move -22      	to msr-02s
		  move  22          to msr-02
		  move -4444        to msr-04s
		  move  4444        to msr-04
		  move -66666       to msr-06s
		  move  66666       to msr-06
		  move -8888888    to msr-08s
		  move  8888888    to msr-08 
		  move -1010101010  to msr-10s
		  move  1010101010  to msr-10
		  move -14141414141414  to msr-14s
		  move  14141414141414  to msr-14
		  move -181818181818181818
						to msr-18s
		  move  181818181818181818
						to msr-18
		  move 20202020202020202020   			
					to msr-20
		  move 20202020202020202020   			
					to msr-20s
          multiply -1 by msr-20s        
		  move 2222222222222222222222
						to msr-22s
          multiply -1 by msr-22s          
		  move  2222222222222222222222
						to msr-22
		  move  242424242424242424242424
						to msr-24s
          multiply -1 by msr-24s          
		  move  242424242424242424242424
						to msr-24
		  move 2828282828282828282828282828
						to msr-28s
          multiply -1 by msr-28s          
		  move 2828282828282828282828282828
						to msr-28
		  move 444444444444444444444444444444
						to msr-30s
          multiply -1 by msr-30s          
		  move 444444444444444444444444444444
						to msr-30
    	  write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
