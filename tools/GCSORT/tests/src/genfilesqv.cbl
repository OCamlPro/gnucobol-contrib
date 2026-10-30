      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   COBOL module generate file.
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
      * set dd_outfile=..\files\extsm_inputsqv.dat
       identification division.
       program-id. genfilesqv.
       environment division.
       input-output section.
       file-control.
000008     SELECT outfile ASSIGN TO dd_outfile
000009         ORGANIZATION IS  SEQUENTIAL
               file status is fs-outfile.
       data division.
       file section.
000020 FD  outfile
          RECORD VARYING IN SIZE FROM 10 TO 100 CHARACTERS
           DEPENDING ON ws-rec-len-out.
000021 01  outfile-record              PIC X(100).
000022 01  FILLEX redefines outfile-record.
           03   PROG01             pic 9(3).
           03   PROG02             pic 9(5).
           03   AREA01             pic x(92).
      * 
       working-storage section.
       01  WS-REC-LEN-OUT      PIC 9(03) COMP.
       77       record-counter-out    pic 9(11) value zero.
       77       program-name          pic x(12) value "*genfile*".
       77       ntimes                pic 9(7)  value 10.
       77       fs-outfile            pic xx.
       77       rrn                   pic 9(7)  value zero.
       01       idx                   pic 9(5)    value zero.
       01       count-value           pic S9(11) value zero.
       01       tab-ch.
           02   tab-ele-num           pic 99    value 26.
           02   tab-ele-value         pic x(52) value
           "QQAAZZWWSSXXEEDDCCRRFFVVTTGGBBYYHHNNUUJJMMIIKKOOLLPP".
           02   tab-ch-ele redefines 
                    tab-ele-value occurs 26 times pic xx.
       01    cmd-line           pic x(132).
      *
       77 env-pgm                       pic x(50).
       77 env-var-value                 pic x(1024).        
       procedure division.
       master-00.
      *
           display program-name " START"
      *  check if defined environment variables
           move 'dd_outfile'  to env-pgm
           perform check-env-var
      *                
           open output outfile.
           if fs-outfile not = "00"
                display "outfile file status error : " fs-outfile
                move 25 to RETURN-CODE
                stop run
           end-if

           
           move zero        to idx, count-value, rrn.
           perform generate-file-asc ntimes times.           
           move 99999          to idx
           move -1          to count-value
           perform generate-file-des ntimes times.   
           close outfile.
      *
           display "*===============================================* "
           display " Records created : "  record-counter-out
           display "*===============================================* "
      
           display program-name " END"
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
       generate-file-asc.
           perform set-valuerecord-asc
           move 90 to ws-rec-len-out
           write outfile-record
           add 1 to record-counter-out
           .
       generate-file-des.
           perform set-valuerecord-des
           move 80 to ws-rec-len-out
           write outfile-record
           add 1 to record-counter-out
           .
       
       set-valuerecord-asc.
           add 1 to rrn
           add 1 to idx
           move   idx       to prog01
           move   "genfilesqv libgcs"    to area01
           move   idx       to prog02
           .

       add-counter.
           add  1               to count-value  
           if count-value >= 99999
               move 1 to count-value
           end-if
           .
     
       set-valuerecord-des.
           add 1 to rrn
           subtract 1 from idx
           if idx <= zero
               move 99999 to idx
           end-if
           move   idx       to prog01
           move   "genfilesqv libgcs"    to area01
           move   idx       to prog02
           perform sub-counter
           .
       sub-counter.
           subtract 1 from count-value       
           .
