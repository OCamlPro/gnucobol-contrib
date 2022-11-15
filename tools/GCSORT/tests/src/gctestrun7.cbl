      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     2022 
      * LICENSE
      *  Copyright (c) 2022 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  run test script for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestrun7 gctestrun7.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun7.
       environment division.
       input-output section.
       file-control.
           select fcmd assign to wk-fcmd
           organization is line sequential
           file status is f-s.
       data division.
       file section.
       fd  fcmd.
       01  r-cmd        pic x(1024).
       working-storage section.
       77 numchars1             pic 9(3).
       77 numchars2             pic 9(3).
       77 chrsl                 pic x value '/'.
       77 chrbs                 pic x value '\'.
       77 wk-fcmd               pic x(128).
       77 f-s                   pic xx.
	   01 cmd-string            pic x(250).
       01 env-set-name          pic x(25).
       01 env-set-value         pic x(1024).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
      *
       77 idx                   pic 9(3).
       77 idx-take              pic 9(3).
       77 status-test           pic x(9).
       77 retcode-sum           pic 9(10) value zero.
      *
       01       array-retcode-epilog-gr01.
          03    ar-retcode-ele occurs 5 times.
           05   ar-tst-name           pic x(10).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
           05   ar-tst-rtc02          USAGE BINARY-LONG.
           05   ar-tst-rtc03          USAGE BINARY-LONG.
      *  array-type elaboration
       01    array-name-type-elab.
          03   ar-ntelab.
           05  ar-t-elab-01          pic 9 value zero.       
           05  ar-t-elab-02          pic 9 value zero.       
           05  ar-t-elab-03          pic 9 value 1.       
           05  ar-t-elab-04          pic 9 value 1.       
           05  ar-t-elab-05          pic 9 value 2.    
          03   ar-nte redefines ar-ntelab
                    occurs 5 times pic 9.
      *  array-name
       01    array-name.
          03 ar-name-max-ele        pic 99  value 3.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(10) value 'frsqt01   '.
            05 ar-ele-name-02         pic x(10) value 'frsqt02   '.
            05 ar-ele-name-03         pic x(10) value 'frsqt03   '.
            05 ar-ele-name-05         pic x(10) value '          '.
            05 ar-ele-name-04         pic x(10) value '          '.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 05 times pic x(10).
      *    
       01  array-pgm-diff.
          03 ar-pgm-name.
            05 ar-pgm-name-01         pic x(10) value 'diffiletxt'.
            05 ar-pgm-name-02         pic x(10) value 'diffiletxt'.
            05 ar-pgm-name-03         pic x(10) value 'diffiletxt'.
            05 ar-pgm-name-04         pic x(10) value '        '.
            05 ar-pgm-name-05         pic x(10) value '        '.
          03 ar-ele-vetdiff redefines ar-pgm-name
                        occurs 5 times pic x(10).
      *
      **          
      * rows for take file      
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 30.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      * 5
            07 ar-ele-take-row-01001      pic x(10) value 'frsqt01   '.
            07 ar-ele-take-row-01002      pic x(52) value  
             ' SORT FIELDS=(1,15,CH,D)                          '.
            07 ar-ele-take-row-01003      pic x(10) value 'frsqt01   '.
            07 ar-ele-take-row-01004      pic x(52) value  
             ' USE  dd_infile   RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-01005      pic x(10) value 'frsqt01   '.
            07 ar-ele-take-row-01006      pic x(52) value  
             ' GIVE dd_outfile  RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-01007      pic x(10) value 'frsqt01   '.
            07 ar-ele-take-row-01008      pic x(52) value  
             ' OUTREC FINDREP IN=C''xyz'', OUT=C''ABC''          '.
            07 ar-ele-take-row-01009      pic x(10) value  space.
            07 ar-ele-take-row-01010      pic x(52) value  space.

      * 5
            07 ar-ele-take-row-02001      pic x(10) value 'frsqt02   '.
            07 ar-ele-take-row-02002      pic x(52) value  
             ' SORT FIELDS=(1,15,CH,D)                          '.
            07 ar-ele-take-row-02003      pic x(10) value 'frsqt02   '.
            07 ar-ele-take-row-02004      pic x(52) value  
             ' USE  dd_infile   RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-02005      pic x(10) value 'frsqt02   '.
            07 ar-ele-take-row-02006      pic x(52) value  
             ' GIVE dd_outfile  RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-02007      pic x(10) value 'frsqt02   '.
            07 ar-ele-take-row-02008      pic x(52) value  
             ' OUTREC FINDREP IN=C''ZSWF'', OUT=C''9876''          '.
            07 ar-ele-take-row-02009      pic x(10) value  space.
            07 ar-ele-take-row-02010      pic x(52) value  space.      
      * 5
            07 ar-ele-take-row-03001      pic x(10) value 'frsqt03   '.
            07 ar-ele-take-row-03002      pic x(52) value  
             ' SORT FIELDS=(1,15,CH,D)                          '.
            07 ar-ele-take-row-03003      pic x(10) value 'frsqt03   '.
            07 ar-ele-take-row-03004      pic x(52) value  
             ' USE  dd_infile   RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-03005      pic x(10) value 'frsqt03   '.
            07 ar-ele-take-row-03006      pic x(52) value  
             ' GIVE dd_outfile  RECORD F,100 ORG LSF             '.
            07 ar-ele-take-row-03007      pic x(10) value 'frsqt03   '.
            07 ar-ele-take-row-03008      pic x(52) value  
             ' OUTREC FINDREP INOUT=(C''K541'',C''145K'')        '.
            07 ar-ele-take-row-03009      pic x(10) value  space.
            07 ar-ele-take-row-03010      pic x(52) value  space.      
      *
          03 filler redefines ar-ele-take-rows 
               occurs 15 times.
           05  ar-ele-take-vet.
      ** name     
            07 ar-ele-take-vet-01         pic x(10).                       
      ** value of takefile      
            07 ar-ele-take-vet-02         pic x(52).                       
            
      **
          
       77   ntype               BINARY-LONG .
       77   cmd-go              pic x(80) value space.
           
      *-------------------------------------------------------*
       procedure division.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
      *** debug                   display "display 00000000000000"
      *** debug                   perform display-takefile-gr07


           display '*===============================================*'
           display ' GCSort test environment ' gcsort-tests-ver
           display '*===============================================*'
           display '*===============================================*'
           display '  gctestrun7           SORT'
           display '                       Group2'
           display '*===============================================*'
           call 'gctestgetop' using ntype    
           display ' Environment : ' ntype 
           
      *
           perform exec-all-gr07 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *
           perform epilog-gr07
           perform epilog-calculate-gr07
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
      *
      *---------------------------------------------------------*
       exec-all-gr07              section.
      *---------------------------------------------------------*
       exal-00.
      *** debug         
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform genfile-input-gr07
           perform sort-cbl-gr07a
           perform sort-gc-gr07
