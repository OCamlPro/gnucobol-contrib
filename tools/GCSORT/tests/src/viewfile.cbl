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
       77 record-counter-inocs           pic 9(7) value zero.
       77 bIsFirstTime                   pic 9    value zero.       
       77 bIsPending                     pic 9    value zero.       
       01 current-time.
           05 ct-hours      pic 99.
           05 ct-minutes    pic 99.
           05 ct-seconds    pic 99.
           05 ct-hundredths pic 99.       
       
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display " ********************************************** "
           display " view file produced "
           display " ********************************************** "
           
           open input sortcbl.
           if fs-infile1 not = "00"
                display "view file error file input fs = " fs-infile1
           end-if
           
           perform view-data until  fs-infile1 not equal "00" 
           close sortcbl
           display " ******************************************* "
           display "  Records  : "  record-counter-incbl
           display " ******************************************* "
           goback.
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
           display "============== ## ============== "
           display " sq="    in1-seq-record 
                   " ch="    in1-ch-field 
                   " bi="    in1-bi-field      
                   " fi="    in1-fi-field      
                   " pd="    in1-pd-field      
                   " zd="    in1-zd-field 
                   " fl="    in1-fl-field      
           display " clo="   in1-clo-field
                   " cst="   in1-cst-field      
                   " csl="   in1-csl-field      
                   " fl(1)=" in1-fl-field-1                         
           .
