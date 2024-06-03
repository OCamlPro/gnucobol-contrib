      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   COBOL module Difference file output.
      *            Check files result. 
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. diffidx.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
           SELECT sortcbl ASSIGN TO external dd_incobol
               COLLATING SEQUENCE OF msr-01 IS ASCII
               COLLATING SEQUENCE OF msr-99 IS EBCDIC
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS msr-01
               ALTERNATE RECORD KEY IS msr-99 WITH DUPLICATES
               file status is fs-infile1.                
      *sort input file2
           SELECT sortgcs ASSIGN TO external dd_ingcsort
               COLLATING SEQUENCE OF msr2-01 IS ASCII
               COLLATING SEQUENCE OF msr2-99 IS EBCDIC
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS msr2-01
               ALTERNATE RECORD KEY IS msr2-99 WITH DUPLICATES
               file status is fs-infile2.                
       data division.
       file section.
       fd sortcbl.
       01 infile-record-cbl.
          05 msr-01     pic x(10).
          05 msr-50     pic x(80).
          05 msr-99     pic x(10).
      *           
       fd sortgcs.
       01 infile-record-gcs.
          05 msr2-01     pic x(10).
          05 msr2-50     pic x(80).
          05 msr2-99     pic x(10).
      *
       working-storage section.
       77 fs-infile1                pic xx  value "00".
       77 fs-infile2                pic xx  value "00".
       77 fs-sort                   pic xx  value "00".
      *
      * ============================= *
       01  save-record-sort              pic x(38).
      * ============================= *
       01 bError                         pic 9    value zero.
       77 record-counter-incbl           pic 9(7) value zero.
       77 record-counter-ingcs           pic 9(7) value zero.
       77 bIsFirstTime                   pic 9    value zero.       
       77 bIsPending                     pic 9    value zero.       
       01 current-time.
           05 ct-hours      pic 99.
           05 ct-minutes    pic 99.
           05 ct-seconds    pic 99.
           05 ct-hundredths pic 99.       
      *
       77 env-pgm                       pic x(50).
       77 env-var-value                 pic x(1024).        
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display "*===============================================* "
           display " diffidx index file"
           display " Check file produced by Cobol Program and GCSORT "
           display "*===============================================* "

           display " Check Primary Key "

      *  check if defined : dd_incobol,   dd_ingcsort
           move 'dd_incobol'  to env-pgm
           perform check-env-var
           move 'dd_ingcsort' to env-pgm
           perform check-env-var
      *    
           open input sortcbl.
           if fs-infile1 not = "00"
                display "sortcbl file status error : " fs-infile1
                move 25 to RETURN-CODE
                stop run
           end-if
            move low-value to      msr-01
           start sortcbl
              key is greater than or equal to
                  msr-01
              invalid key
                  display
                      "bad start: " msr-01 
                      upon syserr
                  end-display
           end-start           

           open input sortgcs.
           if fs-infile2 not = "00"
                display "sortgcs file status error : " fs-infile2
                close sortcbl
                move 25 to RETURN-CODE
                stop run
           end-if
           move low-value to      msr2-01
           start sortgcs
              key is greater than or equal to
                  msr2-01
              invalid key
                  display
                      "bad start: " msr2-01 
                      upon syserr
                  end-display
           end-start           
           
           perform view-data until  (fs-infile1 not equal "00"  and 
                                     fs-infile2 not equal "00" ) or 
                                     bError     equal 1
           close sortcbl
           close sortgcs
           if (record-counter-incbl not equal record-counter-ingcs)
                    move 1 to bError
           end-if
                
           if (bError = zero)
                display " Check OK  "
                move zero to return-code
           else
                display " Check KO  "
                move 25 to return-code
                goback
           end-if
           
           display "*===============================================* "
           display " Primary Key "
           display " Record input  cbl  : "  record-counter-incbl
           display " Record output gcs  : "  record-counter-ingcs
           display "*===============================================* "           
           display "*===============================================* "

           move zero to record-counter-incbl, record-counter-ingcs
           display " Check Alternate Key "
           
           open input sortcbl.
           if fs-infile1 not = "00"
                display "sortcbl file status error : " fs-infile1
                move 25 to RETURN-CODE
                stop run
           end-if
           move low-value to      msr-99
           start sortcbl
              key is greater than or equal to
                  msr-99
              invalid key
                  display
                      "bad start: " msr-99 
                      upon syserr
                  end-display
           end-start           

           open input sortgcs.
           if fs-infile2 not = "00"
                display "sortgcs file status error : " fs-infile2
                close sortcbl
                move 25 to RETURN-CODE
                stop run
           end-if
           move low-value to      msr2-99
           start sortgcs
              key is greater than or equal to
                  msr2-99
              invalid key
                  display
                      "bad start: " msr2-99 
                      upon syserr
                  end-display
           end-start           
           
           perform view-data until  (fs-infile1 not equal "00"  and 
                                     fs-infile2 not equal "00" ) or 
                                     bError     equal 1
           close sortcbl
           close sortgcs
           
           if (record-counter-incbl not equal record-counter-ingcs)
                    move 1 to bError
           end-if
                
           if (bError = zero)
                display " Check OK  "
                move zero to return-code
           else
                display " Check KO  "
                move 25 to return-code
           end-if
           display "*===============================================* "
           display " Alternate Key "
           display " Record input  cbl  : "  record-counter-incbl
           display " Record output gcs  : "  record-counter-ingcs
           display "*===============================================* "
           goback
           .
      *
      * ============================= *
        check-env-var.
      * ============================= *
      *  
           accept env-var-value  from ENVIRONMENT env-pgm
      ** 
           if (env-var-value = SPACE)
             display "*===============================================*"
             display " Error diff - Environment variable " env-pgm
             display "              not found."
             display "*===============================================*"
             move 25 to RETURN-CODE
             goback
           end-if
           .
      *
      *
      * ============================= *
       view-data.
      * ============================= *
           if fs-infile1 = "00"
                read sortcbl at end display " End file sortcbl "
                end-read
           end-if
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
           end-if
           if fs-infile2 = "00"
                read sortgcs at end display " End file sortgcs "
                end-read
           end-if
           if fs-infile2 = "00"
                add 1 to record-counter-ingcs
           end-if
           if (fs-infile1 = "00" and fs-infile2 = "00")
                perform check-key
           end-if
           .
      *
      * ============================= *
       check-key.
      * ============================= *
      **      display "in1-seq-record    " in1-seq-record   
      **      display "in2-seq-record    " in2-seq-record   
           if msr-01 not = msr2-01   
                display "msr-01 not = msr2-01   "
           end-if       

           if msr-99 not = msr2-99   
                display "msr-99 not = msr2-9   "
           end-if       
      ** 
           if (msr-01 not = msr2-01    or
               msr-99 not = msr2-99)
               move 1 to bError
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display "  msr-01="    msr-01 
                       "  msr-50="    msr-50
                       "  msr-99="    msr-99    
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " msr2-01="    msr2-01 
                       " msr2-50="    msr2-50
                       " msr2-99="    msr2-99    
           end-if
           .
           end-of-pgm.
                exit.
                

