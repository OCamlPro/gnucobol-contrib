      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20241131
      * License
      *    Copyright 2024 Sauro Menna
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
       program-id. diffile2V.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select sortcbl assign to external dd_incobol
                organization is sequential
                access is sequential
                file status is fs-infile1.
      *sort input file2
           select sortgcs assign to external dd_ingcsort
                organization is sequential
                access is sequential
                file status is fs-infile2.
       data division.
       file section.
       fd sortcbl
            record is varying in size
            from 42 to 95 characters depending on ws-rec-length.      
       01 infile-record-cbl.
           05 in1-lenrec         pic  9(4).
           05 in1-seq-record     pic  9(7).
           05 in1-ch-field       pic  x(5).
           05 in1-bi-field       pic  9(7) comp.
           05 in1-fi-field       pic s9(7) comp.
           05 in1-fl-field       comp-2.
           05 in1-pd-field       pic s9(7) comp-3.
           05 in1-zd-field       pic s9(7).
           05 in1-fl-field-1     COMP-1.
           05 in1-clo-field      pic s9(7) sign is leading.
           05 in1-cst-field      pic s9(7) sign is trailing separate.
           05 in1-csl-field      pic s9(7) sign is leading separate.
           05 in1-ch-filler      pic x(25).
       01 infile-record-min01    pic x(42).
       01 infile-record-min02    pic x(65).           
       
       fd sortgcs
            record is varying in size
            from 42 to 95 characters depending on ws-rec-length.
       01 infile-record-gcs.
           05 in2-lenrec         pic  9(4).
           05 in2-seq-record     pic  9(07).
           05 in2-ch-field       pic  x(5).
           05 in2-bi-field       pic  9(7) comp.
           05 in2-fi-field       pic s9(7) comp.
           05 in2-fl-field       comp-2.
           05 in2-pd-field       pic s9(7) comp-3.
           05 in2-zd-field       pic s9(7).
           05 in2-fl-field-1     COMP-1.
           05 in2-clo-field      pic s9(7) sign is leading.
           05 in2-cst-field      pic s9(7) sign is trailing separate.
           05 in2-csl-field      pic s9(7) sign is leading separate.
           05 in2-ch-filler      pic  x(25).
       01 infile2-record-min01   pic x(42).
       01 infile2-record-min02   pic x(65).             
      *
       working-storage section.
       01 ws-rec-length                  pic 9(5).
       77 fs-infile1                 pic xx.
       77 fs-infile2                pic xx.
       77 fs-sort                   pic xx.
      *
      * ============================= *
       01  save-record-sort              pic x(38).
      * ============================= *
       01 bError                         pic 999  value zero.
       77 record-counter-incbl           pic 9(9) value zero.
       77 record-counter-ingcs           pic 9(9) value zero.
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
           display " diffile2V "
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
           move zero to bError
           perform view-data until  (fs-infile1 not equal "00"  and 
                                     fs-infile2 not equal "00" ) or 
                                      bError     > 15
           close sortcbl
           close sortgcs
           display "*===============================================* "
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
            move low-value to infile-record-cbl
            move low-value to infile-record-gcs
           if fs-infile1 = "00"
               read sortcbl at end 
                display " End file sortcbl fs " fs-infile1
                    end-read
           end-if
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
           end-if
           if fs-infile2 = "00"
              read sortgcs at end 
                display " End file sortgcs fs " fs-infile2
                end-read
           end-if
           if fs-infile2 = "00"
                add 1 to record-counter-ingcs
           end-if
           if (fs-infile1 = "00" and fs-infile2 = "00")
      **          perform check-key
