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
       program-id.  iosqpd01c.
      * program for generate comp fields.
      * test case for ocsort.
      * file output fixed 
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqpd01c
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
       01 error-flag            pic 9.
       01 check-value           pic 9(32).
	   01 wk-tot.
          05 wrkmsr-03s    pic s9(3) comp.
          05 wrkmsr-03     pic  9(3) comp.
          05 wrkmsr-09s    pic s9(9) comp.
          05 wrkmsr-09     pic  9(9) comp.
          05 wrkmsr-18s    pic s9(18) comp.
          05 wrkmsr-18     pic  9(18) comp.

       procedure division.
       begin.
		  display "*====================*"
          display " iosqpd01c - start "
	      move zero to recordsize
		  move 58 to 	wrkmsr-03s, wrkmsr-03
						wrkmsr-09s, wrkmsr-09
						wrkmsr-18s, wrkmsr-18
          move recordsize  to wrkmsr-03s
		  move wrkmsr-18s  to recordsize
		  move zero        to error-flag.
          open input masterseqfile.
	   prdi-00.
          read masterseqfile at end go end-close.    

          if (msr-03s not equal zero) 
            display " error on msr-03  =    " msr-03s 
               move 2 to error-flag
                  go err-signed.
          if (msr-05s not equal zero) 
            display " error on msr-05s =    " msr-05s
               move 2 to error-flag
                go err-signed.
          if (msr-07s not equal zero) 
            display " error on msr-07s =    " msr-07s
               move 2 to error-flag
                go err-signed.
          if (msr-09s not equal zero) 
            display " error on msr-09s =    " msr-09s
               move 2 to error-flag
                go err-signed.
          if (msr-18s not equal zero)
            display " error on msr-18s =    " msr-18s
               move 2 to error-flag
                go err-signed.
          if (msr-31s not equal zero)
            display " error on msr-31s =    " msr-31s
               move 2 to error-flag
                go err-signed.
      *         
          multiply 333    by 2 giving check-value
          if (msr-03 not equal check-value)
            display " error on msr-03  =  " msr-03 
               move 1 to error-flag
                go err-signed.
          multiply 5555   by 2 giving check-value
          if (msr-05 not equal check-value)
            display " error on msr-05  =  " msr-05
               move 1 to error-flag
                go err-signed.
          multiply 77777   by 2 giving check-value
          if (msr-07 not equal check-value)
            display " error on msr-07  =  " msr-07
               move 1 to error-flag
                go err-signed.
          multiply 99999999   by 2 giving check-value
          if (msr-09 not equal check-value)
            display " error on msr-09  =  " msr-09
               move 1 to error-flag
                go err-signed.
          multiply 222222222222222222  by 2 giving check-value
          if (msr-18 not equal check-value)
            display " error on msr-18  =  " msr-18
               move 1 to error-flag
                go err-signed.
         multiply 444444444444444444444444444444  
               by 2 giving check-value
         if (msr-31 not equal check-value)
           display " error on msr-31  =  " msr-31
              move 1 to error-flag
               go err-signed.
          go prdi-00.
       err-signed.
      *   display "======== error ======= "
          display " check-value      =    " check-value
          if (error-flag = 1)
              display " error on field not signed"
          else
              display " error on field signed"
          end-if
          move 25 to return-code.
          go end-close.
       end-close.             
          close masterseqfile.
          if (error-flag = zero)
                display " iosqpd01c - check ok "
          else
                display " iosqpd01c - check ko "
          end-if
          display " iosqpd01c - end ".
		  display "*====================*".
       end-proc.
          stop run.
