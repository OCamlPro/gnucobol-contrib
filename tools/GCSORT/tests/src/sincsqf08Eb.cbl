      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * Instruction INCLUDE, OPTION
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. sincsqf08b.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file
      * sinsqf01.cpy
           copy  sinsqf01.
      *sort output file
      * soutsqf01.cpy
           copy soutsqf01.
      *sort file (sd)
      * ssrtsqf01.cpy
           copy ssrtsqf01.
       data division.
       file section.
      * finsqf01.cpy
           copy finsqf01.
      * foutsqf01.cpy
           copy foutsqf01.
      * fsrtsqf01.cpy
           copy fsrtsqf01.
      *
       working-storage section.
      *
       77   record-skipped          pic 9(5)   value  5.    
       77   record-stopaft          pic 9(5)   value 15.
       77   wk-skipped              pic 9(5)   value zero.    
       77   wk-stopaft              pic 9(5)   value zero.
    
      *
       77 fs-infile                      pic xx.
       77 fs-outfile                     pic xx.
       77 fs-sort                        pic xx.
      *  
      *  
           copy wktotsum01.
      *
      * ============================= *
       01  save-record-sort              pic x(90).
      * ============================= *
       77 record-counter-in              pic 9(7) value zero.
       77 record-counter-out             pic 9(7) value zero.
       77 bIsFirstTime                   pic 9    value zero.       
       77 bIsPending                     pic 9    value zero.       
       01 current-time.
           05 ct-hours                   pic 99.
           05 ct-minutes                 pic 99.
           05 ct-seconds                 pic 99.
           05 ct-hundredths              pic 99.       
      *    
           copy wkenvfield.
      *    
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display "*===============================================* "
           display " Sort on ascending  key    srt-ch-field "                 ## on descending key    <modify key>               
           display "*===============================================* "
      *
           copy prenvfield1.
      *        
           sort file-sort
                on ascending  key    srt-ch-field                          ## on descending key    <modify key>    
                   with duplicates in  order                               ## DUPLICATES
                    input procedure  is input-proc
                    output procedure is output-proc.
                    
           display "*===============================================* "
           display " Skip prec     : "  record-skipped.
           display " Stop after    : "  record-stopaft.
           display " Record input  : "  record-counter-in
           display " Record output : "  record-counter-out
           display "*===============================================* "
           goback
           .
      *       
           copy prenvfield2.
      *
      *
      * ============================= *
       input-proc.
      * ============================= *
           open input sortin.
           if fs-infile NOT equal "00"
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           move zero to record-counter-in
           perform inputrec-proc until fs-infile not equal "00"
           close sortin
           .
      *
      * ============================= *
        inputrec-proc.
      * ============================= *
           read sortin
           end-read
           add 1 to record-counter-in
           add 1 to wk-skipped
           if (fs-infile equal "00")   
              if (record-counter-in > record-stopaft)
                move "10" to fs-infile
              else
                 if (record-counter-in > record-skipped)
                    perform release-record
                 end-if
              end-if
           end-if
           .
      * ============================= *
       release-record.
      * ============================= *
           
      ** filtering input record 
      ** test      if (in-ch-field(1:2) = "GG")                                   ## filtering data    
      **-->>    if (wk-stopaft < record-stopaft)
          
      **debug      display "in-ch-field       = " in-ch-field
      **debug      display "record-counter-in = " record-counter-in
             if ((in-ch-field(1:2) > "GG")  AND                                 ## filtering data    
              (in-bi-field > 10)          AND
              (in-fi-field < 40)          AND
              (in-fl-field > 10)          AND
              (in-pd-field > 10)          AND
              (in-zd-field < 40))
                 release sort-data from infile-record             
              end-if
           add 1 to wk-stopaft
           .
      *
      * ============================= *
       output-proc.
      * ============================= *
           open output sortout.
           if fs-sort NOT equal "00"
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           perform outrec-proc-dett until fs-sort  
                   not equal "00"                
           if (bIsPending = 1)
              perform write-record-out
           end-if
           close sortout.
      *
      * ============================= *
       outrec-proc-dett.
      * ============================= *
      *
           return file-sort at end 
                display " "
                end-return
           if fs-sort equal "00"     
               perform verify-record-out
           end-if
           .
      * ============================= *
       verify-record-out.     
      * ============================= *
      *
      * ## filtering data 
      *
      * ## NO filtering data 
           move sort-data        to outfile-record              
           write outfile-record 
           add 1 to record-counter-out
           .

      * ============================= *
       add-totalizer.
      * ============================= *
      * Sum all Fields  
      *  copy   prsrttot.cpy
           copy  praddsrttot.
           move 1            to bIsPending
           .
      * ============================= *
       reset-totalizer.    
      * ============================= *
           copy   przerotot.
           .
      * ============================= *
      * reset totals
      * ============================= *
       write-record-out.
      * ============================= *
           move low-value           to outfile-record
           add  1                   to record-counter-out
           move save-record-sort    to outfile-record
           move zero                to bIsPending
           write outfile-record 
           .
      * ============================= *
       view-data.
      * ============================= *
           read sortout at end 
                display " "
           end-read
           if fs-outfile equal "00"
                   display "============== ## ============== "
                   display " sq="   out-seq-record 
                           " ch="   out-ch-field 
                           " bi="   out-bi-field      
                           " fi="   out-fi-field      
                           " pd="   out-pd-field      
                           " zd="   out-zd-field 
                           " fl="   out-fl-field      
           end-if
           .
