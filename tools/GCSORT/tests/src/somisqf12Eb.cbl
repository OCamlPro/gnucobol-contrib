      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * Instruction INCLUDE,INREC, OUTREC
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      * *********************************************
      *
      *                                                         pos   len
      *         05 in-seq-record        pic  9(07).              1      7
      *         05 in-ch-field          pic  x(5).               8      5
      *         05 in-bi-field          pic  9(7) comp.         13      3
      *         05 in-fi-field          pic s9(7) comp.         16      4
      *         05 in-fl-field          comp-2.                 20      8
      *         05 in-pd-field          pic s9(7) comp-3.       28      4
      *         05 in-zd-field          pic s9(7).              32      7
      *         05 ch-filler            pic  x(52).             39     52
      *------------------------------------------------------------------------*
      *                                                         pos   len
      *         05 out-seq-record        pic  9(07).             1     7
      *         05 out-zd-field          pic s9(7).              8     7
      *         05 out-fl-field          comp-2.                15     8
      *         05 out-fi-field          pic s9(7) comp.        23     4
      *         05 out-pd-field          pic s9(7) comp-3.      27     4
      *         05 out-bi-field          pic  9(7) comp.        31     3
      *         05 out-ch-field          pic  x(5).             34     5  
      *         05 ch-filler             pic  x(52).            39    52
      *------------------------------------------------------------------------*
      *
      *
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. somisqf12b.
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
       fd sortout.
       01 outfile-record.
      **     05 out-seq-record        pic  9(07).
      **     05 out-zd-field          pic s9(7).
      **     05 out-fl-field          comp-2.
      **     05 out-fi-field          pic s9(7) comp.
      **     05 out-pd-field          pic s9(7) comp-3.
      **     05 out-bi-field          pic  9(7) comp.
      **     05 out-ch-field          pic  x(5).
      **     05 ch-filler             pic  x(52).
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
      * fsrtsqf02.cpy
           copy fsrtsqf02.
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
       77 record-counter-skip            pic 9(7) value zero.
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
      *    
       01 wk-infile-record.
           05 wk-in-seq-record   pic  9(07).
           05 wk-in-ch-field     pic  x(5).
           05 wk-in-bi-field     pic  9(7) comp.
           05 wk-in-fi-field     pic s9(7) comp.
           05 wk-in-fl-field     comp-2.
           05 wk-in-pd-field     pic s9(7) comp-3.
           05 wk-in-zd-field     pic s9(7).
           05 wk-in-fl-field-1   comp-1.
           05 wk-in-clo-field    pic s9(7) sign is leading.
           05 wk-in-cst-field    pic s9(7) sign is trailing separate.
           05 wk-in-csl-field    pic s9(7) sign is leading separate.
           05 wk-in-ch-filler    pic  x(25).
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
                on ascending  key    srt-ch-field                          ## on ascending  key    <modify key>    
                   with duplicates in  order                               ## DUPLICATES
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
           move infile-record to wk-infile-record
           TRANSFORM wk-in-seq-record FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-ch-field   FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-zd-field   FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-clo-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-cst-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-csl-field  FROM case-ebcdic TO case-ascii       
           TRANSFORM wk-in-ch-filler  FROM case-ebcdic TO case-ascii 
      * filtering input record 
      * OMIT condition 
           if ((wk-in-ch-field(1:2) <= "MM")  AND                                 ## filtering data    
               (wk-in-bi-field >  -10))       OR
              ((wk-in-fi-field >   10)        AND
               (wk-in-fl-field <=  40))       OR
              ((wk-in-pd-field <=  10)        AND
               (wk-in-zd-field >=  15))
			   add 1 to record-counter-skip
           else
                    perform inrec-record
                    release sort-data 
          end-if
           .
      *
      * ============================= *
       inrec-record.
      * ============================= *
      ***     move in-seq-record  to  srt-seq-record 
           move low-value      to outfile-record
      * copy prinrsrt01.cpy           
           copy prinrsrt01.
           .
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
      * ## NO filtering data 
           perform outrec-record
           write outfile-record 
           add 1 to record-counter-out
           .
      * ============================= *
       outrec-record.
      * ============================= *
      ***     move in-seq-record  to  srt-seq-record 
           move low-value      to outfile-record
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
           move srt-seq-record      to outfile-record
           move zero                to bIsPending
           write outfile-record 
           .
