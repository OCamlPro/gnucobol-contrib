      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
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
       program-id. susesqf02b.
       environment division.
       configuration section.
       special-names.
           ALPHABET    case-ascii      IS  ASCII
           ALPHABET    case-ebcdic     IS  EBCDIC.      
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file
            select sortin assign to external dd_infile
                organization is sequential
                access is sequential
                file status is fs-infile.
      *sort output file
          select sortout assign to EXTERNAL dd_outfile
                organization is sequential
                access is sequential
                file status is fs-outfile.
      *sort file (sd)
           select file-sort assign to external dd_sortwork
                file status is fs-sort.
       data division.
       file section.
      * finsqf01.cpy
       fd sortin.
       01 infile-record.
           05 in-seq-record       pic  9(07).
           05 in-ch-field         pic  x(5).
           05 in-bi-field         pic  9(7) comp.
           05 in-fi-field         pic s9(7) comp.
           05 in-fl-field         comp-2.
           05 in-pd-field         pic s9(7) comp-3.
           05 in-zd-field         pic s9(7).
           05 in-fl-field-1       comp-1.
           05 in-clo-field        pic s9(7) sign is leading.
           05 in-cst-field        pic s9(7) sign is trailing separate.
           05 in-csl-field        pic s9(7) sign is leading separate.
           05 in-ch-filler        pic  x(25).

       fd sortout.
       01 outfile-record.
           05 out-seq-record     pic  9(07).
           05 out-ch-field       pic  x(5).
           05 out-bi-field       pic  9(7) comp.
           05 out-fi-field       pic s9(7) comp.
           05 out-fl-field       comp-2.
           05 out-pd-field       pic s9(7) comp-3.
           05 out-zd-field       pic s9(7).
           05 out-fl-field-1     COMP-1.
           05 out-clo-field      pic s9(7) sign is leading.
           05 out-cst-field      pic s9(7) sign is trailing separate.
           05 out-csl-field      pic s9(7) sign is leading separate.
           05 out-ch-filler      pic  x(25).

       sd file-sort.
       01 sort-data.
           05 srt-seq-record      pic  9(07).
           05 srt-xx-seq-record redefines srt-seq-record pic  x(07).
           05 srt-ch-field        pic  x(5).
           05 srt-bi-field        pic  9(7) comp.
           05 srt-fi-field        pic s9(7) comp.
           05 srt-fl-field        comp-2.
           05 srt-pd-field        pic s9(7) comp-3.
           05 srt-zd-field        pic s9(7).
           05 srt-xx-zd-field redefines srt-zd-field pic x(7).
           05 srt-fl-field-1        COMP-1.
           05 srt-clo-field       pic s9(7) sign is leading.
           05 srt-cst-field       pic s9(7) sign is trailing separate.
           05 srt-csl-field       pic s9(7) sign is leading separate.
           05 ch-filler           pic  x(25).
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
           display " Sort on ascending  key    srt-ch-field "                 
           display "*===============================================* "
           
           perform reset-totalizer
           
      *  check if defined environment variables
           move 'dd_infile'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_outfile'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_sortwork'  to env-pgm
           perform check-env-var
           
           sort file-sort
                on ascending  key    srt-ch-field                          
                   with duplicates in  order 
                    input procedure  is input-proc
                    output procedure is output-proc.
                    
           display "*===============================================* "
           display " Record input  : "  record-counter-in
           display " Record output : "  record-counter-out
           display "*===============================================* "
           
test00**   open input sortin.
test00**   display '========================================='
test00**   display ' Input file '
test00**   display '========================================='
test00**   perform view-data2 until fs-infile not equal "00"
test00**   close sortin
test00**   display '========================================='
test00**   display ' Output file '
test00**   display '========================================='
test00**   open input sortout.
test00**   perform view-data until fs-outfile not equal "00"
test00**   close sortout
           goback
           .
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
      * ============================= *
        inputrec-proc.
      * ============================= *
           read sortin
           end-read
           if fs-infile equal "00"
               perform release-record
           end-if
           .
      * ============================= *
       release-record.
      * ============================= *
           add 1 to record-counter-in
           release sort-data from infile-record
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
               move 1            to bIsPending
               perform add-totalizer
           else
               perform write-record-out
               move sort-data           to save-record-sort              
               move key-curr-ch-field   to key-prec-ch-field
               perform reset-totalizer
               perform add-totalizer
           end-if      
           .

      * ============================= *
       add-totalizer.
      * ============================= *
      * Sum all Fields  
            add Srt-bi-field     to Tot-bi-field
test00**         display ' add Srt-bi-field ' Srt-bi-field
test00**                 ' to  Tot-bi-field ' Tot-bi-field
            add Srt-fi-field     to Tot-fi-field
test00**        display ' add Srt-fi-field ' Srt-fi-field
test00**                ' to  Tot-fi-field ' Tot-fi-field
            add Srt-fl-field     to Tot-fl-field
            add Srt-pd-field     to Tot-pd-field
            add Srt-zd-field     to Tot-zd-field
            add Srt-fl-field-1   to Tot-fl-field-1
            add Srt-clo-field    to Tot-clo-field
            add Srt-cst-field    to Tot-cst-field
            add Srt-csl-field    to Tot-csl-field
           .
      * ============================= *
       reset-totalizer.    
      * ============================= *
      *  copy   przerotot.cpy
           move zero to Tot-bi-field
           move zero to Tot-fi-field
           move zero to Tot-fl-field
           move zero to Tot-pd-field
           move zero to Tot-zd-field
           move zero to Tot-fl-field-1
           move zero to Tot-clo-field
           move zero to Tot-cst-field
           move zero to Tot-csl-field
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
           move Tot-bi-field    to out-bi-field
test00**          display ' write Tot-bi-field ' Tot-bi-field
test00**                  ' write Out-bi-field ' Out-bi-field
           move Tot-fi-field    to out-fi-field
test00**        display ' write Tot-fi-field ' Tot-fi-field
test00**                ' write Out-fi-field ' Out-fi-field
           move Tot-fl-field    to out-fl-field
           move Tot-pd-field    to out-pd-field
           move Tot-zd-field    to out-zd-field
test00**           TRANSFORM   out-zd-field   FROM  case-ascii        
test00**                                      TO    case-ebcdic      
           move Tot-fl-field-1  to out-fl-field-1
           move Tot-clo-field   to out-clo-field
test00**           TRANSFORM   out-clo-field   FROM  case-ascii        
test00**                                      TO    case-ebcdic      
           move Tot-cst-field   to out-cst-field
test00**           TRANSFORM   out-cst-field   FROM  case-ascii        
test00**                                      TO    case-ebcdic      
           move Tot-csl-field   to out-csl-field
test00**           TRANSFORM   out-csl-field   FROM  case-ascii        
test00**                                      TO    case-ebcdic  
                                      
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
                           " fl_="  out-fl-field-1  
                           " clo="  out-clo-field   
                           " cst="  out-cst-field   
                           " csl="  out-csl-field   
           end-if
           .
      * ============================= *
       view-data2.
      * ============================= *
           read sortin at end 
                display " "
           end-read
           if fs-infile equal "00"
                   display "============== ## ============== "
                   display " sq="   in-seq-record 
                           " ch="   in-ch-field 
                           " bi="   in-bi-field      
                           " fi="   in-fi-field      
                           " pd="   in-pd-field      
                           " zd="   in-zd-field 
                           " fl="   in-fl-field      
                           " fl_="  in-fl-field-1  
                           " clo="  in-clo-field   
                           " cst="  in-cst-field   
                           " csl="  in-csl-field  
            end-if
           .
