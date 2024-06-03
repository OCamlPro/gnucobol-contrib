      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
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
       program-id.  ixwrite.
       environment division.
       input-output section.
       file-control.
             select infile assign to  external infile
                 organization is line sequential
                 file status is f-s.
                 
     **        alternate record key is msr-03
     **        alternate record key is msr-04 with duplicates
     **        alternate record key is msr-05 with duplicates
      *        .
           SELECT masterseqfile ASSIGN TO external inpix01
               COLLATING SEQUENCE OF msr-01 IS ASCII
               COLLATING SEQUENCE OF msr-99 IS EBCDIC
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS msr-01
               ALTERNATE RECORD KEY IS msr-99 WITH DUPLICATES   
                file status is f-s-ix
              .
       data division.
       file section.
       fd infile.
       01   rekin.
           05 f01             pic x(10).
           05 f02             pic x(80).
           05 f03             pic x(10).
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
       77  f-s                  pic xx.      
       77  f-s-ix               pic xx.      
      *    
       procedure division.
       begin-00.
      *  check if defined environment variables
           move 'infile'  to env-pgm
          perform check-env-var
      *        
          move 'inpix01'  to env-pgm
          perform check-env-var
      *           
          open input  infile
          open output masterseqfile.
          perform cycle-00 thru cycle-01 
                until f-s not = "00".
          go cycle-50.
       cycle-00.
          read infile.
          if f-s = "00"
              move space      to masterseqrecord
              move f01        to msr-01
              move f03        to msr-99
              write  masterseqrecord invalid key go to lb-50
          end-if.
       cycle-01.
       cycle-50.
          close masterseqfile.
          close infile
          open input masterseqfile.
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
          perform cycle-80 
                until f-s not = "00"          
          display "*=======================*"
          display "*     view alternate    *"
          display "*=======================*"
          close masterseqfile.
          open input masterseqfile.
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
          perform cycle-90 
                until f-s not = "00" 
          go cycle-100.
       cycle-80.
		  read masterseqfile
                at end go to cycle-100.
          display "Record    msr-01 "  msr-01 " "
                      " - msr-99 "  msr-99.
       cycle-90.
		  read masterseqfile key is msr-99
                at end go to cycle-100.
          display "Record    msr-01 "  msr-01 " "
                      " - msr-99 "  msr-99.
       lb-50.  
          close infile.
          display "Error - f-s infile = " f-s.
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
