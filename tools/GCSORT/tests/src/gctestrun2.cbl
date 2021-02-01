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
      *  cobc -x  -std=default -debug -Wall  -o gctestrun2 gctestrun2.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun2.
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
       01       array-retcode-epilog-gr01.
          03    ar-retcode-ele occurs 5 times.
           05   ar-tst-name           pic x(10).
           05   ar-tst-rtc01          pic 99.
           05   ar-tst-rtc02          pic 99.
           05   ar-tst-rtc03          pic 99.
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
          03 ar-name-max-ele        pic 99  value 05.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(10) value 'soutfsqf01'.
            05 ar-ele-name-02         pic x(10) value 'soutfsqf02'.
            05 ar-ele-name-03         pic x(10) value 'soutfsqf03'.
            05 ar-ele-name-05         pic x(10) value 'soutfsqf05'.
            05 ar-ele-name-04         pic x(10) value 'soutfsqf04'.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 05 times pic x(10).
      *    
       01  array-pgm-diff.
          03 ar-pgm-name.
            05 ar-pgm-name-01         pic x(10) value 'diffile '.
            05 ar-pgm-name-02         pic x(10) value 'diffile '.
            05 ar-pgm-name-03         pic x(10) value 'diffile '.
            05 ar-pgm-name-04         pic x(10) value 'diffile '.
            05 ar-pgm-name-05         pic x(10) value 'diffile4'.
          03 ar-ele-vetdiff redefines ar-pgm-name
                        occurs 5 times pic x(10).
      *
      **          
      * rows for take file 
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 49.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      * 10
            07 ar-ele-take-row-01001      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01002      pic x(80) value  
                ' SORT FIELDS=(8,5,CH,A)                             '.
            07 ar-ele-take-row-01003      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01004      pic x(80) value  
                ' USE  dd_infile   RECORD F,90 ORG SQ                '.
            07 ar-ele-take-row-01005      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01006      pic x(80) value  
                ' GIVE dd_outfile  RECORD F,90 ORG SQ                '.
            07 ar-ele-take-row-01007      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01008      pic x(80) value  
               'OUTFIL INCLUDE =(8,2,CH,EQ,C''AA'',AND,32,7,ZD,LT,20),'.
            07 ar-ele-take-row-01009      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01010      pic x(80) value  
                '         FILES=dd_outfil_01                         '.
            07 ar-ele-take-row-01011      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01012      pic x(80) value 
            'OUTFIL INCLUDE =(8,2,CH,EQ,C''GG'',AND,32,7,ZD,LT,35),'.
            07 ar-ele-take-row-01013      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01014      pic x(80) value  
                '         FILES=dd_outfil_02                         '.
            07 ar-ele-take-row-01015      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01016      pic x(80) value  
              'OUTFIL INCLUDE =(8,2,CH,EQ,C''EE'',AND,32,7,ZD,GT,-10)'.
            07 ar-ele-take-row-01017      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01018      pic x(80) value  
                '        ,FILES=dd_outfil_03                         '.
            07 ar-ele-take-row-01019      pic x(10) value 'soutfsqf01'.
            07 ar-ele-take-row-01020      pic x(80) value  
                ' OUTFIL FNAMES=dd_outfil_save,SAVE                  '.
      * 10
            07 ar-ele-take-row-02001      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02002      pic x(80) value  
                ' SORT FIELDS=(8,5,CH,A)                            '.
            07 ar-ele-take-row-02003      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02004      pic x(80) value  
                ' USE  dd_infile   RECORD F,90 ORG SQ               '.
            07 ar-ele-take-row-02005      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02006      pic x(80) value  
                ' GIVE dd_outfile  RECORD F,90 ORG SQ               '.
            07 ar-ele-take-row-02007      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02008      pic x(80) value  
                'OUTFIL OMIT =(8,2,CH,EQ,C''AA'',AND,32,7,ZD,LT,20),'.
            07 ar-ele-take-row-02009      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02010      pic x(80) value  
                '         FILES=dd_outfil_01                        '.
            07 ar-ele-take-row-02011      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02012      pic x(80) value  
                'OUTFIL OMIT =(8,2,CH,EQ,C''GG'',AND,32,7,ZD,LT,35),'.
            07 ar-ele-take-row-02013      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02014      pic x(80) value  
                '         FILES=dd_outfil_02                        '.
            07 ar-ele-take-row-02015      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02016      pic x(80) value  
                'OUTFIL OMIT=(8,2,CH,EQ,C''EE'',AND,32,7,ZD,GT,-10)'.
            07 ar-ele-take-row-02017      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02018      pic x(80) value  
                '        ,FILES=dd_outfil_03                        '. 
            07 ar-ele-take-row-02019      pic x(10) value 'soutfsqf02'.
            07 ar-ele-take-row-02020      pic x(80) value  
                ' OUTFIL FNAMES=dd_outfil_save,SAVE                 '.
      *          
      * 7
            07 ar-ele-take-row-03001      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03002      pic x(80) value  
                ' SORT FIELDS=(8,5,CH,A)                             '.
            07 ar-ele-take-row-03003      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03004      pic x(80) value  
                ' USE  dd_infile   RECORD F,90 ORG SQ                '.
            07 ar-ele-take-row-03005      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03006      pic x(80) value  
                ' GIVE dd_outfile  RECORD F,90 ORG SQ                '.
            07 ar-ele-take-row-03007      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03008      pic x(80) value  
                'OUTFIL FILES=dd_outfil_01,dd_outfil_02,dd_outfil_03,'. 
            07 ar-ele-take-row-03009      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03010      pic x(80) value  
                'SPLIT,'.
            07 ar-ele-take-row-03011      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03012      pic x(80) value  
                'INCLUDE=(8,2,CH,EQ,C''AA'',AND,32,7,ZD,LT,20)'. 
            07 ar-ele-take-row-03013      pic x(10) value 'soutfsqf03'.
            07 ar-ele-take-row-03014      pic x(80) value  
                ' OUTFIL FNAMES=dd_outfil_save,SAVE                  '. 
      * 6
            07 ar-ele-take-row-05001      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05002      pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                            '.
            07 ar-ele-take-row-05003      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05004      pic x(80) value  
                'USE  dd_infile   RECORD F,90 ORG SQ               '.
            07 ar-ele-take-row-05005      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05006      pic x(80) value  
                'GIVE dd_outfile  RECORD F,90 ORG SQ               '.
            07 ar-ele-take-row-05007      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05008      pic x(80) value  
                'OUTFIL FNAMES=dd_outfil_01,ENDREC=20              '.
            07 ar-ele-take-row-05009      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05010      pic x(80) value  
                'OUTFIL FNAMES=dd_outfil_02,STARTREC=21,ENDREC=40  '.
            07 ar-ele-take-row-05011      pic x(10) value 'soutfsqf05'.
            07 ar-ele-take-row-05012      pic x(80) value  
                'OUTFIL FNAMES=dd_outfil_03,STARTREC=41            '.
                
      *      
      * 16
            07 ar-ele-take-row-04001    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)              '.        
            07 ar-ele-take-row-04003    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04004    pic x(80) value  
                'USE  dd_infile   RECORD F,90 ORG SQ '. 
            07 ar-ele-take-row-04005    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04006    pic x(80) value  
                'GIVE dd_outfile  RECORD F,90 ORG SQ '. 
            07 ar-ele-take-row-04007    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04008    pic x(80) value  
                'OUTFIL FILES=dd_outfil1,            '. 
            07 ar-ele-take-row-04009    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04010    pic x(80) value  
                'OUTREC=        (1,7,                '. 
            07 ar-ele-take-row-04011    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04012    pic x(80) value  
                '               32,7,                '. 
            07 ar-ele-take-row-04013    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04014    pic x(80) value  
                '               20,8,                '. 
            07 ar-ele-take-row-04015    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04016    pic x(80) value  
                '               16,4,                '. 
            07 ar-ele-take-row-04017    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04018    pic x(80) value  
                '               28,4,                '. 
            07 ar-ele-take-row-04019    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04020    pic x(80) value  
                '               13,3,                '. 
            07 ar-ele-take-row-04021    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04022    pic x(80) value  
                '                8,5,                '. 
            07 ar-ele-take-row-04023    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04024    pic x(80) value  
                '               39,4, *   FL COMP-1  '. 
            07 ar-ele-take-row-04025    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04026    pic x(80) value  
                '               43,7, *   CLO        '. 
            07 ar-ele-take-row-04027    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04028    pic x(80) value  
                '               50,8, *   CST        '. 
            07 ar-ele-take-row-04029    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04030    pic x(80) value  
                '               58,8, *   CSL        '. 
            07 ar-ele-take-row-04031    pic x(10) value 'soutfsqf04'.
            07 ar-ele-take-row-04032    pic x(80) value  
                '               66,25)*   Filler     '.
      
      *
          03 filler redefines ar-ele-take-rows 
               occurs 49 times.
           05  ar-ele-take-vet.
            07 ar-ele-take-vet-01         pic x(10).                       ** name
            07 ar-ele-take-vet-02         pic x(80).                       ** value of takefile
            
      **
          
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
           display '  gctestrun2           SORT'
           display '                       Group2'
           display '*===============================================*'
           call 'gctestgetop' using ntype    
           display ' Environment : ' ntype 
 
      *
           perform exec-all-gr02 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *
           perform epilog-gr02
           perform epilog-calculate-gr02
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
      *
      *---------------------------------------------------------*
       exec-all-gr02              section.
      *---------------------------------------------------------*
       exal-00.
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           if (ar-nte(idx) = 2)
               move    ar-ele-vet(idx)    to ar-tst-name(idx)
               perform exec-gr02-002
           end-if
           if (ar-nte(idx) = zero or 1)
               move    ar-ele-vet(idx)    to ar-tst-name(idx)
               perform genfile-input-gr02
               if (ar-nte(idx) = zero)
                  perform sort-cbl-gr02a
                  perform sort-cbl-gr02b
                  perform sort-cbl-gr02c
               end-if
               if (ar-nte(idx) = 1)
                  perform sort-cbl-gr02-2
               end-if
               perform sort-gc-gr02
               perform diffile-gr02a
               perform diffile-gr02b
               perform diffile-gr02c
           end-if
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
      **-->>---------------------------------------------------------*
      **-->>exec-all-gr02b             section.
      **-->>---------------------------------------------------------*
      **-->>exal-00.
      **-->>    display '*===============================================*'
      **-->>    display ' ID test : ' ar-ele-vet2(idx)  "   Start "
      **-->>    display '*===============================================*'
      **-->>    move    ar-ele-vet2(idx)   to ar-tst-name2(idx)
      **-->>    perform genfile-input-gr02
      **-->>    perform sort-cbl-gr02-2
      **-->>    perform sort-gc-gr02
      **-->>    perform diffile-gr02a
      **-->>    perform diffile-gr02b
      **-->>    perform diffile-gr02c
      **-->>    display '*===============================================*'
      **-->>    display ' ID test : ' ar-ele-vet2(idx)  '   End '
      **-->>    display '*===============================================*'
      **-->>    .
      **-->>exal-99.
      **-->>    exit.       
      **
      * 
      *---------------------------------------------------------*
       epilog-gr02                section.
      *---------------------------------------------------------*
       eprt-00.
      *    display " Test id : " ar-tst-name(idx)  " "
      *            " retcode cobol : " ar-tst-rtc01(idx)
      *            " gcort : "         ar-tst-rtc02(idx)
      *            " diffile : "       ar-tst-rtc03(idx)
      *            "   " status-test
      *
           display '----------------------------------'
                   '---------------------'
           display '|              | '
                   '        retcode'
                   '           |          |'
           display '| Test id      | cobol |' 
                   ' gcsort |'         
                   ' diffile '       
                   ' |  status  |' 
           display '----------------------------------'
                   '---------------------'
      
           perform epilog-view-gr02 
               varying idx from 1 by 1
                  until idx > ar-name-max-ele

           display '----------------------------------'
                   '---------------------'
           . 
       eprt-99.
           exit.
      * 
      *---------------------------------------------------------*
       epilog-view-gr02           section.
      *---------------------------------------------------------*
       epvw-00.
           add ar-tst-rtc01(idx) to retcode-sum
           add ar-tst-rtc02(idx) to retcode-sum
           add ar-tst-rtc03(idx) to retcode-sum
           if (ar-tst-rtc01(idx) = zero) and
              (ar-tst-rtc02(idx) = zero) and
              (ar-tst-rtc03(idx) = zero)
              move  " Test OK "   to status-test
           else
              move " Test KO "    to status-test
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
       epilog-calculate-gr02      section.
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
       genfile-input-gr02         section.
      *---------------------------------------------------------*
       gein-00.
           move 'dd_outfile'          to env-set-name
           move '../files/fsqf01.dat' to env-set-value
           perform set-value-env
           move 'genfile' to cmd-string
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
       sort-cbl-gr02a             section.
      *---------------------------------------------------------*
       stcb-00.
           move 99  to ar-tst-rtc01(idx-take)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
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
      ** %exedir%\susesqf01b 
      *******     move 'susesqf01b '       to       cmd-string
           move space               to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'b1'            delimited by size
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
           display ' cmd line : ' cmd-go
           call 'SYSTEM' using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc01(idx)
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
           .
       stcb-99.
           exit.
      *
      *---------------------------------------------------------*
       sort-cbl-gr02b             section.
      *---------------------------------------------------------*
       stcb-00.
           move 99  to ar-tst-rtc02(idx-take)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** 
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl02.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_sortwork'            to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_srt02.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%\susesqf01b 
      *******     move 'susesqf01b '       to       cmd-string
           move space               to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'b2'            delimited by size
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
           display ' cmd line : ' cmd-go
           call 'SYSTEM' using    cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc02(idx)
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
           .
       stcb-99.
           exit.
      *
      *
      *---------------------------------------------------------*
       sort-cbl-gr02c             section.
      *---------------------------------------------------------*
       stcb-00.
           move 99  to ar-tst-rtc01(idx)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** 
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl03.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_sortwork'            to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_srt03.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%\susesqf01b 
      *******     move 'susesqf01b '       to       cmd-string
           move space               to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'b3'            delimited by size
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
           display ' cmd line : ' cmd-go
           call 'SYSTEM' using    cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc01(idx)
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
           .
       stcb-99.
           exit.
      *
      *
      *---------------------------------------------------------*
       sort-gc-gr02               section.
      *---------------------------------------------------------*
       stgc-00.
           move 99  to ar-tst-rtc02(idx)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\susesqf01_gcs.srt
           move 'dd_outfile'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_outfil_01'          to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_outfil_02'          to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs02.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_outfil_03'          to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs03.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_outfil_save'        to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs_save.srt' delimited by size
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
      *    
           perform write-takefile-gr02 
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
       write-takefile-gr02        section.
      *---------------------------------------------------------*
       wrta-00.
           perform write-takerecord-gr02 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       wrta-99.
           exit.
      * 
      *---------------------------------------------------------*
       write-takerecord-gr02      section. 
      *---------------------------------------------------------*
       wrtr-00.
           if(ar-ele-take-vet-01(idx-take) = ar-ele-vet(idx))
              move ar-ele-take-vet-02(idx-take)  to r-cmd
              write r-cmd
           .
       wrtr-99.
           exit.
      *---------------------------------------------------------*
       diffile-gr02a              section.
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
      *---------------------------------------------------------*
       diffile-gr02b              section.
      *---------------------------------------------------------*
       diff-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\susesqf01_cbl.srt
           move 'dd_incobol'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl02.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/susesqf01_gcs.srt
           move 'dd_ingcsort'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs02.srt'    delimited by size
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
      *---------------------------------------------------------*
       diffile-gr02c              section.
      *---------------------------------------------------------*
       diff-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\susesqf01_cbl.srt
           move 'dd_incobol'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl03.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/susesqf01_gcs.srt
           move 'dd_ingcsort'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcs03.srt'    delimited by size
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
*************
       
      *---------------------------------------------------------*
       sort-cbl-gr02-2            section.
      * ---------------------------------------------------------*
       st02-00.
           move 99  to ar-tst-rtc02(idx)  
      * 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      * 
           move 'dd_outfile'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_outfile1'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl01.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      *  
           move 'dd_outfile2'             to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl02.srt'    delimited by size
                    into env-set-value
           perform set-value-env
      * 
           move 'dd_outfile3'             to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl03.srt'    delimited by size
                    into env-set-value
           perform set-value-env
       
      * 
           move 'dd_sortwork'             to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cbl_save.srt' delimited by size
                    into env-set-value
           perform set-value-env
       
      * 
           string ar-ele-vet(idx) delimited by space
                  'b' delimited by size
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
           display ' cmd line : '   cmd-go
           call     "SYSTEM" using  cmd-go
           move  RETURN-CODE  to ar-tst-rtc02(idx)
       
      D    display  "RETURN-CODE Value : " RETURN-CODE
      *  reset 
           move 'dd_infile'      to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfil_01'   to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfil_02'   to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfil_03'   to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_outfil_save' to env-set-name
           move space            to env-set-value
           perform set-value-env
           move 'dd_sortwork'    to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       st02-99.
           exit.
      *
      ****************************************************************
      *---------------------------------------------------------*
       exec-gr02-002              section.
      *---------------------------------------------------------*
       susesqf01-00.
           perform genfile-input-gr02
           perform sort-cbl-gr02-002
           perform sort-gc-gr02-002
           perform diffile-gr02-002
           .
       susesqf01-99.
           exit.
      *
      *---------------------------------------------------------*
       sort-cbl-gr02-002          section.
      *---------------------------------------------------------*
       st02-00.
           move 99  to ar-tst-rtc02(idx)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\soutfsqf04_cbl.srt
           move 'dd_outfile'              to env-set-name
           move '../files/soutfsqf04_cbl.srt' to env-set-value
           perform set-value-env
      *
      ** set dd_sortwork=%filedir%\soutfsqf04_srt.srt
           move 'dd_sortwork'                to env-set-name
           move '../files/soutfsqf04_srt.srt' to env-set-value
           perform set-value-env
      *
      ** %exedir%\soutfsqf04 
           move 'soutfsqf04b '       to       cmd-string
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
           move  RETURN-CODE  to ar-tst-rtc02(idx)
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
           .
       st02-99.
           exit.

      *---------------------------------------------------------*
       sort-gc-gr02-002           section.
      *---------------------------------------------------------*
       st03-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01.dat'    to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\soutfsqf04_gcs.srt
           move 'dd_outfile'              to env-set-name
           move '../files/soutfsqf04_gcs.srt' to env-set-value
           perform set-value-env
      ** export dd_outfil1=$filedir/soutfsqf04_gcs01.srt
           move 'dd_outfil1'              to env-set-name
           move '../files/soutfsqf04_gcs01.srt' to env-set-value
           perform set-value-env
      *
           move space                to wk-fcmd
           string   '../takefile/tmp/'    delimited by size
                    ar-ele-vet(idx) delimited by space
                    '.prm'    delimited by size
                    into wk-fcmd
           inspect wk-fcmd replacing all chrsl by chrbs
           open output fcmd
           if f-s not equal '00' 
              display 'Error on open output file: ' wk-fcmd
                      ' element : ' ar-ele-vet(idx) 
              move 25  to RETURN-CODE
              goback
           end-if
      *    
           perform write-takefile-gr02 
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
           display ' cmd line : '   cmd-go
           call     'SYSTEM' using  cmd-go
           move  RETURN-CODE  to ar-tst-rtc03(idx)
           if (ar-tst-rtc03(idx)  = 4)
               move zero to ar-tst-rtc03(idx)
               display ' Forced zero to retcode - There is a warning.'
           end-if
      * 
      D    display  "RETURN-CODE Value : " RETURN-CODE
      * reset 
           move 'dd_infile'     to env-set-name
           move space           to env-set-value
           perform set-value-env
           move 'dd_outfile'     to env-set-name
           move space           to env-set-value
           perform set-value-env
           move 'dd_outfil1'     to env-set-name
           move space           to env-set-value
           perform set-value-env
           .
       st03-99.
          exit.
      *---------------------------------------------------------*
       diffile-gr02-002           section.
      *---------------------------------------------------------*
       st04-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\soutfsqf04_cbl.srt
           move 'dd_incobol'              to env-set-name
           move '../files/soutfsqf04_cbl.srt'    to env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/soutfsqf04_gcs01.srt
           move 'dd_ingcsort'              to env-set-name
           move '../files/soutfsqf04_gcs01.srt' to env-set-value
           perform set-value-env
      *
      ** %exedir%\diffile2
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
      *
      D    display  "RETURN-CODE Value : " RETURN-CODE
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
       st04-99.
          exit.

      *
      ****************************************************************