debug *         perform display-takefile-gr07
           perform diffile-gr07a
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  '   End '
           display '*===============================================*'
           display '-------------------------------------------------'
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           .
       exal-99.
           exit.       
      **
      * 
      *---------------------------------------------------------*
       epilog-gr07                section.
      *---------------------------------------------------------*
       eprt-00.
      *    display " Test id : " ar-tst-name(idx)  " "
      *            " retcode cobol : " ar-tst-rtc01(idx)
      *            " gcort : "         ar-tst-rtc02(idx)
      *            " diffile : "       ar-tst-rtc03(idx)
      *            "   " status-test
      *
           display '----------------------------------'
                '----------------------------------'
                '--------------'
           display '|              |                    '
                'retcode                           |          |'
                   
           display '| Test id      |     cobol      | '
                '     gcsort     |     diffil'
                'e       |  status  |'
           display '----------------------------------'
                '----------------------------------'
                '--------------'
      
           perform epilog-view-gr07 
               varying idx from 1 by 1
                  until idx > ar-name-max-ele

           display '----------------------------------'
                '----------------------------------'
                '--------------'
           . 
       eprt-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-view-gr07           section.
      *---------------------------------------------------------*
       epvw-00.
           add ar-tst-rtc01(idx) to retcode-sum
           add ar-tst-rtc02(idx) to retcode-sum
           add ar-tst-rtc03(idx) to retcode-sum
           if (ar-tst-rtc01(idx) = zero) and
              (ar-tst-rtc02(idx) = zero) and
              (ar-tst-rtc03(idx) = zero)
              move  "   OK    "   to status-test
           else
              move  " ---> KO "    to status-test
           end-if
           display "| " ar-tst-name(idx)    "   |  "
                        ar-tst-rtc01(idx)   "   |   "
                        ar-tst-rtc02(idx)   "   |   "
                        ar-tst-rtc03(idx)   "     | " 
                        status-test "|"
      *    display " Test id : " ar-tst-name(idx)  " "
      *            " retcode cobol : " ar-tst-rtc01(idx)
      *            " gcort : "         ar-tst-rtc02(idx)
      *            " diffile : "       ar-tst-rtc03(idx)
      *            "   " status-test
           .
       epvw-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-calculate-gr07      section.
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
       genfile-input-gr07         section.
      *---------------------------------------------------------*
       gein-00.
           move space                   to cmd-string
           move 'dd_outfile'            to env-set-name
           move '../files/frsqr01.txt'  to env-set-value
           perform set-value-env
           move 'iofrs01' to cmd-string
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
      D    display ' cmd line : '  cmd-go
           call     'SYSTEM' using cmd-go
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      * reset 
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       gein-99.
          exit.
      *
      *---------------------------------------------------------*
       sort-cbl-gr07a             section.
      *---------------------------------------------------------*
       stcb-00.
      ***     move 99  to ar-tst-rtc01(idx-take)  
           move 99  to ar-tst-rtc01(idx)  
      ** set dd_infile=%filedir%\frsqr01.txt
           move 'dd_infile'              to env-set-name
           move '../files/frsqr01.txt'    to env-set-value
           perform set-value-env
      ** 
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                 '_cbl01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_sortwork'            to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                 '_srt01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** 
      *******     move 'susesqf01b '       to       cmd-string
           move space               to cmd-string
           string ar-ele-vet(idx) delimited by space
                  into cmd-string
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
           display ' cmd line : ' cmd-go(1:80)
           call 'SYSTEM' using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc01(idx)
      D    display  "RETURN-CODE Value : " RETURN-CODE
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc01(idx) > 256)
                divide ar-tst-rtc01(idx) by 256
                giving ar-tst-rtc01(idx)
           end-if
      * reset 
           move 'dd_infile'      to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_sortwork'    to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       stcb-99.
           exit.
      *
      *
      *
      *---------------------------------------------------------*
       sort-gc-gr07               section.
      *---------------------------------------------------------*
       stgc-00.
           move 99  to ar-tst-rtc02(idx)  
      ** set dd_infile=%filedir%\frsqr01.txt 
           move 'dd_infile'              to env-set-name
           move '../files/frsqr01.txt'   to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\susesqf01_gcs.srt
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                 '_gcs01.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *     
      D     display 'env-set-value ' env-set-value
      **--*          
           move space                to wk-fcmd
           string '../takefile/tmp/'    delimited by size
                  ar-ele-vet(idx) delimited by space
                  '.prm'    delimited by size
                    into wk-fcmd
           open output fcmd
           if f-s not equal '00' 
              display 'Error on open output file: ' wk-fcmd
                   ' element : ' ar-ele-vet(idx) 
              move 25  to RETURN-CODE
              goback
           end-if
      *    
           perform write-takefile-gr07 
           close fcmd
      ** 
           move space              to cmd-string
           string  'gcsort TAKE ../takefile/tmp/'
                                  delimited by size
                   ar-ele-vet(idx)  delimited by space
                '.prm'         delimited by size
                      into cmd-string
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
           display ' cmd line : '  cmd-go
           call     'SYSTEM' using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc02(idx)
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc02(idx) > 256)
                divide ar-tst-rtc02(idx) by 256
                giving ar-tst-rtc02(idx)
           end-if
      * reset 
           move 'dd_infile'     to env-set-name
           move space           to env-set-value
           perform set-value-env
           move 'dd_outfile'     to env-set-name
           move space           to env-set-value
           perform set-value-env
           .
       stgc-99.
          exit.
      *
      *---------------------------------------------------------*
       display-takefile-gr07        section.
      *---------------------------------------------------------*
       disp-00.
           perform display-takerecord-gr07 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       disp-99.
           exit.
      * 
      *---------------------------------------------------------*
       display-takerecord-gr07      section. 
      *---------------------------------------------------------*
       dstr-00.
            display "ar-ele-take-vet-01(idx-take) >" 
                     ar-ele-take-vet-01(idx-take) "<"
                    "ar-ele-take-vet-02(idx-take) >"
                     ar-ele-take-vet-02(idx-take) "<"
           .
       dstr-99.
           exit.
      *
      *---------------------------------------------------------*
       write-takefile-gr07        section.
      *---------------------------------------------------------*
       wrta-00.
           perform write-takerecord-gr07 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       wrta-99.
           exit.
      * 
      *---------------------------------------------------------*
       write-takerecord-gr07      section. 
      *---------------------------------------------------------*
       wrtr-00.
