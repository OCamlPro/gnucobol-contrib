      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Merge COBOL module
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. musesqf03b.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *merge input file1
      * copy smrgsqf01.cpy
            copy smrgsqf01.
      *merge input file2
      * copy smrgsqf02.cpy
            copy smrgsqf02.
      *merge input file3
      * copy smrgsqf03.cpy
            copy smrgsqf03.
      *merge output file
      * copy smrgoutsqf01.cpy
            copy smrgoutsqf01.
      *merge file (sd)
      * copy smrgwrksqf01.cpy
            copy smrgwrksqf01.
       data division.
       file section.
      * copy fmrgsqf01.cpy
           copy fmrgsqf01.
      * copy fmrgsqf02.cpy
           copy fmrgsqf02.
      * copy fmrgsqf03.cpy
           copy fmrgsqf03.
      * copy fmrgsqfout.cpy
           copy fmrgsqfout.
      * copy fmrgsqfmrg.cpy
           copy fmrgsqfmrg.
      *
       working-storage section.
       77 fs-infile1                pic xx.
       77 fs-infile2                pic xx.
       77 fs-infile3                pic xx.
       77 fs-outfile                pic xx.
       77 fs-merge                  pic xx.
      *
      *
           copy wktotsum01.
      *
      * ============================= *
       01  save-record-merge             pic x(90).
      * ============================= *
       77 record-counter-in              pic 9(7) value zero.
       77 record-counter-out             pic 9(7) value zero.
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
       master-merge.
           display "*===============================================* "
           display " Merge on ascending  key    srt-ch-field "                 ## on descending key    <modify key>               
           display "*===============================================* "
           
           merge file-merge
               on ascending  key     srt-ch-field                         ## on descending key    <modify key>    
               using mergein1 mergein2 mergein3   
                   output procedure is output-proc
                    
           display "*===============================================* "
           display " Record output : "  record-counter-out
           display "*===============================================* "
           goback
           .
      *
      * ============================= *
       output-proc.
      * ============================= *
           open output mergeout.
           perform outrec-proc-dett until fs-merge  
                   not equal "00".
           if (bIsPending = 1)
              perform write-record-out
           end-if
           close mergeout.
      *
      * ============================= *
       outrec-proc-dett.
      * ============================= *
      *
           return file-merge at end 
                display " "
                end-return
           if fs-merge equal "00"     
               perform verify-record-out
           end-if
           .
      * ============================= *
       verify-record-out.     
      * ============================= *
      *
            move srt-ch-field        to key-curr-ch-field                  ## on descending key    <modify key>      
           if (bIsFirstTime = 0)
               perform reset-totalizer
               move zero             to bIsPending
               move 1                to bIsFirstTime 
               move srt-ch-field     to key-prec-ch-field                  ## on descending key    <modify key>     
               move merge-data       to save-record-merge              
           end-if
           if (key-prec-ch-field = key-curr-ch-field)
               move 1                to bIsPending
           else
               perform write-record-out
               move merge-data          to save-record-merge              
               move key-curr-ch-field   to key-prec-ch-field
               move merge-data          to outfile-record              
           end-if
           .

      * ============================= *
       write-record-out.
      * ============================= *
           move low-value          to outfile-record
           add 1 to record-counter-out
           move save-record-merge   to outfile-record
           move zero         to bIsPending
           write outfile-record 
           move key-curr-ch-field   to key-prec-ch-field
           .
           
      * ============================= *
       view-data.
      * ============================= *
           read mergeout at end 
                display " "
           end-read
           if fs-outfile equal "00"
                   display "============== ## ============== "
                   display " sq="   out-seq-record 
                           " ch="   out-ch-field (1:2)          
                           " bi="   out-bi-field      
                           " fi="   out-fi-field      
                           " pd="   out-pd-field      
                           " zd="   out-zd-field 
                           " fl="   out-fl-field      
           end-if.
      * ============================= *
       reset-totalizer.    
      * ============================= *
      *   copy przerotot.cpy
           copy przerotot.
           .
