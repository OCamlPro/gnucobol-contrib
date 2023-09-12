      *-------------------------------------------------------------------------------*
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   View file 
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. viewfile.
       environment division.
       configuration section.
       special-names.
           ALPHABET    case-ascii      IS  ASCII
           ALPHABET    case-ebcdic     IS  EBCDIC.      
        repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select sortcbl assign to external dd_incobol
                organization is sequential
                access is sequential
                file status is fs-infile1.
       data division.
       file section.
       fd sortcbl.
       01 infile-record-cbl.
           05 in1-seq-record    pic  9(07).
           05 in1-ch-field      pic  x(5).
           05 in1-bi-field      pic  9(7) comp.
           05 in1-fi-field      pic s9(7) comp.
           05 in1-fl-field      comp-2.
           05 in1-pd-field      pic s9(7) comp-3.
           05 in1-zd-field      pic s9(7).
           05 in1-fl-field-1    comp-1.
           05 in1-clo-field     pic s9(7) sign is leading.
           05 in1-cst-field     pic s9(7) sign is trailing separate.
           05 in1-csl-field     pic s9(7) sign is leading separate.
           05 in1-ch-filler     pic  x(25).
      *
       working-storage section.
       77 fs-infile1                 pic xx.
       77 fs-infile2                pic xx.
       77 fs-sort                   pic xx.
      *
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
      *    
       01 wk-infile-record.
           05 wk-in-seq-record   pic  9(07).
           05 wk-in-ch-field     pic  x(5).
           05 wk-in-bi-field     pic  9(7) comp.
           05 wk-in-fi-field     pic s9(7) comp.
           05 wk-in-fl-field     comp-2.
           05 wk-in-pd-field     pic s9(7) comp-3.
           05 wk-in-zd-field     pic s9(7).
           05 wk-in-fl-field-1   comp-1.
           05 wk-in-clo-field    pic s9(7) sign is leading.
           05 wk-in-cst-field    pic s9(7) sign is trailing separate.
           05 wk-in-csl-field    pic s9(7) sign is leading separate.
           05 wk-in-ch-filler    pic  x(25).
      *      
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display " ********************************************** "
           display " view file produced "
           display " ********************************************** "
      *  check if defined environment variables
           move 'dd_incobol'  to env-pgm
           perform check-env-var
      *                
           
           open input sortcbl.
           if fs-infile1 not = "00"
                display "view file error file input fs = " fs-infile1
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           
           perform view-data until  fs-infile1 not equal "00" 
           close sortcbl
           display " ******************************************* "
           display "  Records  : "  record-counter-incbl
           display " ******************************************* "
           goback.
      *
      * ============================= *
        check-env-var.
      * ============================= *
      *  
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
      *
      *
      * ============================= *
       view-data.
      * ============================= *
           read sortcbl at end display " End file sortcbl "
                end-read
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
                perform view-rec
           end-if
           .
      *
      * ============================= *
       view-rec.
      * ============================= *
           move infile-record-cbl to wk-infile-record
           TRANSFORM wk-in-seq-record FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-ch-field   FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-zd-field   FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-clo-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-cst-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-csl-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-ch-filler  FROM case-ebcdic TO case-ascii 
           display "============== ## ============== "
           display " sq="    wk-in-seq-record      
                   " ch="    wk-in-ch-field        
                   " bi="       in1-bi-field       
                   " fi="       in1-fi-field       
                   " fl="       in1-fl-field       
                   " pd="       in1-fl-field       
                   " zd="    wk-in-zd-field        
                   " fl(1)="    in1-fl-field-1     
           display " clo="   wk-in-clo-field       
                   " cst="   wk-in-cst-field       
                   " csl="   wk-in-csl-field       
           .                                       
