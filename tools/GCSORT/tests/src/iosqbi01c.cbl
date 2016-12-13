      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Check output from COBOL program and OCsort data file
      *            For Sumfield
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  iosqbi01c.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to external sqbi01c
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
       01 error-flag            pic 9.
       01 check-value           pic 9(18).
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
          display " iosqbi01c - start "
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
            display " error on msr-03  =  " msr-03s 
               move 2 to error-flag
                  go err-signed.
          if (msr-05s not equal zero) 
            display " error on msr-05s =  " msr-05s
               move 2 to error-flag
                go err-signed.
          if (msr-07s not equal zero) 
            display " error on msr-07s =  " msr-07s
               move 2 to error-flag
                go err-signed.
          if (msr-09s not equal zero) 
            display " error on msr-09s =  " msr-09s
               move 2 to error-flag
                go err-signed.
          if (msr-11s not equal zero) 
            display " error on msr-11s =  " msr-11s
               move 2 to error-flag
                go err-signed.
          if (msr-13s not equal zero) 
            display " error on msr-13s =  " msr-13s
               move 2 to error-flag
                go err-signed.
          if (msr-15s not equal zero) 
            display " error on msr-15s =  " msr-15s
               move 2 to error-flag
                go err-signed.
          if (msr-17s not equal zero) 
            display " error on msr-17s =  " msr-17s
               move 2 to error-flag
                go err-signed.
          if (msr-18s not equal zero)
            display " error on msr-18s =  " msr-18s
               move 2 to error-flag
                go err-signed.
      *         
          multiply 333    by 2 giving check-value
          if (msr-03 not equal check-value)
            display " error on msr-03  =  " msr-03 
               move 1 to error-flag
                go err-signed.
          multiply 55555  by 2 giving check-value
          if (msr-05 not equal check-value)
            display " error on msr-05  =  " msr-05
               move 1 to error-flag
                go err-signed.
          multiply 7777777  by 2 giving check-value
          if (msr-07 not equal check-value)
            display " error on msr-07  =  " msr-07
               move 1 to error-flag
                go err-signed.
          multiply 999999999  by 2 giving check-value
          if (msr-09 not equal check-value)
            display " error on msr-09  =  " msr-09
               move 1 to error-flag
                go err-signed.
          multiply 44444444444  by 2 giving check-value
          if (msr-11 not equal check-value)
            display " error on msr-11  =  " msr-11
               move 1 to error-flag
                go err-signed.
          multiply 6666666666666  by 2 giving check-value
          if (msr-13 not equal check-value)
            display " error on msr-13  =  " msr-13
               move 1 to error-flag
                go err-signed.
          multiply 222222222222222  by 2 giving check-value
          if (msr-15 not equal check-value)
            display " error on msr-15  =  " msr-15
               move 1 to error-flag
                go err-signed.
          multiply 88888888888888888  by 2 giving check-value
          if (msr-17 not equal check-value)
            display " error on msr-17  =  " msr-17
               move 1 to error-flag
                go err-signed.
          multiply 222222222222222222  by 2 giving check-value
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
                display " iosqbi01c - check ok "
          else
                display " iosqbi01c - check ko "
          end-if
          display " iosqbi01c - end ".
		  display "*====================*".
       end-proc.
          stop run.
