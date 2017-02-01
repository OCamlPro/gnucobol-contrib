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
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  iosqfl01.
      * program for generate comp fields.
      * test case for gcsort.
      * file output fixed 
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external sqfl01
               organization is sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-01     comp-1.
          05 filler     pic x.
          05 msr-02     comp-1.
          05 filler     pic x.
          05 msr-03     comp-2.
          05 filler     pic x.
          05 msr-04     comp-2.
          05 filler     pic x.

       working-storage section.
       01    wk-llint   binary-double signed.
      *    
           copy wkenvfield.
      *    
       procedure division.
       begin.
      *  check if defined environment variables
           move 'sqfl01'  to env-pgm
           perform check-env-var
      *                
          open output masterseqfile.
	   prdi-00.
	      move all "|"             to masterseqrecord. 
		  move  333                to msr-01
          move -333                to msr-02
		  move -999999999          to msr-03
		  move  999999999          to msr-04
    	  write masterseqrecord.
	      move all "|"		       to masterseqrecord. 
		  move -333                to msr-01.
          move  333                to msr-02
		  move  999999999          to msr-03
		  move -999999999          to msr-04
    	  write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
      *       
           copy prenvfield2.
      *
