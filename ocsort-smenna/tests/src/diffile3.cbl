      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   COBOL module Difference file output.
      *            Check files result. 
      *            Sort/Merge COBOL Program and OCSort data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. diffile3.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select sortcbl assign to external dd_incobol
                organization is sequential
                access is sequential
                file status is fs-infile1.
      *sort input file2
           select sortocs assign to external dd_inocsort
                organization is sequential
                access is sequential
                file status is fs-infile2.
       data division.
       file section.
       fd sortcbl.
       01 infile-record-cbl.
      *15  filler 80, 11      space                                     Pos Len 
           05 in1-01                pic x(10).                          01, 10      C'FIELD SPEC' 
           05 in1-02                pic x(07).                          11, 07      11:1,7   sequence 9(07)
           05 filler                pic x(04).                          18, 04      
           05 in1-03                pic x(01).                          22, 01      22:X
           05 in1-04                pic x(05).                          23, 05      C'ALPHA'
           05 in1-05                pic x(05).                          28, 05      8,5      ch-field x(5)
           05 filler                pic x(07).                          33, 07      
           05 in1-06                pic x(01).                          40, 01      40:Z (00 binary)
           05 in1-07                pic x(09).                          41, 09      3C'XYZ'
           05 in1-08                pic x.                              50, 01      X'{' (7B esa)
           05 in1-09                pic x(06).                          51, 06      6Z
           05 in1-10                pic x(06).                          57, 06      2X'<+>' 
           05 in1-11                pic x.                              63, 01      X'}' (7D esa)
           05 in1-12                pic x(07).                          64, 07      Zoned    zd-field s9(7)
           05 in1-13                pic x(08).                          71, 08      8X
           05 in1-14                pic x.                              79, 01      C'+' 
           05 in1-fill              pic x(11).                          80, 11      space
       
       
       fd sortocs.
       01 infile-record-ocs.
      *15  filler 80, 11      space                                     Pos Len 
           05 in2-01                pic x(10).                          01, 10      C'FIELD SPEC' 
           05 in2-02                pic x(07).                          11, 07      11:1,7   sequence 9(07)
           05 filler                pic x(04).                          18, 04      
           05 in2-03                pic x(01).                          22, 01      22:X
           05 in2-04                pic x(05).                          23, 05      C'ALPHA'
           05 in2-05                pic x(05).                          28, 05      8,5      ch-field x(5)
           05 filler                pic x(07).                          33, 07      
           05 in2-06                pic x(01).                          40, 01      40:Z (00 binary)
           05 in2-07                pic x(09).                          41, 09      3C'XYZ'
           05 in2-08                pic x.                              50, 01      X'{' (7B esa)
           05 in2-09                pic x(06).                          51, 06      6Z
           05 in2-10                pic x(06).                          57, 06      2X'<+>' 
           05 in2-11                pic x.                              63, 01      X'}' (7D esa)
           05 in2-12                pic x(07).                          64, 07      Zoned    zd-field s9(7)
           05 in2-13                pic x(08).                          71, 08      8X
           05 in2-14                pic x.                              79, 01      C'+' 
           05 in2-fill              pic x(11).                          80, 11      space       
      *
       working-storage section.
       77 fs-infile1                pic xx  value "00".
       77 fs-infile2                pic xx  value "00".
       77 fs-sort                   pic xx  value "00".
      *
       01 bError                         pic 9    value zero.
       77 record-counter-incbl           pic 9(7) value zero.
       77 record-counter-inocs           pic 9(7) value zero.
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
           display " diff3 "
           display " Check file produced by Cobol Program and OCSort "
           display "*===============================================* "
           open input sortcbl.
           if fs-infile1 not = "00"
                display "sortcbl file status error : " fs-infile1
                stop run
           end-if

           open input sortocs.
           if fs-infile2 not = "00"
                display "sortocs file status error : " fs-infile2
                close sortcbl
                stop run
           end-if
           
           perform check-data until  (fs-infile1 not equal "00"  and 
                                      fs-infile2 not equal "00" ) or 
                                      bError     equal 1
           close sortcbl
           close sortocs
           display "*===============================================* "
           if (bError = zero) or 
              (record-counter-incbl = record-counter-inocs)
                display " Check OK  "
                move zero to return-code
           else
                display " Check KO  "
                move 25 to return-code
           end-if
           display "*===============================================* "
           display " Record input  cbl  : "  record-counter-incbl
           display " Record output ocs  : "  record-counter-inocs
           display "*===============================================* "
           goback
           .
      *
      * ============================= *
       check-data.
      * ============================= *
           if fs-infile1 = "00"
                read sortcbl at end display " End file sortcbl "
                end-read
           end-if
           if fs-infile1 = "00"
                add 1 to record-counter-incbl
           end-if
           if fs-infile2 = "00"
                read sortocs at end display " End file sortocs "
                end-read
           end-if
           if fs-infile2 = "00"
                add 1 to record-counter-inocs
           end-if
           if (fs-infile1 = "00" and fs-infile1 = "00")
                perform check-key
           end-if
           .
      *
      * ============================= *
       check-key.
      * ============================= *
      
      *    if (infile-record-cbl not = 
      *        infile-record-ocs)
      *        move 1 to bError
      *        display "============== # Error # ============== "
      *        display "  Record COBOL  num " record-counter-incbl
      *        display "  Record OCSort num " record-counter-inocs
      *    end-if
           if (in1-01       not = in2-01    or
               in1-02       not = in2-02    or
               in1-03       not = in2-03    or
               in1-04       not = in2-04    or
               in1-05       not = in2-05    or
               in1-06       not = in2-06    or
               in1-07       not = in2-07    or
               in1-08       not = in2-08    or
               in1-09       not = in2-09    or
               in1-10       not = in2-10    or
               in1-11       not = in2-11    or
               in1-12       not = in2-12    or
               in1-13       not = in2-13    or
               in1-14       not = in2-14    or
               in1-fill     not = in2-fill  )
               move 1 to bError
               display "============== # Error # ============== "
               display "  Record COBOL  num " record-counter-incbl
               display "  Record OCSort num " record-counter-inocs
               display " Cobol                    OCSort"
               display "in1-01   / in2-01  = " in1-01     " / " in2-01   
               display "in1-02   / in2-02  = " in1-02     " / " in2-02   
               display "in1-03   / in2-03  = " in1-03     " / " in2-03   
               display "in1-04   / in2-04  = " in1-04     " / " in2-04   
               display "in1-05   / in2-05  = " in1-05     " / " in2-05   
               display "in1-06   / in2-06  = " in1-06     " / " in2-06   
               display "in1-07   / in2-07  = " in1-07     " / " in2-07   
               display "in1-08   / in2-08  = " in1-08     " / " in2-08   
               display "in1-09   / in2-09  = " in1-09     " / " in2-09   
               display "in1-10   / in2-10  = " in1-10     " / " in2-10   
               display "in1-11   / in2-11  = " in1-11     " / " in2-11   
               display "in1-12   / in2-12  = " in1-12     " / " in2-12   
               display "in1-13   / in2-13  = " in1-13     " / " in2-13   
               display "in1-14   / in2-14  = " in1-14     " / " in2-14   
               display "in1-fill / in2-fill= " in1-fill   " / " in2-fill 
           end-if
           .
