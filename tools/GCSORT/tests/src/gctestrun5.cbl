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
      *  cobc -x  -std=default -debug -Wall  -o gctestrun5 gctestrun5.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun5.
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
       77 wk-cmd-sort           pic x(12) value
                'gcsort take '.
       77 wk-dir-take           pic x(30) value
                '../takefile/sort/07-sumfields/'.
       77 wk-fcmd               pic x(128).
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
       01       array-retcode-epilog-gr05.
          03    ar-retcode-ele occurs 9 times.
           05   ar-tst-name           pic x(12).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
           05   ar-tst-rtc02          USAGE BINARY-LONG.
      *  array-name
       01    array-name.
          03 ar-name-max-ele        pic 99  value 9.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(12) value 'ssumsqfbi01 '.
            05 ar-ele-name-02         pic x(12) value 'ssumsqfbi03'.
            05 ar-ele-name-03         pic x(12) value 'ssumsqffi01'.
            05 ar-ele-name-04         pic x(12) value 'ssumsqffi03'.
            05 ar-ele-name-05         pic x(12) value 'ssumsqffl01'.
            05 ar-ele-name-06         pic x(12) value 'ssumsqfpd01'.
            05 ar-ele-name-07         pic x(12) value 'ssumsqfpd03'.
            05 ar-ele-name-08         pic x(12) value 'ssumsqfzd01'.
            05 ar-ele-name-09         pic x(12) value 'ssumsqfzd03'.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 9 times pic x(12).
      **          
      * rows for take file 
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 9.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      * 
            07 ar-ele-take-row-01001   pic x(12) value 'ssumsqfbi01 '.
            07 ar-ele-take-row-01002   pic x(12) value 'sqbi01'.
            07 ar-ele-take-row-01003   pic x(12) value 'iosqbi01 '.
                                      
            07 ar-ele-take-row-02001   pic x(12) value 'ssumsqfbi03'.
            07 ar-ele-take-row-02002   pic x(12) value 'sqbi03'.
            07 ar-ele-take-row-02003   pic x(12) value 'iosqbi03 '.
                                      
            07 ar-ele-take-row-03001   pic x(12) value 'ssumsqffi01'.
            07 ar-ele-take-row-03002   pic x(12) value 'sqfi01'.
            07 ar-ele-take-row-03003   pic x(12) value 'iosqfi01 '.
                                      
            07 ar-ele-take-row-04001   pic x(12) value 'ssumsqffi03'.
            07 ar-ele-take-row-04002   pic x(12) value 'sqfi03'.
            07 ar-ele-take-row-04003   pic x(12) value 'iosqfi03 '.
                                      
            07 ar-ele-take-row-05001   pic x(12) value 'ssumsqffl01'.
            07 ar-ele-take-row-05002   pic x(12) value 'sqfl01'.
            07 ar-ele-take-row-05003   pic x(12) value 'iosqfl01 '.
                                      
            07 ar-ele-take-row-06001   pic x(12) value 'ssumsqfpd01'.
            07 ar-ele-take-row-06002   pic x(12) value 'sqpd01'.
            07 ar-ele-take-row-06003   pic x(12) value 'iosqpd01 '.
                                      
            07 ar-ele-take-row-07001   pic x(12) value 'ssumsqfpd03'.
            07 ar-ele-take-row-07002   pic x(12) value 'sqpd03'.
            07 ar-ele-take-row-07003   pic x(12) value 'iosqpd03 '.
                                      
            07 ar-ele-take-row-08001   pic x(12) value 'ssumsqfzd01'.
            07 ar-ele-take-row-08002   pic x(12) value 'sqzd01'.
            07 ar-ele-take-row-08003   pic x(12) value 'iosqzd01 '.
                                      
            07 ar-ele-take-row-09001   pic x(12) value 'ssumsqfzd03'.
            07 ar-ele-take-row-09002   pic x(12) value 'sqzd03'.
            07 ar-ele-take-row-09003   pic x(12) value 'iosqzd03 '.
      *      
          03 filler redefines ar-ele-take-rows 
               occurs 9 times.
           05  ar-ele-take-vet.
            07 ar-ele-take-vet-name       pic x(12).                       ** name
            07 ar-ele-take-vet-set        pic x(12).                       ** set
            07 ar-ele-take-vet-pgm        pic x(12).                       ** pgm gen
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
           display '  gctestrun5           SORT '
           display '                       Group5 (Sum Fields)'
           display '*===============================================*'
           call 'gctestgetop' using ntype, nver
           display ' Environment : ' ntype 
           display ' Version     : ' nver 
      *
           perform exec-all-gr05 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *     
           perform epilog-gr05
           perform epilog-calculate-gr05
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
           
      * 
      *
      *---------------------------------------------------------*
       exec-all-gr05              section.
      *---------------------------------------------------------*
       exal-00.
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform genfile-input-gr05
           perform gcsort-gr05
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   End "
           display '*===============================================*'
           display '-------------------------------------------------'
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
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
           display '----------------------------------'
                   '------------------------------'
           display '|                |             retco'
                   'de              |          |'
           display '| Test id        |     cobol      |      gc'
                   'sort     |  status  |'
           display '----------------------------------'
                   '------------------------------'
      
           perform epilog-view-gr05 
               varying idx from 1 by 1
                  until idx > ar-name-max-ele

           display '----------------------------------'
                   '------------------------------'
           . 
       eprt-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-view-gr05           section.
      *---------------------------------------------------------*
       epvw-00.
           add ar-tst-rtc01(idx) to retcode-sum
           add ar-tst-rtc02(idx) to retcode-sum
           if (ar-tst-rtc01(idx) = zero) and
              (ar-tst-rtc02(idx) = zero) 
              move  "   OK    "   to status-test
           else
              move  " ---> KO "    to status-test
           end-if
           display "| " ar-tst-name(idx)    "   |  "
                        ar-tst-rtc01(idx)   "   |   "
                        ar-tst-rtc02(idx)   "   | "
                        status-test "|"
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
       genfile-input-gr05         section.
      *---------------------------------------------------------*
       gein-00.
           move  99  to ar-tst-rtc01(idx)           
           move ar-ele-take-vet-set(idx)   to env-set-name
           move space                      to env-set-value
           string '../files/'                   delimited by size
                    ar-ele-take-vet-set(idx)    delimited by space
                    into env-set-value
           perform set-value-env
           
           move ar-ele-take-vet-pgm(idx)  to cmd-string
