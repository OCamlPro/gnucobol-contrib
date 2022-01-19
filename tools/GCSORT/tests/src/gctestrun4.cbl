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
      *  cobc -x  -std=default -debug -Wall  -o gctestrun4 gctestrun4.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun4.
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
       01 env-set-value         pic x(250).
       01 gcsort-tests-ver      pic x(20) value ' version 1.0'.
      *
       77 idx                   pic 9(3).
       77 idx-take              pic 9(3).
       77 status-test           pic x(9).
       77 retcode-sum           pic 9(10) value zero.
      *
       01       array-retcode-epilog-gr04.
          03    ar-retcode-ele occurs 4 times.
           05   ar-tst-name           pic x(10).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
           05   ar-tst-rtc02          USAGE BINARY-LONG.
           05   ar-tst-rtc03          USAGE BINARY-LONG.
      *  array-name
       01    array-name.
          03 ar-name-max-ele        pic 99  value 4.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(10) value 'musesqf01 '.
            05 ar-ele-name-02         pic x(10) value 'musesqf02 '.
            05 ar-ele-name-03         pic x(10) value 'musesqf03 '.
            05 ar-ele-name-04         pic x(10) value 'moutsqf10 '.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 4 times pic x(10).
       01  array-pgm-diff.
          03 ar-pgm-name.
            05 ar-pgm-name-01         pic x(10) value 'diffile '.
            05 ar-pgm-name-02         pic x(10) value 'diffile '.
            05 ar-pgm-name-03         pic x(10) value 'diffile '.
            05 ar-pgm-name-04         pic x(10) value 'diffile3'.
          03 ar-ele-vetdiff redefines ar-pgm-name
                       occurs 4 times pic x(10).

      **          
      * rows for take file 
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 47.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      * 6
            07 ar-ele-take-row-01001      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01002      pic x(80) value 
                    'MERGE FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,'.
            07 ar-ele-take-row-01003      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01004      pic x(80) value 
                    '20,8,FL,D,28,4,PD,A,32,7,ZD,D)        '.
            07 ar-ele-take-row-01005      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01006      pic x(80) value 
                    'USE  dd_infile1	RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-01007      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01008      pic x(80) value 
                    'USE  dd_infile2	RECORD F,90 ORG SQ '.                             
            07 ar-ele-take-row-01009      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01010      pic x(80) value 
                    'USE  dd_infile3	RECORD F,90 ORG SQ '.                             
            07 ar-ele-take-row-01011      pic x(10) value 'musesqf01 '.
            07 ar-ele-take-row-01012      pic x(80) value 
                    'GIVE dd_outfile 	RECORD F,90 ORG SQ '.                             
           
      * 15     
            07 ar-ele-take-row-02001      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02002      pic x(80) value 
                    ' MERGE FIELDS=(8,5,CH,A)              '.                          
            07 ar-ele-take-row-02003      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02004      pic x(80) value 
                    ' SUM FIELDS=(13,3,BI,                 '.                          
            07 ar-ele-take-row-02005      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02006      pic x(80) value 
                    '             16,4,FI,                 '.                          
            07 ar-ele-take-row-02007      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02008      pic x(80) value 
                    '             20,8,FL,                 '.                          
            07 ar-ele-take-row-02009      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02010      pic x(80) value 
                    '             28,4,PD,                 '.                          
            07 ar-ele-take-row-02011      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02012      pic x(80) value 
                    '             32,7,ZD,                 '.                          
            07 ar-ele-take-row-02013      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02014      pic x(80) value 
                    '             39,4,FL,                 '.                          
            07 ar-ele-take-row-02015      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02016      pic x(80) value 
                    '             43,7,CLO,                '.                          
            07 ar-ele-take-row-02017      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02018      pic x(80) value 
                    '             50,8,CST,                '.                          
            07 ar-ele-take-row-02019      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02020      pic x(80) value 
                    '             58,8,CSL                 '.                          
            07 ar-ele-take-row-02021      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02022      pic x(80) value 
                    '             )                        '.                          
            07 ar-ele-take-row-02023      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02024      pic x(80) value 
                    ' USE  dd_infile1  RECORD F,90 ORG SQ  '.                          
            07 ar-ele-take-row-02025      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02026      pic x(80) value 
                    ' USE  dd_infile2  RECORD F,90 ORG SQ  '.                          
            07 ar-ele-take-row-02027      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02028      pic x(80) value 
                    ' USE  dd_infile3  RECORD F,90 ORG SQ  '.                          
            07 ar-ele-take-row-02029      pic x(10) value 'musesqf02 '.
            07 ar-ele-take-row-02030      pic x(80) value 
                    ' GIVE dd_outfile  RECORD F,90 ORG SQ  '.                          
      * 6
            07 ar-ele-take-row-03001      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03002      pic x(80) value 
                    'MERGE FIELDS=(8,5,CH,A)             '.
            07 ar-ele-take-row-03003      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03004      pic x(80) value 
                    'SUM FIELDS=(NONE)                   '.
            07 ar-ele-take-row-03005      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03006      pic x(80) value 
                    'USE  dd_infile1  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-03007      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03008      pic x(80) value 
                    'USE  dd_infile2  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-03009      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03010      pic x(80) value 
                    'USE  dd_infile3  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-03011      pic x(10) value 'musesqf03 '.
            07 ar-ele-take-row-03012      pic x(80) value 
                    'GIVE dd_outfile  RECORD F,90 ORG SQ '.
      * 20
            07 ar-ele-take-row-04001      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04002      pic x(80) value 
                    ' MERGE FIELDS=(28,5,CH,A)            '.
            07 ar-ele-take-row-04003      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04004      pic x(80) value 
                    ' OUTREC FIELDS=(C''FIELD SPEC'',     '.
            07 ar-ele-take-row-04005      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04006      pic x(80) value 
                    '                11:11,7,             '.
            07 ar-ele-take-row-04007      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04008      pic x(80) value 
                    '                22:X,                '.
            07 ar-ele-take-row-04009      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04010      pic x(80) value 
                    '                C''ALPHA'',          '.
            07 ar-ele-take-row-04011      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04012      pic x(80) value 
                    '                28,5,                '.
            07 ar-ele-take-row-04013      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04014      pic x(80) value 
                    '                40:Z,                '.
            07 ar-ele-take-row-04015      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04016      pic x(80) value 
                    '                3C''XYZ'',           '.
            07 ar-ele-take-row-04017      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04018      pic x(80) value 
                    '                X''7B'',             '.
            07 ar-ele-take-row-04019      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04020      pic x(80) value 
                    '                6Z,                  '.
            07 ar-ele-take-row-04021      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04022      pic x(80) value 
                    '                2X''3C2B3E'',        '.
            07 ar-ele-take-row-04023      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04024      pic x(80) value 
                    '                X''7D'',             '.
            07 ar-ele-take-row-04025      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04026      pic x(80) value 
                    '                64,7,                '.
            07 ar-ele-take-row-04027      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04028      pic x(80) value 
                    '                8X,                  '.
            07 ar-ele-take-row-04029      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04030      pic x(80) value 
                    '                C''+'',              '.
            07 ar-ele-take-row-04031      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04032      pic x(80) value 
                    '                11X)                 '.
            07 ar-ele-take-row-04033      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04034      pic x(80) value 
                    ' USE  dd_infile1  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-04035      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04036      pic x(80) value 
                    ' USE  dd_infile2  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-04037      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04038      pic x(80) value 
                    ' USE  dd_infile3  RECORD F,90 ORG SQ '.
            07 ar-ele-take-row-04039      pic x(10) value 'moutsqf10 '.
            07 ar-ele-take-row-04040      pic x(80) value 
                    ' GIVE dd_outfile  RECORD F,90 ORG SQ '.
      *      
          03 filler redefines ar-ele-take-rows 
               occurs 47 times.
           05  ar-ele-take-vet.
            07 ar-ele-take-vet-01         pic x(10).                       ** name
            07 ar-ele-take-vet-02         pic x(80).                       ** value of takefile
          
       77   ntype               BINARY-LONG .
       77   cmd-go              pic x(80) value space.
          
      *
      *-------------------------------------------------------*
       procedure division.
      *-------------------------------------------------------*
       master                     section.
       begin-00.
           display '*===============================================*'
           display ' GCSort test environment ' gcsort-tests-ver
           display '*===============================================*'
           display '*===============================================*'
           display '  gctestrun4           MERGE'
           display '*===============================================*'
           call 'gctestgetop' using ntype
           display ' Environment : ' ntype 
      *
           perform exec-all-gr04 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *     
           perform epilog-gr04
           perform epilog-calculate-gr04
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
           
      * 
      *
      *---------------------------------------------------------*
       exec-all-gr04              section.
      *---------------------------------------------------------*
       exal-00.
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform genfile-input-gr04
           perform merge-cbl-gr04
           perform merge-gc-gr04
           perform diffile-gr04
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
       epilog-gr04                section.
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
           display '|              |                       '
                   'retcode                        |          |'
                   
           display '| Test id      |     cobol      | '
                   '     gcsort     |     diffil'
                   'e       |  status  |'
           display '----------------------------------'
                   '----------------------------------'
                   '--------------'
      
           perform epilog-view-gr04 
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
       epilog-view-gr04           section.
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
       epilog-calculate-gr04      section.
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
       genfile-input-gr04         section.
      *---------------------------------------------------------*
       gein-00.
           move 'dd_outfile'          to env-set-name
           move '../files/fsqf01.dat' to env-set-value
           perform set-value-env
           move 'genfile' to cmd-string
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
           display  cmd-go
           call     'SYSTEM' using  cmd-go
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      * reset 
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       gein-99.
          exit.
      *---------------------------------------------------------*
       merge-cbl-gr04              section.
      *---------------------------------------------------------*
       stcb-00.
           move  99  to ar-tst-rtc01(idx)   
      ** 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** 
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      ** 
           move 'dd_sortwork'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl_save.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** 
           move 'dd_sortwork'                to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_srt.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** 
           move space                  to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'a'             delimited by size
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
           display  cmd-go
           call     "SYSTEM" using  cmd-go
      *
      D    display  "RETURN-CODE Value : " RETURN-CODE
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
      **
      **   Close file
           move space            to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.srt'      delimited by size
                    into env-set-value
           CALL 'CBL_COPY_FILE' USING 
                env-set-value
                '../files/fsqf01.dat'
           move space            to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.srt'      delimited by size
                    into env-set-value
           CALL 'CBL_COPY_FILE' USING 
                env-set-value
                '../files/fsqf02.dat'
           move space            to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.srt'      delimited by size
                    into env-set-value
           CALL 'CBL_COPY_FILE' USING 
                env-set-value
                '../files/fsqf03.dat'
      **
           move 'dd_infile1'              to env-set-name
           move '../files/fsqf01.dat'     to env-set-value
           perform set-value-env
           move 'dd_infile2'              to env-set-name
           move '../files/fsqf02.dat'     to env-set-value
           perform set-value-env
           move 'dd_infile3'              to env-set-name
           move '../files/fsqf03.dat'     to env-set-value
           perform set-value-env
           move 'dd_outfile'              to env-set-name
           move space            to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.mrg'      delimited by size
                    into env-set-value
           perform set-value-env
           move 'dd_mergework'            to env-set-name
           move space            to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_mrg.mrg'      delimited by size
                    into env-set-value
           perform set-value-env
           move space                  to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'b'             delimited by size
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
           display  cmd-go
           call     "SYSTEM" using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc01(idx)      
      D    display  "RETURN-CODE Value : " RETURN-CODE
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc01(idx) > 256)
                divide ar-tst-rtc01(idx) by 256
                giving ar-tst-rtc01(idx)
           end-if
      * reset 
           move 'dd_infile1'      to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_infile2'      to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_infile3'      to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_mergework'    to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       stcb-99.
           exit.
      *
      *---------------------------------------------------------*
       merge-gc-gr04              section.
      *---------------------------------------------------------*
       stgc-00.
           move  99  to ar-tst-rtc02(idx)   
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile1'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
           move 'dd_infile2'             to env-set-name
           move '../files/fsqf02.dat'    to env-set-value
           perform set-value-env
           move 'dd_infile3'             to env-set-name
           move '../files/fsqf03.dat'    to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\susesqf01_gcs.srt
           move 'dd_outfile'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs.mrg'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      **--*          
           move space                to wk-fcmd
           string   '../takefile/tmp/'    delimited by size
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
           perform write-takefile-gr04 
           close fcmd
      ** 
           move space              to cmd-string
           string  'gcsort TAKE ../takefile/tmp/'
                                  delimited by size
                   ar-ele-vet(idx)  delimited by space
                   '.prm'         delimited by size
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
           display  cmd-go
           call     'SYSTEM' using  cmd-go
      *
      D    display  'RETURN-CODE Value : ' RETURN-CODE
           move  RETURN-CODE  to ar-tst-rtc02(idx)
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
       write-takefile-gr04        section.
      *---------------------------------------------------------*
       wrta-00.
           perform write-takerecord-gr04 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       wrta-99.
           exit.
      * 
      *---------------------------------------------------------*
       write-takerecord-gr04      section. 
      *---------------------------------------------------------*
       wrtr-00.
           if(ar-ele-take-vet-01(idx-take) = ar-ele-vet(idx))
              move ar-ele-take-vet-02(idx-take)  to r-cmd
              write r-cmd
           .
       wrtr-99.
           exit.
      *---------------------------------------------------------*
       diffile-gr04               section.
      *---------------------------------------------------------*
       diff-00.
           move  99  to ar-tst-rtc03(idx)
      ** set dd_incobol=%filedir%\susesqf01_cbl.srt
           move 'dd_incobol'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.mrg'      delimited by size
                    into env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/susesqf01_gcs.srt
           move 'dd_ingcsort'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs.mrg'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%\diffile
           move ar-ele-vetdiff(idx)    to cmd-string
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
           display  cmd-go
           call     "SYSTEM" using  cmd-go
      *
      D    display  "RETURN-CODE Value : " RETURN-CODE
           move  RETURN-CODE  to ar-tst-rtc03(idx)
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc03(idx) > 256)
                divide ar-tst-rtc03(idx) by 256
                giving ar-tst-rtc03(idx)
           end-if
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