test00            perform check-key-dett
           end-if
           .
       90.
           exit.       
      *
      * ============================= *
       check-key section.
      * ============================= *
       10.
      **     move zero to bError
           
           if (in1-lenrec not = in2-lenrec) or
              (in1-ch-field   not = in2-ch-field   or
               in1-bi-field   not = in2-bi-field   or
               in1-fi-field   not = in2-fi-field   or
               in1-pd-field   not = in2-pd-field   or
               in1-zd-field   not = in2-zd-field   or
               in1-fl-field   not = in2-fl-field   or
               in1-fl-field-1 not = in2-fl-field-1 or
               in1-clo-field  not = in2-clo-field  or               
               in1-cst-field  not = in2-cst-field  or 
               in1-csl-field  not = in2-csl-field )
      
               add 1 to bError
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " sq="    in1-seq-record 
                       " ch="    in1-ch-field 
                       " bi="    in1-bi-field      
                       " fi="    in1-fi-field      
                       " pd="    in1-pd-field      
                       " zd="    in1-zd-field 
                       " fl(2)=" in1-fl-field      
               display "  Record GCSORT num " record-counter-ingcs
               display " sq="    in2-seq-record 
                       " ch="    in2-ch-field 
                       " bi="    in2-bi-field      
                       " fi="    in2-fi-field      
                       " pd="    in2-pd-field      
                       " zd="    in2-zd-field 
                       " fl(2)=" in2-fl-field      
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " clo="   in1-clo-field
                       " cst="   in1-cst-field      
                       " csl="   in1-csl-field      
                       " fl(1)=" in1-fl-field-1                         
               display "  Record GCSORT num " record-counter-ingcs
               display " clo="   in2-clo-field
                       " cst="   in2-cst-field      
                       " csl="   in2-csl-field      
                       " fl(1)=" in2-fl-field-1                         
           end-if
           .
       90.
           exit.       
      * ============================= *
       check-key-dett section.
      * ============================= *
       10.
      **     move zero to bError
      **     if (
           if in1-ch-field not = in2-ch-field   
            add 1 to bError.
           if  in1-bi-field not = in2-bi-field   
            add 1 to bError.
           if  in1-fi-field not = in2-fi-field   
            add 1 to bError.
           if  in1-pd-field not = in2-pd-field   
            add 1 to bError.
           if  in1-zd-field not = in2-zd-field   
            add 1 to bError.

           if ((ws-rec-length >  42)  and
               (ws-rec-length <= 61))
               if  in1-fl-field not = in2-fl-field   
                add 1 to bError
               end-if
                 if  in1-fl-field-1 not = in2-fl-field-1 
                add 1 to bError
               end-if
               if  in1-clo-field not = in2-clo-field                
                  add 1 to bError
               end-if
               if  in1-cst-field not = in2-cst-field  
                  add 1 to bError
               end-if
           end-if
           if ((ws-rec-length >  61)  and
               (in1-csl-field not = in2-csl-field ))
                  add 1 to bError
           end-if
           
           if bError > 0
               display " error type  " bError
               display " record len: " ws-rec-length
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " sq="    in1-seq-record 
                       " ch="    in1-ch-field 
                       " bi="    in1-bi-field      
                       " fi="    in1-fi-field      
                       " pd="    in1-pd-field      
                       " zd="    in1-zd-field 
                       " fl(2)=" in1-fl-field      
               display "  Record GCSORT num " record-counter-ingcs
               display " sq="    in2-seq-record 
                       " ch="    in2-ch-field 
                       " bi="    in2-bi-field      
                       " fi="    in2-fi-field      
                       " pd="    in2-pd-field      
                       " zd="    in2-zd-field 
                       " fl(2)=" in2-fl-field      
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display " clo="   in1-clo-field
                       " cst="   in1-cst-field      
                       " csl="   in1-csl-field      
                       " fl(1)=" in1-fl-field-1                         
               display "  Record GCSORT num " record-counter-ingcs
               display " clo="   in2-clo-field
                       " cst="   in2-cst-field      
                       " csl="   in2-csl-field      
                       " fl(1)=" in2-fl-field-1                         
           end-if
           .
       90.
           exit.       

