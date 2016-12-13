      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module for OUTREC
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. soutsqf10b.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file
      * sinsqf01.cpy
           copy  sinsqf01.
      * soutsqf01.cpy
           copy soutsqf01.
      *sort file (sd)
      * ssrtsqf01.cpy
           copy ssrtsqf01.
       data division.
       file section.
      * finsqf01.cpy
           copy finsqf01.
      *    
       fd sortout.
       01 outfile-record.
      * Constant
      *           Pos Len 
      * 1  out-01 01, 10      C'FIELD SPEC'       
      * 2  out-02 11, 07      11:1,7   sequence 9(07)
      * 3  out-03 18, 05      22:X
      * 4  out-04 23, 05      C'ALPHA'
      * 5  out-05 28, 05      8,5      ch-field x(5)
      * 6  out-06 33, 08      40:Z (00 binary)
      * 7  out-07 41, 09      3C'XYZ'
      * 8  out-08 50, 01      X'{' (7B esa)
      * 9  out-09 51, 06      6Z
      *10  out-10 57, 06      2X'<+>'
      *11  out-11 63, 01      X'}' (7D esa)
      *12  out-12 64, 07      Zoned    zd-field s9(7) 
      *13  out-13 71, 08      8X
      *14  out-14 79, 01      C'+'
      *15  filler 80, 11      space                                     Pos Len 
           05 out-01                pic x(10).                          01, 10      C'FIELD SPEC' 
           05 out-02                pic x(07).                          11, 07      11:1,7   sequence 9(07)
           05 filler                pic x(04).                          18, 04      
           05 out-03                pic x(01).                          22, 01      22:X
           05 out-04                pic x(05).                          23, 05      C'ALPHA'
           05 out-05                pic x(05).                          28, 05      8,5      ch-field x(5)
           05 filler                pic x(07).                          33, 07      
           05 out-06                pic x(01).                          40, 01      40:Z (00 binary)
           05 out-07                pic x(09).                          41, 09      3C'XYZ'
           05 out-08                pic x.                              50, 01      X'{' (7B esa)
           05 out-09                pic x(06).                          51, 06      6Z
           05 out-10                pic x(06).                          57, 06      2X'<+>' 
           05 out-11                pic x.                              63, 01      X'}' (7D esa)
           05 out-12                pic x(07).                          64, 07      Zoned    zd-field s9(7)
           05 out-12-zd redefines out-12 pic s9(7).
           05 out-13                pic x(08).                          71, 08      8X
           05 out-14                pic x.                              79, 01      C'+' 
           05 out-fill              pic x(11).                          80, 11      space
      * fsrtsqf01.cpy
           copy fsrtsqf01.
      *
       working-storage section.
       77 fs-infile                 pic xx.
       77 fs-outfile                pic xx.
       77 fs-sort                   pic xx.
      *  
           copy wktotsum01.
      *
      * ============================= *
       01  save-record-sort              pic x(38).
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
       master-sort.
           display "*===============================================* "
           display " Sort on ascending  key    srt-ch-field "                 ## on descending key    <modify key>               
           display "*===============================================* "
           
           sort file-sort
                on ascending  key    srt-ch-field                         ## on descending key    <modify key>    
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
           return file-sort at end 
                display " "
                end-return
           if fs-sort equal "00"     
               perform write-record-out
           end-if
           .
      * ============================= *
       write-record-out.
      * ============================= *
           move space         to outfile-record
           add 1 to record-counter-out
      * 1  out-01 01, 10      C'FIELD SPEC'       
      * 2  out-02 11, 07      11:1,7   sequence 9(07)
      * 3  out-03 18, 05      5:X
      * 4  out-04 23, 05      C'ALPHA'
      * 5  out-05 28, 05      8,5      ch-field x(5)
      * 6  out-06 33, 08      8:Z (00 binary)
      * 7  out-07 41, 09      3C'XYZ'
      * 8  out-08 50, 01      X'{' (7B esa)
      * 9  out-09 51, 06      7Z
      *10  out-10 57, 06      2X'<|>'
      *11  out-11 63, 01      X'}' (7D esa)
      *12  out-12 64, 07      Zoned    zd-field s9(7) 
      *13  out-13 71, 09      9X
      *14  out-14 80, 01      C'+'
      *15  filler 81, 09      space
           move   space               to outfile-record
           move   "FIELD SPEC"        to out-01 
           move    srt-seq-record     to out-02 
           move    space              to out-03 
           move    "ALPHA"            to out-04 
           move    srt-ch-field       to out-05 
           move    low-value          to out-06 
           move    "XYZXYZXYZ"        to out-07 
           move    "{"                to out-08 
           move    low-value          to out-09 
           move    "<+><+>"           to out-10 
           move    "}"                to out-11 
      *    move    srt-zd-field       to out-12 
           move    srt-zd-field       to out-12-zd
           move    space              to out-13 
           move    "+"                to out-14 
           write outfile-record 
           move zero                  to bIsPending
           .
