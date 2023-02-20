      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     20170103  
      * LICENSE
      *  Copyright (c) 2016 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  generate test environment for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestgetop gctestgetop.cbl 
      ****************************************************************
 	   identification division.
       program-id. gctestgetop.
       environment division.
       configuration section.
           repository.
            function all intrinsic.       
       input-output section.
       file-control.
           select fsys assign to 'gcsysoprun.txt'
           organization is line sequential
           file status is f-s.
       data division.
       file section.
       fd  fsys.
       01  r-def.
           03 r-getsysop                        pic x(9).
           03 r-getsysop-9-red redefines r-getsysop. 
              05    r-getsysop-9                pic 9.
              05    filler                      pic x(8).
           03 r-getsysop-nver-red redefines r-getsysop. 
              05    r-getsysop-nver             pic 9(9).
      *    
      *    
       working-storage section.
       77 f-s                   pic xx.
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
       01 cmd-line              pic x(512).
      *
      *
       linkage section.
      *
       01 ntype                 BINARY-LONG .
       01 nver                  pic 9(9).
      *
      *-------------------------------------------------------*
       procedure division using ntype, nver.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
           move 9       to ntype 
           move zero    to nver
      *    display '*===============================================*'
      *    display ' GCSort test environment ' gcsort-tests-ver
      *    display '*===============================================*'
      *    display '*===============================================*'
      *    display '  gctestgetop          '
      *    display '             Get System Type OS '
      *    display '*===============================================*'
           open input fsys
           if (f-s not = '00')
                display '*gctestgetop* error opening gcsysoprun.txt'
                display ' file status ' f-s
                goback
           end-if
           read fsys
           if (f-s = '00')
              if r-getsysop(1:1) is numeric 
                move r-getsysop-9  to ntype  
              end-if
           end-if
           read fsys
           if (f-s = '00')
              if r-getsysop is numeric 
                move r-getsysop-nver  to nver
              end-if
           end-if
           close fsys
      *
           goback.
      *    
