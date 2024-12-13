      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20241131
      * License
      *    Copyright 2024 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * Instruction use,sum fields
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. sbig001.
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
           copy finsqf01V.
      * foutsqf01.cpy
           copy foutsqf01V.
      * fsrtsqf01.cpy
           copy fsrtsqf01V.
      *
       working-storage section.
       01 ws-rec-length                  pic 9(5).
       77 fs-infile                      pic xx.
       77 fs-outfile                     pic xx.
       77 fs-sort                        pic xx.
      *  
           copy wktotsum01.
      *
      
      * ============================= *
       01  save-record-sort              pic x(90).
      * ============================= *
       77 record-counter-skip            pic 9(11) value zero.
       77 record-counter-in              pic 9(11) value zero.
       77 record-counter-out             pic 9(11) value zero.
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
           display " Sort on ascending  key    srt-ch-field "                 
           display "*===============================================* "
      *
           copy prenvfield1.
      *        
           sort file-sort
                on ascending  key    srt-ch-field 
                                     srt-bi-field 
                                     srt-fi-field 
                                     srt-fl-field 
                                     srt-pd-field 
                                     srt-zd-field                 
                   with duplicates in  order 
                    input procedure  is input-proc
                    output procedure is output-proc.
                    
           display "*===============================================* "
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
           perform inputrec-proc until fs-infile not equal "00"
           close sortin
           .
      *
      * ============================= *
        inputrec-proc.
      * ============================= *
           read sortin
           end-read
      **          display "read sortin - ws-rec-length = " ws-rec-length
           if fs-infile equal "00"
               perform release-record
           end-if
           .
      * ============================= *
       release-record.
      * ============================= *
           add 1 to record-counter-in
      ** filtering input record 
      **     display "release - ws-rec-length = " ws-rec-length
      **++     if (ws-rec-length = 90)
                move ws-rec-length to  in-lenrec
                release sort-data from infile-record
      **++     end-if
      **++     if (ws-rec-length = 65)
      **++          move ws-rec-length to in-lenrec
      **++          release sort-data-record-min02 from infile-record-min02
      **++     end-if
      **++     if (ws-rec-length = 40)
      **++          move ws-rec-length to in-lenrec
      **++          release sort-data-record-min01 from infile-record-min01
      **++     end-if
           .
      *
      * ============================= *
       output-proc.
      * ============================= *
           move zero to ws-rec-length
           open output sortout.
           perform outrec-proc-dett until fs-sort  
                   not equal "00".
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
           move srt-lenrec to ws-rec-length 
           if fs-sort equal "00"     
      **-->>         display "return -  ws-rec-length = "  ws-rec-length
               perform verify-record-out
           end-if
           .
      * ============================= *
       verify-record-out.     
      * ============================= *
      *
      * ## filtering data 
      *
      **++     if (ws-rec-length = 90)
      **         move sort-data to outfile-record
               
           move srt-seq-record   to  out-seq-record    
           move srt-ch-field     to  out-ch-field      
           move srt-bi-field     to  out-bi-field      
           move srt-fi-field     to  out-fi-field      
           move srt-fl-field     to  out-fl-field      
           move srt-pd-field     to  out-pd-field      
           move srt-zd-field     to  out-zd-field      
           move srt-fl-field-1   to  out-fl-field-1    
           move srt-clo-field    to  out-clo-field     
           move srt-cst-field    to  out-cst-field     
           move srt-csl-field    to  out-csl-field     
           move ch-filler        to  out-ch-filler     
                      
           write outfile-record 
      **++     end-if
      **++     if (ws-rec-length = 65)
      **++          move sort-data-record-min02 to outfile-record-min02
      **++          write outfile-record-min02
      **++     end-if
      **++     if (ws-rec-length = 40)
      **++          move sort-data-record-min01 to outfile-record-min01
      **++          write outfile-record-min01 
      **++     end-if            
      **++**     move sort-data        to outfile-record              
      **++**-->>     display "write - ws-rec-length = " ws-rec-length
      **++**     write outfile-record 
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
      *  copy   przerotot.cpy
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
      *  copy   prtotout.cpy
           copy   prtotout.
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
