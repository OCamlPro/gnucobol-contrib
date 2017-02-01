      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Split sorted file 
      * Instruction OUTFIL SPLIT
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. soutfsqf03b.
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
      *sort output file1
           select sortout1 assign to external dd_outfile1
                organization is sequential
                access is sequential
                file status is fs-outfile1.
      *sort output file2
           select sortout2 assign to external dd_outfile2
                organization is sequential
                access is sequential
                file status is fs-outfile2.
      *sort output file3
           select sortout3 assign to external dd_outfile3
                organization is sequential
                access is sequential
                file status is fs-outfile3.
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
       fd sortout1.
       01 outfile-record1           pic x(90).
       fd sortout2.
       01 outfile-record2           pic x(90).
       fd sortout3.
       01 outfile-record3           pic x(90).
      *
       working-storage section.
       77 nsplit                         pic 9.
       77 fs-infile                      pic xx.
       77 fs-outfile                     pic xx.
       77 fs-outfile1                    pic xx.
       77 fs-outfile2                    pic xx.
       77 fs-outfile3                    pic xx.
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
      *  check if defined environment variables
           move 'dd_outfile1'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_outfile2'  to env-pgm
           perform check-env-var
      *  check if defined environment variables
           move 'dd_outfile3'  to env-pgm
           perform check-env-var           
      *        
           sort file-sort
                on ascending  key    srt-ch-field                          ## on descending key    <modify key>    
                   with duplicates in  order                               ## DUPLICATES
                    input procedure  is input-proc
                    output procedure is output-proc.
           move 1 to nsplit
           open output sortout1
           open output sortout2
           open output sortout3
           open input sortout
           if fs-outfile = "00"
                perform split-data until fs-outfile not equal "00"
           end-if
           close sortout
           close sortout1
           close sortout2
           close sortout3
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
           if fs-infile equal "00"
               perform release-record
           end-if
           .
      * ============================= *
       release-record.
      * ============================= *
           add 1 to record-counter-in
      ** filtering input record 
           if ((in-ch-field(1:2) = "AA")  AND                                 ## filtering data    
               (in-zd-field < 20))
                    release sort-data from infile-record
           end-if
           .
      *
      * ============================= *
       output-proc.
      * ============================= *
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
      *  copy   praddsrttot.cpy
           copy  praddsrttot.
           move 1            to bIsPending
           .
      * ============================= *
       reset-totalizer.    
      * ============================= *
      *  copy   przerotot.
           copy   przerotot.
           .
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
       split-data.
      * ============================= *
           read sortout at end 
                display " "
           end-read
           if fs-outfile equal "00"
              if nsplit = 1
                 move outfile-record to outfile-record1
                 write outfile-record1
              end-if
              if nsplit = 2
                 move outfile-record to outfile-record2
                 write outfile-record2
              end-if
              if nsplit = 3
                 move outfile-record to outfile-record3
                 write outfile-record3
              end-if
              add 1 to nsplit
              if nsplit > 3
                 move 1 to nsplit
              end-if
           end-if
           .
