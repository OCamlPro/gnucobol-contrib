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
       program-id. cnvfile.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select infile assign to external dd_infile
                organization is sequential
      ***          access is sequential
                file status is fs-infile1.
      *sort output file2
            select outfile assign to external dd_outfile
                organization is line sequential
      **         access is sequential
                file status is fs-infile2.
       data division.
       file section.
       fd infile.
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
       fd outfile.
       01 outfile-record-cbl.
           05 ou1-seq-record    pic  9(7).
           05 filler            pic  x.
           05 ou1-ch-field      pic  x(5).
           05 filler            pic  x.
           05 ou1-bi-field      pic  9(7).
           05 filler            pic  x.
           05 ou1-fi-field      pic s9(7).
           05 filler            pic  x.
           05 ou1-fl-field      pic s9(8).
           05 filler            pic  x.
           05 ou1-pd-field      pic s9(7).
           05 filler            pic  x.
           05 ou1-zd-field      pic s9(7).
           05 filler            pic  x.
           05 ou1-fl-field-1    pic s9(8).
           05 filler            pic  x.
           05 ou1-clo-field     pic s9(7) sign is leading.
           05 filler            pic  x.
           05 ou1-cst-field     pic s9(7) sign is trailing separate.
           05 filler            pic  x.
           05 ou1-csl-field     pic s9(7) sign is leading separate.
           05 filler            pic  x.
      **     05 ou1-ch-filler     pic x(25).
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
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display " ********************************************** "
           display " convert file produced "
           display " ********************************************** "
      *  check if defined environment variables
           move 'dd_infile'  to env-pgm
           perform check-env-var
           open input infile.
           if fs-infile1 not = "00"
                display "cnv file error file input fs = " fs-infile1
           end-if
      *                
      *  check if defined environment variables
           move 'dd_outfile'  to env-pgm
           perform check-env-var
      *                
           open output outfile.
           if fs-infile2 not = "00"
                display "cnv file error file output fs = " fs-infile2
           end-if
           
           
           perform cnv-data until  fs-infile1 not equal "00" 
           close infile
           close outfile
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
       cnv-data.
      * ============================= *
           read infile at end display " End file infile "
                end-read
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
                perform cnv-rec
           end-if
           .
      *
      * ============================= *
       cnv-rec.
      * ============================= *
           move all '|' to outfile-record-cbl
      **     display "============== ## ============== "
           move in1-seq-record   to ou1-seq-record 
           move in1-ch-field     to ou1-ch-field 
           move in1-bi-field     to ou1-bi-field    
           move in1-fi-field     to ou1-fi-field    
           move in1-pd-field     to ou1-pd-field    
           move in1-zd-field     to ou1-zd-field 
           move in1-fl-field     to ou1-fl-field    
           move in1-clo-field    to ou1-clo-field
           move in1-cst-field    to ou1-cst-field    
           move in1-csl-field    to ou1-csl-field    
           move in1-fl-field-1   to ou1-fl-field-1                       
           write outfile-record-cbl
           .
