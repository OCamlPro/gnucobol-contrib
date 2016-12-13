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
       program-id.  iosqpd01.
      * read the sequential file master.seq.dat and ouput on the system.out
      * this file contents the length of the record in the direct master file.
      * use the lenrec.dat file to know the size of the records to read.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external sqpd01
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-03s    pic s9(3) comp-3.
          05 filler     pic x.
          05 msr-03     pic 9(3) comp-3.
          05 filler     pic x.
          05 msr-05s    pic s9(5) comp-3.
          05 filler     pic x.
          05 msr-05     pic 9(5) comp-3.
          05 filler     pic x.
          05 msr-07s    pic s9(7) comp-3.
          05 filler     pic x.
          05 msr-07     pic 9(7) comp-3.
          05 filler     pic x.
          05 msr-09s    pic s9(9) comp-3.
          05 filler     pic x.
          05 msr-09     pic 9(9) comp-3.
          05 filler     pic x.
          05 msr-18s    pic s9(18) comp-3.
          05 filler     pic x.
          05 msr-18     pic 9(18) comp-3.
          05 filler     pic x.
          05 msr-31s    pic s9(31) comp-3.
          05 filler     pic x.
          05 msr-31     pic 9(31) comp-3.
          05 filler     pic x.

       working-storage section.
       01 recordsize			pic 9999.
	   01 wk-tot.
          05 wrkmsr-03s    pic s9(3) comp-3.
          05 wrkmsr-03     pic 9(3) comp-3.
          05 wrkmsr-09s    pic s9(9) comp-3.
          05 wrkmsr-09     pic 9(9) comp-3.
          05 wrkmsr-18s    pic s9(18) comp-3.
          05 wrkmsr-18     pic 9(18) comp-3.

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
          move 333                              to msr-03,msr-03s
          move 5555                             to msr-05,msr-05s
          move 77777                            to msr-07,msr-07s
          move 99999999                         to msr-09,msr-09s
          move 222222222222222222               to msr-18,msr-18s
          move 444444444444444444444444444444   to msr-31,msr-31s
      *   move zero                    to msr-31,msr-31s
          write masterseqrecord.
          move all "|"                          to masterseqrecord. 
          move -333                             to msr-03s
          move  333                             to msr-03
          move -5555                            to msr-05s
          move  5555                            to msr-05
          move -77777                           to msr-07s
          move  77777                           to msr-07 
          move -99999999                        to msr-09s
          move  99999999                        to msr-09
          move -222222222222222222              to msr-18s
          move  222222222222222222              to msr-18
          move  444444444444444444444444444444  to msr-31s
      *   move zero                   to msr-31s
          multiply -1 by msr-31s
          move  444444444444444444444444444444  to msr-31
      *   move zero                   to msr-31
          write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
