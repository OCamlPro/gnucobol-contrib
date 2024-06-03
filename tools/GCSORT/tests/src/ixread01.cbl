      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20240516
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL file variable
      *            For Sumfield
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  ixread01.
       environment division.
       input-output section.
       file-control.

           SELECT masterseqfile ASSIGN TO external inpix01
               COLLATING SEQUENCE OF msr-01 IS ASCII
               COLLATING SEQUENCE OF msr-99 IS EBCDIC
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS msr-01
               ALTERNATE RECORD KEY IS msr-99 WITH DUPLICATES
               file status is f-s-ix.
                              
       data division.
       file section.
       fd masterseqfile 
      *    record is varying in size 
      *       from 22 to 250 characters
      *          depending on recordsize
      *         recording mode is v.
          .
       01 masterseqrecord.
          05 msr-01     pic x(10).
          05 msr-50     pic x(80).
          05 msr-99     pic x(10).

       working-storage section.
000000**       01 recordsize			pic 9999.
       77 recordsize			pic s9(5) comp-3.
       77 prog   			    pic 9999 value zero.
      *
       77 env-pgm                       pic x(50).
       77 env-var-value                 pic x(1024).        
      *
       77 f-s-ix                pic xx.      
      *
       procedure division.
       begin-00.
      *  check if defined environment variables
          move 'inpix01'  to env-pgm
          perform check-env-var
      *   
          display "*=======================*"
          display "*  view primary msr-01  *"
          display "*=======================*"
          move space to f-s-ix 
          open input masterseqfile.
          if f-s-ix not = "00"
                go lb-50. 
          move low-value to      msr-01
          start masterseqfile
              key is greater than or equal to
                  msr-01
              invalid key
                  display
                      "bad start: " msr-01 
                      upon syserr
                  end-display
           end-start

          perform cycle-80 until 
                f-s-ix not = "00".
          display "*=======================*"
          display "* view alternate msr-99 *"
          display "*=======================*"
          close masterseqfile.
          open input masterseqfile.
          if f-s-ix not = "00"
                go lb-50. 
          move space to f-s-ix 
          move low-value to      msr-99
          start masterseqfile
              key is greater than or equal to
                  msr-99
              invalid key
                  display
                      "bad start: " msr-99 
                      upon syserr
                  end-display
           end-start           
           perform cycle-90 until 
                f-s-ix not = "00".
          go cycle-100.
       cycle-80.
		  read masterseqfile  next record
            at end display "end key ".
          if (f-s-ix = "00")
            display "Record    msr-01 "  msr-01 " "
                      " - msr-99 "  msr-99.
       cycle-90.
		  read masterseqfile  next record
                at end display " alternate key ".
          if (f-s-ix = "00")
             display "Record    msr-01 "  msr-01 " "
                      " - msr-99 "  msr-99.
       lb-50.  
          display "Error - f-s ixfile = " f-s-ix.
       cycle-100.
          close masterseqfile.
       end-proc.
          stop run.
      *       
      *
      * ============================= *
        check-env-var section.
      * ============================= *
      *  
       10.
           accept env-var-value  from ENVIRONMENT env-pgm
      ** 
           if (env-var-value = SPACE)
             display "*===============================================*"
             display " Error - Environment variable " env-pgm
             display "         not found."
             display "*===============================================*"
             move 25 to RETURN-CODE
             goback
           end-if
           .
       90.
           exit.       
      *