debug *       display "ar-ele-take-vet-01(idx-take) >" 
debug *                ar-ele-take-vet-01(idx-take) "<"
debug *                "ar-ele-vet(idx) > " ar-ele-vet(idx) "<"
           if(ar-ele-take-vet-01(idx-take) = ar-ele-vet(idx))
              move space to r-cmd
              move ar-ele-take-vet-02(idx-take)  to r-cmd
              write r-cmd
debug *      display "r-cmd = " r-cmd
           .
       wrtr-99.
           exit.
      *---------------------------------------------------------*
       diffile-gr07a              section.
      *---------------------------------------------------------*
       diff-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\susesqf01_cbl.srt
           move 'dd_incobol'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                 '_cbl01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/susesqf01_gcs.srt
           move 'dd_ingcsort'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                 '_gcs01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%\diffile
           move ar-ele-vetdiff(idx)    to cmd-string
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
           display ' cmd line : '   cmd-go
           call     "SYSTEM" using  cmd-go
           move  RETURN-CODE  to ar-tst-rtc03(idx)
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc03(idx) > 256)
                divide ar-tst-rtc03(idx) by 256
                giving ar-tst-rtc03(idx)
           end-if
      *
      D    display  "RETURN-CODE Value : " RETURN-CODE
      ** set rtc2=%errorlevel%
      * reset 
      ** set dd_incobol=
           move 'dd_incobol'      to env-set-name
           move space             to env-set-value
           perform set-value-env
      ** set dd_ingcsort=
           move 'dd_ingcsort'     to env-set-name
           move space             to env-set-value
           perform set-value-env
          .
       diff-99.
          exit.
      *
       
      ****************************************************************
      *
      *
      ****************************************************************
