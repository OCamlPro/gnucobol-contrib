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
       program-id.  iosqvar1.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqvar1
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-01     pic x(10).
          05 msr-02     pic s9(4) comp.
          05 msr-03     pic s9(5) comp-3.
          05 msr-04     pic s9(5).
          05 msr-05     pic s9(2) binary.

       working-storage section.
       procedure division.
       begin.
          open output masterseqfile.
	   prdi-100.
          move "aaaaaaaaaa"                  to msr-01
          move 100                           to msr-02
          move 50                            to msr-03
          move 250                           to msr-04
          move 85                            to msr-05
          write masterseqrecord.
          move "zzzzzzzzzz"                  to msr-01
          move 800                           to msr-02
          move 90                            to msr-03
          move 350                           to msr-04
          move 45                            to msr-05
          write masterseqrecord.
          move "bbbbbbbbbb"                  to msr-01
          move 300                           to msr-02
          move 70                            to msr-03
          move 250                           to msr-04
          move 65                            to msr-05
          write masterseqrecord.
          move "dddddddddd"                  to msr-01
          move 200                           to msr-02
          move 20                            to msr-03
          move 950                           to msr-04
          move 75                            to msr-05
          write masterseqrecord.
	   prdi-199.			
          close masterseqfile.
          stop run.
