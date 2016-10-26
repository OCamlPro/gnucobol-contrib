      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Check output from COBOL program and OCsort data file
      *            For Sumfield
      *            Sort/Merge COBOL Program and OCSort data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
      	   identification division.
       program-id.  iosqfl01c.
      * program for generate comp fields.
      * test case for ocsort.
      * file output fixed 
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqfl01c
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
       01 recordsize			pic 9999.
       01 error-flag            pic 9.
       01 check-value           pic 9(18).
	   01 wk-tot.
          05 wrkmsr-02s    pic s9(3) comp.
          05 wrkmsr-02     pic  9(3) comp.
          05 wrkmsr-10s    pic s9(9) comp.
          05 wrkmsr-10     pic  9(9) comp.
          05 wrkmsr-18s    pic s9(18) comp.
          05 wrkmsr-18     pic  9(18) comp.

       procedure division.
       begin.
		  display "*====================*"
          display " iosqfl01c - start "
	      move zero to recordsize
		  move 58 to 	wrkmsr-02s, wrkmsr-02
						wrkmsr-10s, wrkmsr-10
						wrkmsr-18s, wrkmsr-18
          move recordsize  to wrkmsr-02s
		  move wrkmsr-18s  to recordsize
		  move zero        to error-flag.
          open input masterseqfile.
	   prdi-00.
          read masterseqfile at end go end-close.    

          if (msr-01 not equal zero) 
            display " error on msr-01  =  " msr-01 
               move 2 to error-flag
                  go err-signed.
          if (msr-02 not equal zero) 
            display " error on msr-02 =  " msr-02
               move 2 to error-flag
                go err-signed.
          if (msr-03 not equal zero) 
            display " error on msr-03 =  " msr-03
               move 2 to error-flag
                go err-signed.
          if (msr-04 not equal zero) 
            display " error on msr-04 =  " msr-04
               move 2 to error-flag
                go err-signed.
      *         
          go prdi-00.
       err-signed.
      *   display "======== error ======= "
          display " error on field not zero "
          move 25 to return-code.
          go end-close.
       end-close.             
          close masterseqfile.
          if (error-flag = zero)
                display " iosqfl01c - check ok "
          else
                display " iosqfl01c - check ko "
          end-if
          display " iosqfl01c - end ".
		  display "*====================*".
       end-proc.
          stop run.
