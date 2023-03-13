      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * Instruction INCLUDE , SUM FIELD = NOME
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. susesqf16b.
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
       77 fs-infile                      pic xx.
       77 fs-outfile                     pic xx.
       77 fs-sort                        pic xx.
      *  
           copy wktotsum01.
      *    
      * ============================= *
       01  save-record-sort              pic x(90).
      * ============================= *
       77 record-counter-in              pic 9(7) value zero.
       77 record-counter-out             pic 9(7) value zero.
       77 skiprec                        pic 9(7) value zero.
       77 stopaft                        pic 9(7) value zero.
       77 bIsFirstTime                   pic 9    value zero.       
       77 bIsPending                     pic 9    value zero.       
       01 current-time.
           05 ct-hours                   pic 99.
           05 ct-minutes                 pic 99.
           05 ct-seconds                 pic 99.
           05 ct-hundredths              pic 99.       
      *
       77 env-pgm                       pic x(50).
       77 env-var-value                 pic x(1024).        
      *
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display "*===============================================* "
           display " Sort on ascending  key    srt-ch-field "                 ## on descending key    <modify key>               
           display "*===============================================* "
      *  check if defined environment variables
           move 'dd_infile'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_outfile'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_sortwork'  to env-pgm
           perform check-env-var
           
           move   5       to  skiprec 
           move  15       to  stopaft 
           
           sort file-sort
                on ascending  key    srt-ch-field                          ## on descending key    <modify key>    
                    input procedure  is input-proc
                    output procedure is output-proc.
                    
           display "*===============================================* "
           display " OPTION SKIPREC: "  skiprec
           display " OPTION STOPAFT: "  stopaft
           display " Record input  : "  record-counter-in
           display " Record output : "  record-counter-out
           display "*===============================================* "
           goback
           .
      *
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
      * ============================= *
       input-proc.
      * ============================= *
           open input sortin.
           if fs-infile NOT equal "00"
                MOVE 25 TO RETURN-CODE
                GOBACK
           end-if
           perform inputrec-proc until fs-infile not equal "00"
           close sortin
           .
      *
      *
      * ============================= *
        inputrec-proc.
      * ============================= *
           read sortin
           end-read
           add 1 to record-counter-in
           if (fs-infile equal "00")   
              if (record-counter-in > stopaft)
                move "10" to fs-infile
              else
                 if (record-counter-in > skiprec)
                    perform release-record
                 end-if
              end-if
           end-if
           .
      *** ============================= *
      **  inputrec-proc.
      *** ============================= *
      **     read sortin
      **     end-read
      **     if fs-infile equal "00" 
      **         perform release-record  
      **     end-if
      **     .
      *** ============================= *
       release-record.
      * ============================= *
      *****     add 1 to record-counter-in
           if (record-counter-in > skiprec)
      ** filtering input record 
               if ((in-ch-field(1:2) > "GG")  AND                                 ## filtering data    
                   (in-bi-field > 10)         AND
                   (in-fi-field < 40)         AND
                   (in-fl-field > 10)         AND
                   (in-pd-field > 10)         AND
                   (in-zd-field < 40))
                        release sort-data from infile-record
               end-if
           end-if
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
           move srt-ch-field        to key-curr-ch-field                  ## on descending key    <modify key>      
           if (bIsFirstTime = 0)
               perform reset-totalizer
               move zero             to bIsPending
               move 1                to bIsFirstTime 
               move srt-ch-field     to key-prec-ch-field                  ## on descending key    <modify key>     
               move sort-data        to save-record-sort              
           end-if
           if (key-prec-ch-field = key-curr-ch-field)
               perform add-totalizer
           else
               perform write-record-out
               move sort-data           to save-record-sort              
               move key-curr-ch-field   to key-prec-ch-field
               perform reset-totalizer
               perform add-totalizer
           end-if
      
      * ## NO filtering data 
      *     move sort-data        to outfile-record              
      *     write outfile-record 
      *     add 1 to record-counter-out
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
       write-record-out.
      * ============================= *
           move low-value           to outfile-record
      **     if (record-counter-out <= stopaft)
               add  1                   to record-counter-out
               move save-record-sort    to outfile-record
               move zero                to bIsPending
               write outfile-record 
      **     end-if
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
