      *-------------------------------------------------------------------------------*
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   View file 2
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. cnvfile2.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      * input file1
            select sortcbl assign to external dd_incobol
                organization is sequential
                access is sequential
                file status is fs-infile1.
      * input file2
            select outcbl assign to external dd_outcobol
                organization is line sequential
      *         access is sequential
                file status is fs-infile2.
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
       fd outcbl.
       01 outfile-record-cbl.
      *** SORT FIELDS=(8,5,CH,A,13,3,BI,A,16,4,FI,A,20,8,FL,A,28,4,PD,A,32,7,ZD,A) 
      * pos  1 len 7
           05 ou1-seq-record    pic  9(07).
           05 filler            pic x.
      * pos  9 len 5
           05 ou1-ch-field      pic  x(5).
           05 filler            pic x.
      * pos 15 len 7
           05 ou1-bi-field      pic  9(7).
           05 filler            pic x.
      * pos 23 len 7
           05 ou1-fi-field      pic 9(7).
           05 filler            pic x.
      * pos 31 len 9
           05 ou1-fl-field      pic  9(09).
           05 filler            pic x.
      * pos 41 len 7
           05 ou1-pd-field      pic 9(7).
           05 filler            pic x.
      * pos 49 len 8
           05 ou1-zd-field      pic s9(7) sign is leading.
           05 filler            pic x.
      * pos 58 len 9
           05 ou1-fl-field-1    pic  9(09).
           05 filler            pic x.
      * pos 68 len 8
           05 ou1-clo-field     pic s9(7) sign is leading.
           05 filler            pic x.
      * pos 77 len 8
           05 ou1-cst-field     pic S9(7) sign is trailing separate.
           05 filler            pic x.
      * pos 86 len 8
           05 ou1-csl-field     pic s9(7) sign is leading separate.
           05 filler            pic x.
           05 ou1-ch-filler     pic  x(25).
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
       77 record-counter-incbl           pic 9(11) value zero.
       77 record-counter-ingcs           pic 9(11) value zero.
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
           display " ************************************************* "
           display " convert COBOL sequential file to line sequential  "
           display " ************************************************* "
      *  check if defined environment variables
           move 'dd_incobol'  to env-pgm
           perform check-env-var
      *                
           move 'dd_outcobol'  to env-pgm
           perform check-env-var
      *                
           
           open input sortcbl.
           if fs-infile1 NOT equal "00"
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           open output outcbl.
           if fs-infile2 NOT equal "00"
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           
           perform cnv-data until  fs-infile1 not equal "00" or
                                   fs-infile2 not equal "00" 
           close sortcbl
           close outcbl
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
           read sortcbl at end display " End file "
                end-read
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
                perform conv-rec
           end-if
           .
      *
      * ============================= *
       conv-rec     section.
      * ============================= *
       cnv-00.
           move all "|"         to outfile-record-cbl
           move in1-seq-record  to ou1-seq-record 
           move in1-ch-field    to ou1-ch-field   
           move in1-bi-field    to ou1-bi-field   
           move in1-fi-field    to ou1-fi-field   
           move in1-pd-field    to ou1-pd-field   
           move in1-zd-field    to ou1-zd-field   
           move in1-fl-field    to ou1-fl-field   
           move in1-clo-field   to ou1-clo-field  
           move in1-cst-field   to ou1-cst-field  
           move in1-csl-field   to ou1-csl-field  
           move in1-fl-field-1  to ou1-fl-field-1 
           move all "+"         to ou1-ch-filler  
           write outfile-record-cbl
           if fs-infile2 not = "00"
                display "*cnvfile2* write error fs="
                        fs-infile2
                display " Record Area "
                outfile-record-cbl
                goback
           end-if
           .
       cnv-90.
           exit.
