      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests JOIN
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      202208
      * License
      *    Copyright 2022 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  joinsort01.
       environment division.
       input-output section.
       file-control.
           select sortin  assign to  external dd_infile
               organization is line sequential
               access mode  is sequential
                file status is fs-infile.
           select sortout assign to  external dd_outfile
               organization is line sequential
               access mode  is sequential
                file status is fs-outfile.
           select filesort assign to external dd_sortwork
                file status is fs-sort.
       data division.
       file section.
       fd sortin.
       01 infile-record     pic X(15).
       fd sortout.
       01 outfile-record    pic X(15).
       sd filesort.
       01 sort-data.
            07 key-srt      pic x(6).
            07 filler       pic x(9).

       working-storage section.
      *
       77 fs-infile                 pic xx.
       77 fs-outfile                pic xx.
       77 fs-sort                   pic xx.
      *
       77 record-counter-in         pic 9(11).
       77 record-counter-out        pic 9(11).
      *    
           copy wkenvfield.
      *    
       procedure division.
       begin.
      *  check if defined environment variables
           move 'dd_infile'     to env-pgm
           perform check-env-var
           move 'dd_outfile'    to env-pgm
           perform check-env-var
           move 'dd_sortwork'   to env-pgm
           perform check-env-var.
      *
           perform sort-f1.
           goback.
      *                
       sort-f1.
           display "*===============================================* "
           display " Sort F1 on ascending  key    "       
           display "          key-srt (Input file 1,6) ascending  "      
           display "*===============================================* "
      *
           copy prenvfield1.
      *        
           sort filesort
               on  ascending  key    key-srt                        
                   with duplicates in  order 
                    input procedure  is input-proc
                    output procedure is output-proc.
                    
           display "*===============================================* "
           display " Record input  : "  record-counter-in
           display " Record output : "  record-counter-out
       sort-f1-ex.
           exit.
      *
      *
      * ============================= *
       input-proc.
      * ============================= *
           open input sortin.
           perform inputrec-proc until fs-infile not equal "00"
           close sortin.
      *
      * ============================= *
        inputrec-proc.
      * ============================= *
           read sortin
           end-read
           if fs-infile equal "00"
               perform release-record
           end-if.
      * ============================= *
       release-record.
      * ============================= *
           add 1 to record-counter-in
      ** filtering input record 
           release sort-data from infile-record
           .
      *
      * ============================= *
       output-proc.
      * ============================= *
           open output sortout.
           perform outrec-proc-dett until fs-sort  
                   not equal "00".
           close sortout.
      *
      * ============================= *
       outrec-proc-dett.
      * ============================= *
      *
           return filesort at end 
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
       write-record-out.
      * ============================= *
           move low-value          to outfile-record
           add 1 to record-counter-out
           move sort-data          to outfile-record
           write outfile-record 
           .
      *       
           copy prenvfield2.
      *
