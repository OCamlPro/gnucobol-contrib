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
       program-id.  iosqfi03c.
      * program for generate comp fields.
      * test case for ocsort.
      * file output fixed 
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqfi03c
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
          display " iosqfi03c - start "
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

          if (msr-02s not equal zero) 
            display " error on msr-02s =  " msr-02s 
               move 2 to error-flag
                  go err-signed.
          if (msr-04s not equal zero) 
            display " error on msr-04s =  " msr-04s
               move 2 to error-flag
                go err-signed.
          if (msr-06s not equal zero) 
            display " error on msr-06s =  " msr-06s
               move 2 to error-flag
                go err-signed.
          if (msr-08s not equal zero) 
            display " error on msr-08s =  " msr-08s
               move 2 to error-flag
                go err-signed.
          if (msr-14s not equal zero) 
            display " error on msr-14s =  " msr-14s
               move 2 to error-flag
                go err-signed.
          if (msr-16s not equal zero) 
            display " error on msr-16s =  " msr-16s
               move 2 to error-flag
                go err-signed.
          if (msr-18s not equal zero) 
            display " error on msr-18s =  " msr-18s
               move 2 to error-flag
                go err-signed.
      *         
          multiply 33     by 2 giving check-value
          if (msr-02 not equal check-value)
            display " error on msr-02  =  " msr-02 
               move 1 to error-flag
                go err-signed.
          multiply 5555   by 2 giving check-value
          if (msr-04 not equal check-value)
            display " error on msr-04  =  " msr-04
               move 1 to error-flag
                go err-signed.
          multiply 777777  by 2 giving check-value
          if (msr-06 not equal check-value)
            display " error on msr-06  =  " msr-06
               move 1 to error-flag
                go err-signed.
          multiply 99999999  by 2 giving check-value
          if (msr-08 not equal check-value)
            display " error on msr-06  =  " msr-08
               move 1 to error-flag
                go err-signed.
          multiply 141414141414  by 2 giving check-value
          if (msr-14 not equal check-value)
            display " error on msr-14  =  " msr-14
               move 1 to error-flag
                go err-signed.
          multiply 2222222222222222  by 2 giving check-value
          if (msr-16 not equal check-value)
            display " error on msr-16  =  " msr-16
               move 1 to error-flag
                go err-signed.
          multiply 444444444444444444  by 2 giving check-value
          if (msr-18 not equal check-value)
            display " error on msr-18  =  " msr-18
               move 1 to error-flag
                go err-signed.
          go prdi-00.
       err-signed.
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
                display " iosqfi03c - check ok "
          else
                display " iosqfi03c - check ko "
          end-if
          display " iosqfi03c - end ".
		  display "*====================*".
       end-proc.
          stop run.
