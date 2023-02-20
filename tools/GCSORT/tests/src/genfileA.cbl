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
       identification division.
       program-id. genfile.
       environment division.
       input-output section.
       file-control.
           copy sgensqf01.
       data division.
       file section.
           copy fgensqf01.
      * 
       working-storage section.
       77       record-counter-out    pic 9(7) value zero.
       77       program-name          pic x(12) value "*genfile*".
       77       ntimes                pic 9(3)  value 50.
       77       fs-outfile            pic xx.
       77       rrn                   pic 9(7)  value zero.
       01       idx                   pic 99    value zero.
       01       count-value           pic S9(7) value zero.
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

           
           move zero        to idx, count-value, seq-record, rrn.
           perform generate-file-asc ntimes times.           
           move 27          to idx
           move -1          to count-value
           move ntimes      to seq-record 
           add  1           to seq-record 
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
           write outfile-record
           add 1 to record-counter-out
           .
       generate-file-des.
           perform set-valuerecord-des
           write outfile-record
           add 1 to record-counter-out
           .
       
       set-valuerecord-asc.
           move low-value      to ch-filler
           add 1 to rrn
           add 1 to seq-record  
           add 1 to idx
           if idx > tab-ele-num
               move 1    to idx
           end-if
               
           move tab-ch-ele(idx) to  ch-field(1:2)    
           move tab-ch-ele(idx) to  ch-field(3:3)
           perform add-counter
           move  count-value    to  bi-field    
           perform add-counter
           move  count-value    to  fi-field    
           perform add-counter
           move  count-value    to  fl-field    
           perform add-counter
           move  count-value    to  pd-field    
           perform add-counter
           move  count-value    to  zd-field
           perform add-counter
           move  count-value    to  fl-field-1
           perform add-counter
           move  count-value    to  clo-field
           perform add-counter
           move  count-value    to  cst-field
           perform add-counter
           move  count-value    to  csl-field
           .

       add-counter.
           add  1               to count-value  
           if count-value > 26
               move 1 to count-value
           end-if
           .
     
       set-valuerecord-des.
           move low-value      to ch-filler
           add 1 to rrn
           subtract 1 from seq-record  
           subtract 1 from idx
           if idx <= zero
               move 26 to idx
           end-if
           move tab-ch-ele(idx) to  ch-field(1:2)    
           move tab-ch-ele(idx) to  ch-field(3:3)
           perform sub-counter
           move  count-value    to  bi-field    
           perform sub-counter
           move  count-value    to  fi-field    
           perform sub-counter
           move  count-value    to  fl-field    
           perform sub-counter
           move  count-value    to  pd-field    
           perform sub-counter
           move  count-value    to  zd-field 
           perform sub-counter
           move  count-value    to  fl-field-1
           perform sub-counter
           move  count-value    to  clo-field
           perform sub-counter
           move  count-value    to  cst-field
           perform sub-counter
           move  count-value    to  csl-field
           .
       sub-counter.
           subtract 1 from count-value       
      **     if count-value <= zero
      **         move 26 to count-value
      **     end-if
           .
       view-data.
            read outfile at end 
                 Display "Outfile Input eof 2"
                        end-read.
            if fs-outfile EQUAL "00"
                    display "============== ## ============== "
                    display " sq="   seq-record 
                            " ch="    ch-field
                            " bi="    bi-field      
                            " fi="    fi-field      
                            " pd="    pd-field      
                            " zd="    zd-field 
                            " fl(2)=" fl-field      
                    display " clo="   clo-field
                            " cst="   cst-field      
                            " csl="   csl-field      
                            " fl(1)=" fl-field-1      
            end-if
            .
