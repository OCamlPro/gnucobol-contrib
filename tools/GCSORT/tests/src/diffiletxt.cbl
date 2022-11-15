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
       program-id. diffiletxt.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select sortcbl assign to external dd_incobol
                organization is line sequential
                access is sequential
                file status is fs-infile1.
      *sort input file2
           select sortgcs assign to external dd_ingcsort
                organization is line sequential
                access is sequential
                file status is fs-infile2.
       data division.
       file section.
       fd sortcbl.
       01 infile-record-cbl      pic x(100).                                            
       fd sortgcs.
       01 infile-record-gcs      pic x(100).                                                                                                
      *
       working-storage section.
       77 fs-infile1                 pic xx.
       77 fs-infile2                pic xx.
       77 fs-sort                   pic xx.
      *
      * ============================= *
       01  save-record-sort              pic x(38).
      * ============================= *
       01 bError                         pic 999  value zero.
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
           display " difftxt "
           display " Check file produced by Cobol Program and GCSORT "
           display "*===============================================* "
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

           open input sortgcs.
           if fs-infile2 not = "00"
                display "sortgcs file status error : " fs-infile2
                close sortcbl
                move 25 to RETURN-CODE
                stop run
           end-if
           
           perform view-data until  (fs-infile1 not equal "00"  and 
                                     fs-infile2 not equal "00" )or 
                                     bError     equal 1
           close sortcbl
           close sortgcs
           display "*===============================================* "
           if (bError = zero)
                display " Check OK  "
                move zero to return-code
           else
                display " Check KO  "
                move 25 to return-code
           end-if
           display "*===============================================* "
           display " Record input  cbl  : "  record-counter-incbl
           display " Record output gcs  : "  record-counter-ingcs
           display "*===============================================* "
           goback.
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
             display " Error diff - Environment variable " env-pgm
             display "              not found."
             display "*===============================================*"
             move 25 to RETURN-CODE
             goback
           end-if
           .
       90.
           exit.       
      *
      *
      * ============================= *
       view-data section.
      * ============================= *
       10.
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
           if (fs-infile1 = "00" and fs-infile1 = "00")
                perform check-rek
           end-if
           .
       90.
           exit.       
      *
      * ============================= *
       check-rek section.
      * ============================= *
       10.
           if (infile-record-cbl not = infile-record-gcs)
               move 1 to bError
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " cbl="    infile-record-cbl 
               display "  Record GCSORT num " record-counter-ingcs
               display " gcs="    infile-record-gcs
               display "============== # Error # ============== "
           end-if
           .
       90.
           exit.       

