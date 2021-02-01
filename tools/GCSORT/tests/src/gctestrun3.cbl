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
      *  cobc -x  -std=default -debug -Wall  -o gctestrun3 gctestrun3.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun3.
       environment division.
       input-output section.
       file-control.
       data division.
       file section.
       working-storage section.
       77 chrsl                 pic x value '/'.
       77 chrbs                 pic x value '\'.
       77 wk-cmd-sort           pic x(12) value
                'gcsort take '.
       77 wk-dir-take           pic x(12) value
                '../takefile/'.
       77 wk-fcmd               pic x(128).
	   01 cmd-string            pic x(250).
       01 cmd-string-tmp        pic x(250).
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
      *
       77 retcode-sum           pic 9(10) value zero.
       77 test-id               pic x(15).    
       77 idx                   pic 9(3).
       77 idx-take              pic 9(3).
       77 idx-err               pic 9(3) value zero.
       77 status-test           pic x(9).
      *
      *
       01       array-retcode-epilog-gr03.
          03    ar-retcode-ele occurs 49 times.
           05   ar-tst-name           pic x(15).
           05   ar-tst-rtc01          pic 99.
      
      ***
       01  ele-cmd-take-group.
           05 ele-cmd-take-exec-num       pic 9(3) value 49.
           05 ele-cmd-take-exec.
              07 ele-cmd-take-exec001 pic x(15) value 'susesqvmlt01'.
              07 ele-cmd-take-exec002 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec003 pic x(80) value 
                    'sort/01-use/susesqvmlt01_take.prm   '.
      *
              07 ele-cmd-take-exec004 pic x(15) value 'susesqvmlt02'.
              07 ele-cmd-take-exec005 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec006 pic x(80) value 
                    'sort/01-use/susesqvmlt02_take.prm   '.
      *
              07 ele-cmd-take-exec007 pic x(15) value 'susesqvmlt03'.
              07 ele-cmd-take-exec008 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec009 pic x(80) value 
                    'sort/01-use/susesqvmlt03_take.prm   '.
      *
              07 ele-cmd-take-exec010 pic x(15) value 'sftsqfbi01  '.
              07 ele-cmd-take-exec011 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec012 pic x(80) value 
                    'sort/02-formattype/sftsqfbi01_take.prm'.
      *
              07 ele-cmd-take-exec013 pic x(15) value 'sftsqfbi03  '.
              07 ele-cmd-take-exec014 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec015 pic x(80) value 
                    'sort/02-formattype/sftsqfbi03_take.prm'.
      *
              07 ele-cmd-take-exec016 pic x(15) value 'sftsqffl01  '.
              07 ele-cmd-take-exec017 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec018 pic x(80) value 
                    'sort/02-formattype/sftsqffl01_take.prm'.
      *
              07 ele-cmd-take-exec019 pic x(15) value 'sftsqfpd01  '.
              07 ele-cmd-take-exec020 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec021 pic x(80) value 
                    'sort/02-formattype/sftsqfpd01_take.prm'.
      *
              07 ele-cmd-take-exec022 pic x(15) value 'sftsqfpd03  '.
              07 ele-cmd-take-exec023 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec024 pic x(80) value 
                    'sort/02-formattype/sftsqfpd03_take.prm'.
      *
              07 ele-cmd-take-exec025 pic x(15) value 'sftsqfzd01  '.
              07 ele-cmd-take-exec026 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec027 pic x(80) value 
                    'sort/02-formattype/sftsqfzd01_take.prm'.
      *
              07 ele-cmd-take-exec028 pic x(15) value 'sftsqfzd03  '.
              07 ele-cmd-take-exec029 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec030 pic x(80) value 
                    'sort/02-formattype/sftsqfzd03_take.prm'.
      *
              07 ele-cmd-take-exec031 pic x(15) value 'sflbifbi01  '.
              07 ele-cmd-take-exec032 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec033 pic x(80) value 
                    'sort/03-filetype/sflbifbi01_take.prm'.
      *
              07 ele-cmd-take-exec034 pic x(15) value 'sflixlsix01 '.
              07 ele-cmd-take-exec035 pic x(08) value 'setvar  '.
              07 ele-cmd-take-exec036 pic x(80) value 
                    'inp002ix'.
      *
              07 ele-cmd-take-exec037 pic x(15) value 'sflixlsix01 '.
              07 ele-cmd-take-exec038 pic x(08) value 'setval  '.
              07 ele-cmd-take-exec039 pic x(80) value 
                    '../files/inp002ix'.
      *
              07 ele-cmd-take-exec040 pic x(15) value 'sflixlsix01 '.
              07 ele-cmd-take-exec041 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec042 pic x(80) value 
                    'sort/03-filetype/sflixlsix01_take.prm '.
      *
              07 ele-cmd-take-exec043 pic x(15) value 'sflixixsq02 '.
              07 ele-cmd-take-exec044 pic x(08) value 'setvar  '.
              07 ele-cmd-take-exec045 pic x(80) value 
                    'inp002ix'.
      *
              07 ele-cmd-take-exec046 pic x(15) value 'sflixixsq02 '.
              07 ele-cmd-take-exec047 pic x(08) value 'setval  '.
              07 ele-cmd-take-exec048 pic x(80) value 
                    '../files/inp002ix'.
      *
              07 ele-cmd-take-exec049 pic x(15) value 'sflixixsq02 '.
              07 ele-cmd-take-exec050 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec051 pic x(80) value 
                    'sort/03-filetype/sflixixsq02_take.prm '.
      *
              07 ele-cmd-take-exec052 pic x(15) value 'sflixsqls03 '.
              07 ele-cmd-take-exec053 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec054 pic x(80) value 
                    'sort/03-filetype/sflixsqls03_take.prm '.
      *
              07 ele-cmd-take-exec055 pic x(15) value 'sflrllsrl01 '.
              07 ele-cmd-take-exec056 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec057 pic x(80) value 
                    'sort/03-filetype/sflrllsrl01_take.prm '.
      *
              07 ele-cmd-take-exec058 pic x(15) value 'sflrlrlsq02 '.
              07 ele-cmd-take-exec059 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec060 pic x(80) value 
                    'sort/03-filetype/sflrlrlsq02_take.prm '.
      *
              07 ele-cmd-take-exec061 pic x(15) value 'sflrlsqls03 '.
              07 ele-cmd-take-exec062 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec063 pic x(80) value 
                    'sort/03-filetype/sflrlsqls03_take.prm '.
      *
              07 ele-cmd-take-exec064 pic x(15) value 'sincsqfch01 '.
              07 ele-cmd-take-exec065 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec066 pic x(80) value 
                    'sort/04-include/sincsqfch01_take.prm'.
      *
              07 ele-cmd-take-exec067 pic x(15) value 'sincsqfbi01 '.
              07 ele-cmd-take-exec068 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec069 pic x(80) value 
                    'sort/04-include/sincsqfbi01_take.prm'.
      *
              07 ele-cmd-take-exec070 pic x(15) value 'sincsqffi01 '.
              07 ele-cmd-take-exec071 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec072 pic x(80) value 
                    'sort/04-include/sincsqffi01_take.prm'.
      *
              07 ele-cmd-take-exec073 pic x(15) value 'sincsqffl01 '.
              07 ele-cmd-take-exec074 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec075 pic x(80) value 
                    'sort/04-include/sincsqffl01_take.prm'.
      *
              07 ele-cmd-take-exec076 pic x(15) value 'sincsqfpd01 '.
              07 ele-cmd-take-exec077 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec078 pic x(80) value 
                    'sort/04-include/sincsqfpd01_take.prm'.
      *
              07 ele-cmd-take-exec079 pic x(15) value 'sincsqfzd01 '.
              07 ele-cmd-take-exec080 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec081 pic x(80) value 
                    'sort/04-include/sincsqfzd01_take.prm'.
      *
              07 ele-cmd-take-exec082 pic x(15) value 'sincsqfmlt03'.
              07 ele-cmd-take-exec083 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec084 pic x(80) value 
                    'sort/04-include/sincsqfmlt03_take.prm '.
      *
              07 ele-cmd-take-exec085 pic x(15) value 'somisqfch01 '.
              07 ele-cmd-take-exec086 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec087 pic x(80) value 
                    'sort/05-omit/somisqfch01_take.prm   '.
      *
              07 ele-cmd-take-exec088 pic x(15) value 'somisqfbi01 '.
              07 ele-cmd-take-exec089 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec090 pic x(80) value 
                    'sort/05-omit/somisqfbi01_take.prm   '.
      *
              07 ele-cmd-take-exec091 pic x(15) value 'somisqffi01 '.
              07 ele-cmd-take-exec092 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec093 pic x(80) value 
                    'sort/05-omit/somisqffi01_take.prm   '.
      *
              07 ele-cmd-take-exec094 pic x(15) value 'somisqffl01 '.
              07 ele-cmd-take-exec095 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec096 pic x(80) value 
                    'sort/05-omit/somisqffl01_take.prm   '.
      *
              07 ele-cmd-take-exec097 pic x(15) value 'somisqfpd01 '.
              07 ele-cmd-take-exec098 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec099 pic x(80) value 
                    'sort/05-omit/somisqfpd01_take.prm   '.
      *
              07 ele-cmd-take-exec100 pic x(15) value 'somisqfzd01 '.
              07 ele-cmd-take-exec101 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec102 pic x(80) value 
                    'sort/05-omit/somisqfzd01_take.prm   '.
      *
              07 ele-cmd-take-exec103 pic x(15) value 'somisqfmlt03'.
              07 ele-cmd-take-exec104 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec105 pic x(80) value 
                    'sort/05-omit/somisqfmlt03_take.prm  '.
      *
              07 ele-cmd-take-exec106 pic x(15) value 'sinrsqfch01 '.
              07 ele-cmd-take-exec107 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec108 pic x(80) value 
                    'sort/06-inrec/sinrsqfch01_take.prm  '.
      *
              07 ele-cmd-take-exec109 pic x(15) value 'sinrsqfmlt01'.
              07 ele-cmd-take-exec110 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec111 pic x(80) value 
                    'sort/06-inrec/sinrsqfmlt01_take.prm '.
      *
              07 ele-cmd-take-exec112 pic x(15) value 'sinrsqfmlt05'.
              07 ele-cmd-take-exec113 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec114 pic x(80) value 
                    'sort/06-inrec/sinrsqfmlt05_take.prm '.
      *
              07 ele-cmd-take-exec115 pic x(15) value 'soutsqfch01 '.
              07 ele-cmd-take-exec116 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec117 pic x(80) value 
                    'sort/08-outrec/soutsqfch01_take.prm '.
      *
              07 ele-cmd-take-exec118 pic x(15) value 'soptsqfmlt06'.
              07 ele-cmd-take-exec119 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec120 pic x(80) value 
                    'sort/09-option/soptsqfmlt06_take.prm'.
      *
              07 ele-cmd-take-exec121 pic x(15) value 'soutfsqfmlt01 '.
              07 ele-cmd-take-exec122 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec123 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt01_take.prm '.
      *
              07 ele-cmd-take-exec124 pic x(15) value 'soutfsqfmlt02 '.
              07 ele-cmd-take-exec125 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec126 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt02_take.prm '.
      *
              07 ele-cmd-take-exec127 pic x(15) value 'soutfsqfmlt03 '.
              07 ele-cmd-take-exec128 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec129 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt03_take.prm '.
      *
              07 ele-cmd-take-exec130 pic x(15) value 'soutfsqfmlt04 '.
              07 ele-cmd-take-exec131 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec132 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt04_take.prm '.
      *
              07 ele-cmd-take-exec133 pic x(15) value 'soutfsqfmlt05 '.
              07 ele-cmd-take-exec134 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec135 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt05_take.prm '.
      *
              07 ele-cmd-take-exec136 pic x(15) value 'soutfsqfmlt06 '.
              07 ele-cmd-take-exec137 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec138 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt06_take.prm '.
      *
              07 ele-cmd-take-exec139 pic x(15) value 'soutfsqfmlt07 '.
              07 ele-cmd-take-exec140 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec141 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt07_take.prm '.
      *
              07 ele-cmd-take-exec142 pic x(15) value 'soutfsqfmlt08 '.
              07 ele-cmd-take-exec143 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec144 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt08_take.prm '.
      *
              07 ele-cmd-take-exec145 pic x(15) value 'soutfsqfmlt09 '.
              07 ele-cmd-take-exec146 pic x(08) value 'gcsort  '.
              07 ele-cmd-take-exec147 pic x(80) value 
                    'sort/10-outfil/soutfsqfmlt09_take.prm '.
      *
            05 ele-cmd-take-exec-vet redefines ele-cmd-take-exec
                     occurs 49 times.
              07 ele-cmd-take-exec-id       pic x(15).
              07 ele-cmd-take-exec-type     pic x(08).
              07 ele-cmd-take-exec-cmd      pic x(80).
      ***
       77   ntype               BINARY-LONG .
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
           display '  gctestrun3           SORT'
           display '                       Group3'
           display '*===============================================*'
           call 'gctestgetop' using ntype    
           display ' Environment : ' ntype 

      *
           perform exec-all-gr03
                varying idx from 1 by 1
                    until idx > ele-cmd-take-exec-num
      *     
           perform epilog-gr03
           perform epilog-calculate-gr03
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if       
           .
       end-99.
           goback.
      *
      * 
      *---------------------------------------------------------*
       epilog-gr03                section.
      *---------------------------------------------------------*
       eprt-00.
           display '----------------------------------'
                   '---------'
           display '|                   | '
                   'retcode |'
                   '           |'
           display '| Test id           | ' 
                   'gcsort  |'         
                   '   status  |' 
           display '----------------------------------'
                   '---------'
           perform epilog-view-gr03 
               varying idx from 1 by 1
                  until idx > ele-cmd-take-exec-num

           display '----------------------------------'
                   '---------'
           . 
       eprt-99.
           exit.
      * 
      * 
      *---------------------------------------------------------*
       epilog-view-gr03           section.
      *---------------------------------------------------------*
       epvw-00.
           if (ar-tst-rtc01(idx) = zero) 
              move " Test OK "   to status-test
           else
              move " Test KO "   to status-test
           end-if
           display "| " ar-tst-name(idx)    "   |    "
                        ar-tst-rtc01(idx)   "   | "
                        status-test " |"
           add ar-tst-rtc01(idx) to retcode-sum
           .
       epvw-99.
           exit.
      * 
      * 
      *---------------------------------------------------------*
       epilog-calculate-gr03      section.
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
           display env-set-value upon ENVIRONMENT-VALUE          
           if ( env-set-value not equal space )
               display '****************************************'           
               display env-set-name '=' env-set-value          
               display '****************************************'           
           end-if    
           .
       sv-99.
           exit.
      *
      *---------------------------------------------------------*
       exec-all-gr03              section.
      *---------------------------------------------------------*
       exal-00.
           if (ele-cmd-take-exec-type(idx) = 'gcsort  ')
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
            display '*===============================================*'
            display ' ID test : ' ele-cmd-take-exec-id(idx)  '   Start '
            display '*===============================================*'
           end-if
           move ele-cmd-take-exec-id(idx)    to test-id
           perform get-cmd-row 
             varying idx-take
                 from 1 by 1 until (idx-take > ele-cmd-take-exec-num) 
           if (ele-cmd-take-exec-type(idx) = 'gcsort  ')
            display '*===============================================*'
            display ' ID test : ' ele-cmd-take-exec-id(idx)  '   End '
            display '*===============================================*'
           display '-------------------------------------------------'
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           end-if
           .
       exal-99.
           exit.       
      **
      *
      *---------------------------------------------------------*
       get-cmd-row               section.
      *---------------------------------------------------------*
       gtcm-00.
           if ele-cmd-take-exec-id(idx-take) = test-id
                perform exec-cmd-row
           end-if
           .
       gtcm-99.
           exit.
      *
      *---------------------------------------------------------*
       exec-cmd-row               section.
      *---------------------------------------------------------*
       excm-00.
 
           if (ele-cmd-take-exec-type(idx-take) = 'setvar  ')
               move ele-cmd-take-exec-cmd(idx-take)  to cmd-string-tmp
           end-if
           if (ele-cmd-take-exec-type(idx-take) = 'setval  ')
               move cmd-string-tmp             to env-set-name                     
               move ele-cmd-take-exec-cmd(idx-take) to env-set-value  
               perform set-value-env
           end-if
           if (ele-cmd-take-exec-type(idx-take) = 'gcsort  ')
               add  1  to idx-err 
               move ele-cmd-take-exec-id(idx-take) 
                       to ar-tst-name(idx-err)
               move 99  to ar-tst-rtc01(idx-err) 
               move space                  to cmd-string
               string wk-cmd-sort                delimited by size
                      wk-dir-take                delimited by size
                      ele-cmd-take-exec-cmd(idx-take) delimited by space
                            into cmd-string
      D        display  "cmd-string : " cmd-string
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
               display ' cmd line : ' cmd-go
               call "SYSTEM" using    cmd-go
               move  RETURN-CODE  to ar-tst-rtc01(idx-err)  
               display 'ar-tst-rtc01(idx-err)  ' ar-tst-rtc01(idx-err)
               if (ar-tst-rtc01(idx-err)  = 4)
                 move zero to ar-tst-rtc01(idx-err)
                 display ' Forced zero to retcode - There is a warning.'
               end-if
      D        display  "RETURN-CODE Value : " RETURN-CODE
TEST00**               CALL "CBL_OC_NANOSLEEP" USING 1000000000               
           end-if
           .
       excm-99.
           exit.
