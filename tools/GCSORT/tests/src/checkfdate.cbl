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
       program-id. checkfdate.
       environment division.
       input-output section.
       file-control.
      
          select infile assign to EXTERNAL dd_infile
                organization is sequential
                access is sequential
                file status is fs-infile.       
       data division.
       file section.
      *  Record len 55  
       fd infile.
       01 infile-record.
           05 sep-01                pic x.
           05 seq-record            pic 9(07).
           05 sep-02                pic x.
      * Y2T8 = Y4T8 (?) C'ccyymmdd' or Z'ccyymmdd'
           05 Y2T8                  pic 9(8).
           05 sep-03                pic x.
      * Y2T4 : C'yyxx' or Z'yyxx'    
           05 Y2T4                  pic 9(4).  
           05 sep-04                pic x.
      * Y2T2 'yy'   
           05 Y2T2                  pic 9(2).  
           05 sep-05                pic x.
      * Y2T2 'yyx'  (???)   
           05 Y2T3                  pic 9(3).  
           05 sep-06                pic x.
      * 5,Y2T: C'yyddd' or Z'yyddd'
           05 Y2T5                  pic 9(5).  
           05 sep-07                pic x.
      * 6,Y2T: C'yymmdd' or Z'yymmdd'     
           05 Y2T6                  pic 9(6).  
           05 sep-08                pic x.
      * 7,Y4T: C'ccyyddd' or Z'ccyyddd'    
           05 Y4T7                  pic 9(7).  
           05 sep-09                pic x.
      *     
           05 Y2B                   pic 99 comp.
           05 sep-10                pic x.
           05 Y2C                   pic 99. 
           05 sep-11                pic x.
           05 Y2D                   pic 99 comp-6. 
      ***     05 Y2D                   pic 99 comp-3. 
           05 sep-12                pic x.
           05 Y2P                   pic 99 comp-3.
           05 sep-13                pic x.
           05 Y2S                   pic 99.
           05 sep-14                pic x.
      * 3,Y2U	P'yyddd'   
           05 Y2U                   pic s9(5) comp-3. 
           05 sep-15                pic x.
      * 4,Y2V	P'yymmdd'    
           05 Y2V                   pic s9(6) comp-3.
           05 sep-16                pic x.
      * 3,Y2X	P'dddyy'    
           05 Y2X                   pic s9(5) comp-3.
           05 sep-17                pic x.
      * 4,Y2Y	P'mmddyy'
           05 Y2Y                   pic  9(6) comp-3.
           05 sep-18                pic x.
      *     
           05 Y2Z                   pic 99.
           05 sep-19                pic x.
      * 
       working-storage section.
       77       rec-prev              pic x(85).
       77       record-counter-in     pic 9(7) value zero.
       77       program-name          pic x(15) value "*checkfdate*".
       77       fs-infile             pic xx.
       77       count-value           pic 9(7) value zero.
      *
       01       wk-date8              pic 9(8).
       01 filler redefines wk-date8.
           03   wk-yyyy               pic 9(4).
           03   wk-mm                 pic 99.
           03   wk-dd                 pic 99.
       01 filler redefines wk-date8.
           03   wk-cc                 pic 9(2).
           03   wk-yy                 pic 9(2).
           03   wk-mmdd               pic 9(4).
       01 filler redefines wk-date8.
           03   filler                pic 9(2).
           03   wk-yymmdd             pic 9(6).
      *
       77 env-pgm                     pic x(50).
       77 env-var-value               pic x(1024).
       77 header-disp                 pic x(10).       
      *============================================*
       procedure division.
      *============================================*
       master-00.
      *
           display "*===============================================* "
           display program-name " START"
           display "*===============================================* "
      *  check if defined environment variables
      *    
           move 'dd_infile'  to env-pgm
           perform check-env-var
      *                
           open input infile.
           if fs-infile not = "00"
                display "infile file status error : " fs-infile
                move 25 to RETURN-CODE
                stop run
           end-if
      *
           move  zero         to count-value.
      *    
       lb-10.
      *
           read infile at end go lb-80.
      *
            add 1 to record-counter-in
      *                 
           if count-value = zero
                move seq-record  to count-value
           end-if
           if seq-record  <  count-value
                display '*checkfdate* ERROR sequence error '
           display  
           '*=========================================================='
           '==========================================================='
           '=====*'
           display 
           '  Record  |id rek |  Y2T8  |Y2T4|Y2T2|Y2T3|Y2T5 | Y2T'
           '6 |  Y2T7  |Y2B |Y2C|Y2D|Y2P |Y2S|  Y2U   |'
           '  Y2V   |  Y2X  | Y2Y  |Y2Z|'
           display 
           '*=========================================================='
           '==========================================================='
           '=====*'
                move " Current  "       to header-disp
                perform        display-value-rek   
                move rec-prev  to infile-record
                move " Previous "   to header-disp
                perform        display-value-rek   
           display 
           '*=========================================================='
           '==========================================================='
           '=====*'
                move 25 to RETURN-CODE
                go lb-90
           end-if
           move infile-record  to rec-prev
      * 
           .
      *    
           go to lb-10.
       lb-80.
           display "*===============================================* "
           display " CHECK OK "
           display "*===============================================* "
           .
       lb-90.
           close infile.
      *
           display "*===============================================* "
           display " Records checked : "  record-counter-in
           display "*===============================================* "
      
           display program-name " END"
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
      * ============================= *
       display-value-rek   section.
      * ============================= *
       10.
           add 1 to count-value
      *
           display     header-disp '|'
           seq-record   '|'
           Y2T8         '|'
           Y2T4         '|'
           Y2T2         '  |'
           Y2T3         ' |'
           Y2T5         '|'
           Y2T6         '|'
           Y4T7         ' |'
           Y2B          ' |'
           Y2C          ' |'
           Y2D          ' |'
           Y2P          '  |'
           Y2S          ' |'
           Y2U          '  |'
           Y2V          ' |'
           Y2X          ' |'
           Y2Y          '|'
           Y2Z          ' |'
            .
      **      display ' ------------------------------------------------'
      **      display ' seq-record pic 9(07)         '   seq-record 
      **      display ' Y2T8       pic 9(8)          '   Y2T8       
      **      display ' Y2T4       pic 9(4)          '   Y2T4       
      **      display ' Y2T2       pic 9(2)          '   Y2T2       
      **      display ' Y2T3       pic 9(3)          '   Y2T3       
      **      display ' Y2T5       pic 9(5)          '   Y2T5       
      **      display ' Y2T6       pic 9(6)          '   Y2T6       
      **      display ' Y4T7       pic 9(7)          '   Y4T7       
      **      display ' Y2B        pic 99 comp       '   Y2B        
      **      display ' Y2C        pic 99            '   Y2C        
      **      display ' Y2D        pic 99 comp-6     '   Y2D        
      **      display ' Y2P        pic 99 comp-3     '   Y2P        
      **      display ' Y2S        pic 99            '   Y2S        
      **      display ' Y2U        pic s9(5) comp-3  '   Y2U        
      **      display ' Y2V        pic s9(6) comp-3  '   Y2V        
      **      display ' Y2X        pic s9(5) comp-3  '   Y2X        
      **      display ' Y2Y        pic  9(6) comp-3  '   Y2Y        
      **      display ' Y2Z        pic 99            '   Y2Z        
      **      display ' ------------------------------------------------'
      **             .
       90.
           exit.
      *