Win            if (ntype = 1)
                   inspect cmd-string replacing all chrsl by chrbs
                   move cmd-string to cmd-go
              else
Linux           if (ntype = 2) or (ntype = 3)  
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
           display ' cmd line : '   cmd-go
           call     'SYSTEM' using  cmd-go
               move  RETURN-CODE  to ar-tst-rtc01(idx)           
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc01(idx) > 256)
                divide ar-tst-rtc01(idx) by 256
                giving ar-tst-rtc01(idx)
           end-if
      * reset 
           move ar-ele-take-vet-set(idx)   to env-set-name
           move space                      to env-set-value
           perform set-value-env
           .
       gein-99.
          exit.
      *---------------------------------------------------------*
       gcsort-gr05                section.
      *---------------------------------------------------------*
       stcb-00.
      ** 
           move  99  to ar-tst-rtc02(idx)           
      ** 
               move space                  to cmd-string
               string wk-cmd-sort                delimited by size
                      wk-dir-take                delimited by size
                      ar-ele-take-vet-name(idx)  delimited by space
                      '_take.prm'                delimited by size
                            into cmd-string
Win            if (ntype = 1)
                   inspect cmd-string replacing all chrsl by chrbs
                   move cmd-string to cmd-go
              else
Linux           if (ntype = 2) or (ntype = 3)  
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
               display  "cmd-string : " cmd-go
               call "SYSTEM" using      cmd-go
               move  RETURN-CODE  to ar-tst-rtc02(idx)           
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc02(idx) > 256)
                divide ar-tst-rtc02(idx) by 256
                giving ar-tst-rtc02(idx)
           end-if
               if (ar-tst-rtc02(idx)  = 4)
                 move zero to ar-tst-rtc02(idx)
                 display ' Force zero to retcode - There is a warning.'
               end-if
      D        display  "RETURN-CODE Value : " RETURN-CODE
      ** 
           .
       stcb-99.
           exit.
      *
