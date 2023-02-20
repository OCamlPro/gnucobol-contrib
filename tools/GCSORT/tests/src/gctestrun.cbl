      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     20170103  
      * LICENSE
      *  Copyright (c) 2016 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  run test script for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestrun gctestrun.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun.
       environment division.
       input-output section.
       file-control.
       data division.
       file section.
       working-storage section.
       77 numchars1             pic 9(3).
       77 numchars2             pic 9(3).
       77 chrsl                 pic x value '/'.
       77 chrbs                 pic x value '\'.
	   01 cmd-string            pic x(250).
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
      *
       77 idx                   pic 9(3).
       77 idx-take              pic 9(3).
       77 status-test           pic x(9).
       77 retcode-sum           pic 9(10) value zero.
      *
      *  array-name
       01    array-name.
          03 ar-name-max-ele          pic 99  value 10.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(11) value 'gctestrun1'.
            05 ar-ele-name-02         pic x(11) value 'gctestrun2'.
            05 ar-ele-name-03         pic x(11) value 'gctestrun3'.
            05 ar-ele-name-04         pic x(11) value 'gctestrun4'.
            05 ar-ele-name-05         pic x(11) value 'gctestrun5'.
            05 ar-ele-name-06         pic x(11) value 'gctestrun6'.
            05 ar-ele-name-07         pic x(11) value 'gctestrun7'.
            05 ar-ele-name-08         pic x(11) value 'gctestrun1A'.
            05 ar-ele-name-09         pic x(11) value 'gctestrun1E'.
            05 ar-ele-name-10         pic x(11) value 'gctestrun3E'.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 10 times pic x(11).
      **  
      *  array-name-version
       01    array-name-ver.
          03 ar-name-max-ele-version          pic 99  value 10.
          03 ar-ele-name-version.
            05 ar-ele-name-ver-01         pic 9(9) value 000020200.
            05 ar-ele-name-ver-02         pic 9(9) value 000020200.
            05 ar-ele-name-ver-03         pic 9(9) value 000020200.
            05 ar-ele-name-ver-04         pic 9(9) value 000020200.
            05 ar-ele-name-ver-05         pic 9(9) value 000020200.
            05 ar-ele-name-ver-06         pic 9(9) value 000020200.
            05 ar-ele-name-ver-07         pic 9(9) value 000020200.
            05 ar-ele-name-ver-08         pic 9(9) value 000030200.
            05 ar-ele-name-ver-09         pic 9(9) value 000030200.
            05 ar-ele-name-ver-10         pic 9(9) value 000030200.
          03 ar-ele-vet-ver redefines ar-ele-name-version
                        occurs 10 times pic 9(9).
      **                
      *
       01       array-retcode-epilog-gr05.
          03    ar-retcode-ele occurs 10 times.
           05   ar-tst-name           pic x(11).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
      *
       77   ntype               BINARY-LONG .
       77   nver                pic 9(9) .
       77   cmd-go              pic x(80) value space.
       
      *-------------------------------------------------------*
       procedure division.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
           display '*===============================================*'
           display ' GCSort test environment ' gcsort-tests-ver
           display '*===============================================*'
           display '*===============================================*'
           display '  gctestrun       Running test ....'
           display '*===============================================*'
           call 'gctestgetop' using ntype, nver
           display ' Environment : ' ntype 
           display ' Version     : ' nver 

      *
           perform exec-all-gr varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *     
           perform epilog-gr05 
           perform epilog-calculate-gr05
           .
       end-99.
           goback.
           
      * 
      *
      *---------------------------------------------------------*
       exec-all-gr                section.
      *---------------------------------------------------------*
       exal-00.
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform exec-test-modules
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   End "
           display '*===============================================*'
           .
       exal-99.
           exit.       
      **
      * 
      *---------------------------------------------------------*
       epilog-gr05                section.
      *---------------------------------------------------------*
       eprt-00.
      * 
           display '------------------------------------------------'
           display '|   Test id      |      retcode     |  status  |'
           display '------------------------------------------------'
      
           perform epilog-view-gr05 
               varying idx from 1 by 1
                  until idx > ar-name-max-ele

           display '------------------------------------------------'
           . 
       eprt-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-view-gr05           section.
      *---------------------------------------------------------*
       epvw-00.
           if (ar-tst-rtc01(idx) = 98) 
                add zero to retcode-sum
           else
                add ar-tst-rtc01(idx) to retcode-sum
           end-if     
           if (ar-tst-rtc01(idx) = zero) 
              move "   OK    "    to status-test
           else 
                 if (ar-tst-rtc01(idx) = 98) 
                  move " Skipped "    to status-test
               else
                  move " ---> KO "    to status-test
               end-if
           end-if
           display "|   " ar-tst-name(idx)    " |    "
                          ar-tst-rtc01(idx)   "   | "
                          status-test         "|"
           .
       epvw-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-calculate-gr05      section.
      *---------------------------------------------------------*
       epca-00.
           if  retcode-sum = zero
               display '=================================='
                       '====='
               display '=====   T E S T    P A S S E D    '
                       '====='
               display '=================================='
                       '====='
           else
               display '=================================='
                       '====='
               display '=====   T E S T    F A I L E D    '
                       '====='
               display '=================================='
                       '====='
           end-if
           .
       epca-99.
           exit.
      *
      *---------------------------------------------------------*
       set-value-env             section.
      *---------------------------------------------------------*
       sv-00.
Win        if (ntype = 1)
              inspect env-set-value replacing all chrsl by chrbs
           end-if
	       display env-set-name  upon ENVIRONMENT-NAME
            move zero to numchars1
            inspect env-set-name tallying numchars1
                    for characters before initial space
            move zero to numchars2
            inspect env-set-value tallying numchars2
                    for characters before initial space

           display env-set-value upon ENVIRONMENT-VALUE          
           if ( env-set-value not equal space )
             if (ntype = 1)
               display 'set 'env-set-name(1:numchars1) '=' 
                       env-set-value(1:numchars2)
             else
               display 'export 'env-set-name(1:numchars1) '=' 
                       env-set-value(1:numchars2)             
           end-if   
           .
       sv-99.
           exit.

      *
      *---------------------------------------------------------*
       exec-test-modules         section.
      *---------------------------------------------------------*
       gein-00.
           if (ar-ele-vet-ver(idx) > nver)
                move 98 to ar-tst-rtc01(idx)
                go to gein-99
           end-if 
           move 99 to ar-tst-rtc01(idx) 
           move ar-ele-vet(idx)  to cmd-string
Win        if (ntype = 1)
               inspect cmd-string replacing all chrsl by chrbs
               move cmd-string to cmd-go
           else
Linux        if (ntype = 2) or (ntype = 3)  
                 move space to cmd-go
                 string './'   delimited by size 
                    cmd-string delimited by size
                          into cmd-go
TEST00***               display ' cmd:>' cmd-go  '<'
             else
                 display ' SYSTEM call problem '
                 goback
             end-if             
           end-if            
           call  'SYSTEM' using cmd-go
           move  RETURN-CODE  to ar-tst-rtc01(idx)           
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc01(idx) > 256)
                divide ar-tst-rtc01(idx) by 256
                giving ar-tst-rtc01(idx)
           end-if
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      * reset 
           .
       gein-99.
          exit.
      *---------------------------------------------------------*
