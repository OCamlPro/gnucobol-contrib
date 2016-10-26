      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL file variable
      *            For Sumfield
      *            Sort/Merge COBOL Program and OCSort data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  IOIXPA.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external ixpa
               organization is indexed
               access mode  is dynamic
               record key is msr-02
               alternate record key is msr-03
               alternate record key is msr-04 with duplicates
               alternate record key is msr-05 with duplicates
               .

       data division.
       file section.
       fd masterseqfile 
           record is varying in size 
              from 22 to 250 characters
                 depending on recordsize
                recording mode is v.
       01 masterseqrecord.
          05 msr-01     pic x(10).
          05 msr-02     pic s9(4) comp.
          05 msr-03     pic s9(5) comp-3.
          05 msr-04     pic s9(5).
          05 msr-05     pic s9(2) binary.
          05 msr-06     pic 9(5).
          05 filler     pic x(219).
          05 msr-99     pic x(5).

       working-storage section.
000000**       01 recordsize			pic 9999.
       77 recordsize			pic s9(5) comp-3.
       
       77 prog   			    pic 9999 value zero.
       procedure division.
       begin-00.
          open output masterseqfile.
          perform cycle-00 5 times.
          go cycle-50.
       cycle-00.
      *    move  low-value   to masterseqrecord
          move  all "W" to masterseqrecord
          add   1           to prog.
          move  250         to recordsize.
          move  all "a"     to msr-01
          move  10          to msr-02
          add   prog        to msr-02
          move  11          to msr-03
          add   prog        to msr-03
          move  12          to msr-04
          add   prog        to msr-04
          move  22          to msr-05
          add   prog        to msr-05
          move  88888       to msr-06
          move "@@@@@"      to msr-99
		  write  masterseqrecord invalid key go to lb-50.
       cycle-50.
          close masterseqfile.
          open input masterseqfile.
          perform cycle-80 5 times.
          go cycle-100.
       cycle-80.
		  read masterseqfile at end go to cycle-100.
      *   display "Record >" masterseqrecord "<".
       lb-50.  
          display "Error ".
       cycle-100.
          close masterseqfile.
       end-proc.
          stop run.
