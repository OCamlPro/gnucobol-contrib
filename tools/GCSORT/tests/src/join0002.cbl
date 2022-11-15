      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      202208
      * License
      *    Copyright 2022 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   COBOL module Difference file output.
      *            Check files result. 
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
      * set dd_joinf1=C:\GCSORT\GCSORT_relnew\tests\files\F1JoinA.txt
      * set dd_joinf2=C:\GCSORT\GCSORT_relnew\tests\files\F2JoinA.txt
       identification division.
       program-id. join0002.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *sort input file1
            select sortf1 assign to external dd_joinf1
                organization is line sequential
                access is sequential
                file status is fs-infile1.
      *sort input file2
           select sortf2 assign to external dd_joinf2
                organization is line sequential
                access is sequential
                file status is fs-infile2.
      * join output
            select joinout assign to external dd_joinout
                organization is line sequential
                access is sequential
                file status is fs-joinout.
       data division.
       file section.
       fd sortf1.
       01 infile-record-f1.
           05 in1-key            pic  x(02).
           05 in1-ch-filler      pic  x(13).
       fd sortf2.
       01 infile-record-f2.
           05 in2-key            pic  x(02).
           05 in2-ch-filler      pic  x(13).
       fd joinout.
       01 join-record-out.
           05 jr-type            pic x.
           05 jr-f1              pic  x(15).
           05 jr-f2              pic  x(15).
      *
       working-storage section.
       77 fs-infile1                pic xx.
       77 fs-infile2                pic xx.
       77 fs-joinout                pic xx.
      *
       77 idx-save-f1               pic 9(3).
       77 idx-save-f2               pic 9(3).
       77 idx-f1                    pic 9(3).       
       77 idx-f2                    pic 9(3).       
       77 otheridx                  pic 9(3).
       77 break                     pic 9.
       77 fl-keyf2                  pic 9.
       77 save-idx1                 pic 9(3).
       77 save-idx2                 pic 9(3).
      *
       77 bContinue                 pic 9.
       01 F1-Array.
            02      f1-num-rows        pic 999.
            02      f1-arearekall occurs 100 times.
              03    f1-arearek.
                05    f1-key             pic x(02).
                05    f1-rek             pic x(13).
      *
       01 F2-Array.
            02      f2-num-rows        pic 999.
            02      f2-arearekall occurs 100 times.
              03    f2-arearek.
                05    f2-key             pic x(02).
                05    f2-rek             pic x(13).
      *
      * ============================= *
       01  save-record-sort              pic x(38).
      * ============================= *
       01 bError                      pic 999  value zero.
       77 record-counter-f1           pic 9(9) value zero.
       77 record-counter-f2           pic 9(9) value zero.
       77 record-counter-join         pic 9(9) value zero.
       77 bIsFirstTime                pic 9    value zero.       
       77 bIsPending                  pic 9    value zero.       
       01 current-time.
           05 ct-hours      pic 99.
           05 ct-minutes    pic 99.
           05 ct-seconds    pic 99.
           05 ct-hundredths pic 99.       
      *
       77 env-pgm                       pic x(50).
       77 env-var-value                 pic x(1024).    
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display "*===============================================* "
           display " join "
           display " join files  "
           display "*===============================================* "
      *  check if defined : dd_joinf1,   dd_joinf2
           move 'dd_joinf1'  to env-pgm
           perform check-env-var
           move 'dd_joinf2' to env-pgm
           perform check-env-var
           move 'dd_joinout' to env-pgm
           perform check-env-var
      *                
           open input sortf1.
           if fs-infile1 not = "00"
                display "sortf1 file status error : " fs-infile1
                move 25 to RETURN-CODE
                stop run
           end-if

           open input sortf2.
           if fs-infile2 not = "00"
                display "sortf2 file status error : " fs-infile2
                close sortf1
                move 25 to RETURN-CODE
                stop run
           end-if
           open output joinout.
           if fs-joinout not = "00"
                display "joinout file status error : " fs-infile2
                close sortf1
                close sortf2
                move 25 to RETURN-CODE
                stop run
           end-if
           move zero to  f1-num-rows,  f2-num-rows
           perform read-data until  (fs-infile1 not equal "00"  and 
                                     fs-infile2 not equal "00" )or 
                                     bError     equal 1
           close sortf1
           close sortf2
           move 1 to idx-f1, idx-f2
           perform join-data.
      **    until bContinue equal 1
           
           
           display "*===============================================* "
           if (bError = zero)
                display " Check OK  "
                move zero to return-code
           else
                display " Check KO  "
                move 25 to return-code
           end-if
           close joinout

           display "*===============================================* "
           display " Record input  F1   : "  record-counter-f1
           display " Record input  F2   : "  record-counter-f2
           display " Record output join : "  record-counter-join
           display "*===============================================* "
           goback.
      *
      * ============================= *
        check-env-var section.
      * ============================= *
      *  
       10.
           accept env-var-value  from ENVIRONMENT env-pgm
      ** 
           if (env-var-value = SPACE)
             display "*===============================================*"
             display " Error diff - Environment variable " env-pgm
             display "              not found."
             display "*===============================================*"
             move 25 to RETURN-CODE
             goback
           end-if
           .
       90.
           exit.       
      *
      *
      * ============================= *
       read-data section.
      * ============================= *
       10.
           if fs-infile1 = "00"
               read sortf1 at end 
                display " End file sortf1 fs " fs-infile1
                    end-read
           end-if
           if fs-infile1 = "00"
                add 1 to  record-counter-f1
                add 1 to  f1-num-rows
                move infile-record-f1  to f1-arearek(f1-num-rows)
                display "f1-arearek(f1-num-rows) " 
                         f1-arearek(f1-num-rows)
           end-if
           if fs-infile2 = "00"
              read sortf2 at end 
                display " End file sortf2 fs " fs-infile2
                end-read
           end-if
           if fs-infile2 = "00"
                add 1 to  record-counter-f2
                add 1 to  f2-num-rows
                move infile-record-f2  to f2-arearek(f1-num-rows)
                display "f2-arearek(f2-num-rows) " 
                         f2-arearek(f2-num-rows)
           end-if
           .
       90.
           exit.       
      *
      * ============================= *
       join-data section.
      * ============================= *
       10.
            display "f1-num-rows " f1-num-rows
            display "f2-num-rows " f2-num-rows
            move 1 to idx-save-f1
            move 1 to idx-save-f2
            perform get-f1 varying idx-f1 from idx-save-f1 by 1
                until idx-f1 > f1-num-rows
                
            add 1 to save-idx1    
            display " idx-save-f1 " save-idx1
            perform other-f1 varying otheridx from save-idx1 by 1
                until otheridx > f1-num-rows
                
            add 1 to save-idx2
            display " idx-save-f2 " save-idx2
            perform other-f2 varying otheridx from save-idx2 by 1
                until otheridx > f2-num-rows
            .
       90.
            exit.       
            
      * ============================= *
       other-f1 section.
      * ============================= *
       10.
            add 1 to record-counter-join
            move '1'                to jr-type
            move f1-arearek(otheridx) to jr-f1
            move space              to jr-f2
            write join-record-out
            move idx-f1 to save-idx1
           .
       90.
           exit.
            
      * ============================= *
       other-f2 section.
      * ============================= *
       10.
            add 1 to record-counter-join
            move '2'                to jr-type
            move space              to jr-f1
            move f2-arearek(otheridx) to jr-f2
            write join-record-out
            move idx-f2 to save-idx2
           .
       90.
           exit.
            
      * ============================= *
       get-f1 section.
      * ============================= *
       10.       
            move zero to break.
            move zero to fl-keyf2
            perform get-f2 varying idx-f2 from idx-save-f2 by 1
                until idx-f2 > f2-num-rows or break = 1
            move zero      to fl-keyf2  

            .                      
       90.
            exit.   
      * ============================= *
       get-f2 section.
      * ============================= *
       10.       
            display "*================================*"
            display " idx-f1 " idx-f1 " -- idx-f2 " idx-f2 
            display " key f1 " f1-key(idx-f1) " save-idx1 = " save-idx1
            display " key f2 " f2-key(idx-f2) " save-idx2 = " save-idx2
            display "*--------------------------------*"
            
           if (f1-key(idx-f1) < f2-key(idx-f2))
           
                display " ##    Chiave f1 minore f2 "
                display " ##    f1-key(idx-f1) " f1-key(idx-f1)
                display " ##    f2-key(idx-f2) " f2-key(idx-f2)
                display "========================="
                if (idx-f1 > save-idx1)
                    add 1 to record-counter-join
                    move '1'                to jr-type
                    move f1-arearek(idx-f1) to jr-f1
                    move space              to jr-f2
                    write join-record-out
                    move idx-f1 to save-idx1
                end-if
      *          if fl-keyf2 = zero
      **             move idx-f2 to idx-save-f2  
                    move 1      to fl-keyf2    
      *         end-if
                move idx-f1     to save-idx1
                move 1 to break
           else
               if (f1-key(idx-f1) > f2-key(idx-f2))
                display "  +++++ Chiave f1 maggiore f2 "
                display "  +++++ f1-key(idx-f1) " f1-key(idx-f1)
                display "  +++++ f2-key(idx-f2) " f2-key(idx-f2)
                display "========================="
                if (idx-f2 > save-idx2)
                    add 1 to record-counter-join
                    move '2'                to jr-type
                    move space              to jr-f1
                    move f2-arearek(idx-f2) to jr-f2
                    write join-record-out
                    move idx-f2 to save-idx2
                end-if
      **          if fl-keyf2 = zero
                    move idx-f2 to idx-save-f2  
                    move 1      to fl-keyf2    
      **          end-if
                   move zero to break
                move idx-f2     to save-idx2
               else
                display "  !!!!!! Chiave f1 uguale f2 "
                display "  !!!!!! f1-key(idx-f1) " f1-key(idx-f1)
                display "  !!!!!! f2-key(idx-f2) " f2-key(idx-f2)
                display "========================="
      **            if fl-keyf2 = zero
                        move idx-f2 to idx-save-f2  
                        move idx-f2 to save-idx2
                        move 1      to fl-keyf2    
                        move idx-f1 to save-idx1
      **                  move 1      to break
      **              end-if
                end-if
            end-if
           .
       90.
           exit.      
      *
