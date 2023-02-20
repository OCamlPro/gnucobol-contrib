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
      *  cobc -x  -std=default -debug -Wall  -o gctestrun1 gctestrun1.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun6.
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
       77 retcode-sum           USAGE BINARY-LONG value zero.
      *
       01       array-retcode-epilog-gr06.
          03    ar-retcode-ele occurs 17 times.
           05   ar-tst-name           pic x(10).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
           05   ar-tst-rtc02          USAGE BINARY-LONG.
           05   ar-tst-rtc03          USAGE BINARY-LONG.
      *  array-name
       01    array-name.
          03 ar-name-max-ele        pic 99  value 16.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(10) value 'Y2T8'.
            05 ar-ele-name-02         pic x(10) value 'Y2T4'.
            05 ar-ele-name-03         pic x(10) value 'Y2T2'.
            05 ar-ele-name-04         pic x(10) value 'Y2T3'.
            05 ar-ele-name-05         pic x(10) value 'Y2T5'.
            05 ar-ele-name-06         pic x(10) value 'Y2T6'.
            05 ar-ele-name-07         pic x(10) value '    '.           Y2T7
            05 ar-ele-name-08         pic x(10) value 'Y2B '.
            05 ar-ele-name-09         pic x(10) value 'Y2C '.
            05 ar-ele-name-10         pic x(10) value 'Y2D '.
            05 ar-ele-name-11         pic x(10) value 'Y2P '.
            05 ar-ele-name-12         pic x(10) value 'Y2S '.
            05 ar-ele-name-13         pic x(10) value 'Y2U '.
            05 ar-ele-name-14         pic x(10) value 'Y2V '.
            05 ar-ele-name-15         pic x(10) value 'Y2X '.
            05 ar-ele-name-16         pic x(10) value 'Y2Y '.
            05 ar-ele-name-17         pic x(10) value 'Y2Z '.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 17 times pic x(10).
       01  array-pgm-diff.
          03 ar-pgm-name.
            05 ar-pgm-name-01         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-02         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-03         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-04         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-05         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-06         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-07         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-08         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-09         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-10         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-11         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-12         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-13         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-14         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-15         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-16         pic x(10) value 'checkfdate'.
            05 ar-pgm-name-17         pic x(10) value 'checkfdate'.
          03 ar-ele-vetdiff redefines ar-pgm-name
                        occurs 17 times pic x(10).

      **          
      * rows for take file 
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 68.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      *      
            07 ar-ele-take-row-01001      pic x(10) value 'Y2T8  '.
            07 ar-ele-take-row-01002      pic x(80) value 
                ' SORT FIELDS=(10,8,Y2T,A) '.
            07 ar-ele-take-row-01003      pic x(10) value 'Y2T8  '.
            07 ar-ele-take-row-01004      pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-01005      pic x(10) value 'Y2T8  '.
            07 ar-ele-take-row-01006      pic x(80) value 
                'GIVE ../files/FDate.dat.Y2T8.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-01007      pic x(10) value 'Y2T8  '.
            07 ar-ele-take-row-01008      pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *         
            07 ar-ele-take-row-02001    pic x(10) value 'Y2T4 '.
            07 ar-ele-take-row-02002    pic x(80) value
                ' SORT FIELDS=(19,4,Y2T,A) '.
            07 ar-ele-take-row-02003    pic x(10) value 'Y2T4 '.
            07 ar-ele-take-row-02004    pic x(80) value
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-02005    pic x(10) value 'Y2T4 '.
            07 ar-ele-take-row-02006    pic x(80) value
                'GIVE ../files/FDate.dat.Y2T4.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-02007    pic x(10) value 'Y2T4 '.
            07 ar-ele-take-row-02008    pic x(80) value
                ' OPTION Y2PAST=80 '. 
      * 
            07 ar-ele-take-row-03001    pic x(10) value 'Y2T2 '.
            07 ar-ele-take-row-00302    pic x(80) value
                ' SORT FIELDS=(24,2,Y2T,A) '.
            07 ar-ele-take-row-03003    pic x(10) value 'Y2T2 '.
            07 ar-ele-take-row-03004    pic x(80) value
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-03005    pic x(10) value 'Y2T2 '.
            07 ar-ele-take-row-03006    pic x(80) value
                'GIVE ../files/FDate.dat.Y2T2.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-03007    pic x(10) value 'Y2T2 '.
            07 ar-ele-take-row-03008    pic x(80) value
                ' OPTION Y2PAST=80 '. 
      * 
            07 ar-ele-take-row-04001    pic x(10) value 'Y2T3 '.
            07 ar-ele-take-row-04002    pic x(80) value 
                ' SORT FIELDS=(27,3,Y2T,A) '.
            07 ar-ele-take-row-04003    pic x(10) value 'Y2T3 '.
            07 ar-ele-take-row-04004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-04005    pic x(10) value 'Y2T3 '.
            07 ar-ele-take-row-04006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2T3.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-04007    pic x(10) value 'Y2T3 '.
            07 ar-ele-take-row-04008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *                     
            07 ar-ele-take-row-05001    pic x(10) value 'Y2T5 '.
            07 ar-ele-take-row-05002    pic x(80) value 
                ' SORT FIELDS=(31,5,Y2T,A) '.
            07 ar-ele-take-row-05003    pic x(10) value 'Y2T5 '.
            07 ar-ele-take-row-05004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-05005    pic x(10) value 'Y2T5 '.
            07 ar-ele-take-row-05006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2T5.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-05007    pic x(10) value 'Y2T5 '.
            07 ar-ele-take-row-05008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *                     
            07 ar-ele-take-row-06001    pic x(10) value 'Y2T6 '.
            07 ar-ele-take-row-06002    pic x(80) value 
                ' SORT FIELDS=(37,6,Y2T,A) '.
            07 ar-ele-take-row-06003    pic x(10) value 'Y2T6 '.
            07 ar-ele-take-row-06004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-06005    pic x(10) value 'Y2T6 '.
            07 ar-ele-take-row-06006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2T6.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-06007    pic x(10) value 'Y2T6 '.
            07 ar-ele-take-row-06008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *                     
            07 ar-ele-take-row-07001    pic x(10) value 'Y4T7 '.
            07 ar-ele-take-row-07002    pic x(80) value 
                ' SORT FIELDS=(44,7,Y4T,A) '.
            07 ar-ele-take-row-07003    pic x(10) value 'Y4T7 '.
            07 ar-ele-take-row-07004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-07005    pic x(10) value 'Y4T7 '.
            07 ar-ele-take-row-07006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y4T7.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-07007    pic x(10) value 'Y4T7 '.
            07 ar-ele-take-row-07008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *                     
            07 ar-ele-take-row-08001    pic x(10) value 'Y2B '.
            07 ar-ele-take-row-08002    pic x(80) value 
                ' SORT FIELDS=(52,1,Y2B,A)  '.
            07 ar-ele-take-row-08003    pic x(10) value 'Y2B '.
            07 ar-ele-take-row-08004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-08005    pic x(10) value 'Y2B '.
            07 ar-ele-take-row-08006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2B.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-08007    pic x(10) value 'Y2B '.
            07 ar-ele-take-row-08008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *                     
            07 ar-ele-take-row-09001    pic x(10) value 'Y2C '.
            07 ar-ele-take-row-09002    pic x(80) value 
                ' SORT FIELDS=(54,2,Y2C,A) '.
            07 ar-ele-take-row-09003    pic x(10) value 'Y2C '.
            07 ar-ele-take-row-09004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-09005    pic x(10) value 'Y2C '.
            07 ar-ele-take-row-09006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2C.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-09007    pic x(10) value 'Y2C '.
            07 ar-ele-take-row-09008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-10001    pic x(10) value 'Y2D '.
            07 ar-ele-take-row-10002    pic x(80) value 
                ' SORT FIELDS=(57,1,Y2D,A) '.
            07 ar-ele-take-row-10003    pic x(10) value 'Y2D '.
            07 ar-ele-take-row-10004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-10005    pic x(10) value 'Y2D '.
            07 ar-ele-take-row-10006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2D.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-10007    pic x(10) value 'Y2D '.
            07 ar-ele-take-row-10008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-11001    pic x(10) value 'Y2P '.
            07 ar-ele-take-row-11002    pic x(80) value 
                ' SORT FIELDS=(59,2,Y2P,A) '.
            07 ar-ele-take-row-11003    pic x(10) value 'Y2P '.
            07 ar-ele-take-row-11004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-11005    pic x(10) value 'Y2P '.
            07 ar-ele-take-row-11006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2P.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-11007    pic x(10) value 'Y2P '.
            07 ar-ele-take-row-11008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-12001    pic x(10) value 'Y2S '.
            07 ar-ele-take-row-12002    pic x(80) value 
                ' SORT FIELDS=(62,2,Y2S,A) '.
            07 ar-ele-take-row-12003    pic x(10) value 'Y2S '.
            07 ar-ele-take-row-12004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-12005    pic x(10) value 'Y2S '.
            07 ar-ele-take-row-12006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2S.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-12007    pic x(10) value 'Y2S '.
            07 ar-ele-take-row-12008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-13001    pic x(10) value 'Y2U '.
            07 ar-ele-take-row-13002    pic x(80) value 
                ' SORT FIELDS=(65,3,Y2U,A) '.
            07 ar-ele-take-row-13003    pic x(10) value 'Y2U '.
            07 ar-ele-take-row-13004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-13005    pic x(10) value 'Y2U '.
            07 ar-ele-take-row-13006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2U.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-13007    pic x(10) value 'Y2U '.
            07 ar-ele-take-row-13008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-14001    pic x(10) value 'Y2V '.
            07 ar-ele-take-row-14002    pic x(80) value 
                ' SORT FIELDS=(69,4,Y2V,A)  '.
            07 ar-ele-take-row-14003    pic x(10) value 'Y2V '.
            07 ar-ele-take-row-14004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-14005    pic x(10) value 'Y2V '.
            07 ar-ele-take-row-14006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2V.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-14007    pic x(10) value 'Y2V '.
            07 ar-ele-take-row-14008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-15001    pic x(10) value 'Y2X '.
            07 ar-ele-take-row-15002    pic x(80) value 
                ' SORT FIELDS=(74,3,Y2X,A) '.
            07 ar-ele-take-row-15003    pic x(10) value 'Y2X '.
            07 ar-ele-take-row-15004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-15005    pic x(10) value 'Y2X '.
            07 ar-ele-take-row-15006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2X.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-15007    pic x(10) value 'Y2X '.
            07 ar-ele-take-row-15008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-16001    pic x(10) value 'Y2Y '.
            07 ar-ele-take-row-16002    pic x(80) value 
                ' SORT FIELDS=(78,4,Y2Y,A) '.
            07 ar-ele-take-row-16003    pic x(10) value 'Y2Y '.
            07 ar-ele-take-row-16004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-16005    pic x(10) value 'Y2Y '.
            07 ar-ele-take-row-16006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2Y.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-16007    pic x(10) value 'Y2Y '.
            07 ar-ele-take-row-16008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *        
            07 ar-ele-take-row-17001    pic x(10) value 'Y2Z '.
            07 ar-ele-take-row-17002    pic x(80) value 
                ' SORT FIELDS=(83,2,Y2Z,A) '.
            07 ar-ele-take-row-17003    pic x(10) value 'Y2Z '.
            07 ar-ele-take-row-17004    pic x(80) value 
                ' USE ../files/FDate.dat   RECORD F,85 ORG SQ  '. 
            07 ar-ele-take-row-17005    pic x(10) value 'Y2Z '.
            07 ar-ele-take-row-17006    pic x(80) value  
                'GIVE ../files/FDate.dat.Y2Z.srt RECORD F,85 ORG SQ'. 
            07 ar-ele-take-row-17007    pic x(10) value 'Y2Z '.
            07 ar-ele-take-row-17008    pic x(80) value 
                ' OPTION Y2PAST=80 '. 
      *      
          03 filler redefines ar-ele-take-rows 
               occurs 68 times.
           05  ar-ele-take-vet.
            07 ar-ele-take-vet-01         pic x(10).                       ** name
            07 ar-ele-take-vet-02         pic x(80).                       ** value 
          
       77   ntype               BINARY-LONG .
       77   nver                pic 9(9) .
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
           display '  gctestrun6           SORT  Date fields'
           display '                       Group6'
           display '*===============================================*'
           call 'gctestgetop' using ntype , nver   
           display ' Environment : ' ntype 
           display ' Version     : ' nver 
 
      *
           perform exec-all-gr06 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *     
           perform epilog-gr06
           perform epilog-calculate-gr06
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
           
      * 
      *
      *---------------------------------------------------------*
       exec-all-gr06              section.
      *---------------------------------------------------------*
       exal-00.
           if ar-ele-vet(idx) = space
                    go exal-99.
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform genfile-input-gr06
           perform sort-gc-gr06
           perform diffile-gr06
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
       epilog-gr06                section.
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
      
           perform epilog-view-gr06 
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
       epilog-view-gr06           section.
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
       epilog-calculate-gr06      section.
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
       genfile-input-gr06         section.
      *---------------------------------------------------------*
       gein-00.
           move 'dd_infile'                     to env-set-name
           move '../filesin/FDate_Struct.txt'   to env-set-value
           perform set-value-env
           move 'dd_outfile'          to env-set-name
           move '../files/FDate.dat' to env-set-value
           perform set-value-env
           move 'genfiledate' to cmd-string
Win        if (ntype = 1)
               inspect cmd-string replacing all chrsl by chrbs
               move cmd-string to cmd-go
           else
Linux        if (ntype = 2) or (ntype = 3)  
                 move space to cmd-go
                 string './'   delimited by size 
                    cmd-string delimited by size
                          into cmd-go
TEST00           display cmd-go
             else
                 display ' SYSTEM call problem '
                 goback
             end-if             
           end-if            
           display  cmd-go
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
       sort-gc-gr06               section.
      *---------------------------------------------------------*
       stgc-00.
           move 99  to ar-tst-rtc02(idx)  
      ** set dd_infile=%filedir%\FDate.dat 
           move 'dd_infile'              to env-set-name
           move '../files/FDate.dat'     to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\susesqf01_gcs.srt
           move 'dd_outfile'              to env-set-name
           move space                    to env-set-value
           string '../files/FDate.dat.'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      **--*          
           move space                to wk-fcmd
           string   '../takefile/tmp/FDate_'    delimited by size
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
           perform write-takefile-gr06 
           close fcmd
      ** 
           move space              to cmd-string
           string  'gcsort TAKE ../takefile/tmp/FDate_'
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
TEST00               display ' cmd:' cmd-go  
             else
                 display ' SYSTEM call problem '
                 goback
             end-if             
           end-if            
           display  cmd-go
           call     'SYSTEM' using cmd-go
      *
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
       write-takefile-gr06        section.
      *---------------------------------------------------------*
       wrta-00.
           perform write-takerecord-gr06 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       wrta-99.
           exit.
      * 
      *---------------------------------------------------------*
       write-takerecord-gr06      section. 
      *---------------------------------------------------------*
       wrtr-00.
           if(ar-ele-take-vet-01(idx-take) = ar-ele-vet(idx))
              move ar-ele-take-vet-02(idx-take)  to r-cmd
              write r-cmd
           .
       wrtr-99.
           exit.
      *---------------------------------------------------------*
       diffile-gr06               section.
      *---------------------------------------------------------*
       diff-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\
           move 'dd_infile'              to env-set-name
           move space                    to env-set-value
           string '../files/FDate.dat.'  delimited by size
                    ar-ele-vet(idx)      delimited by space
                    '.srt'               delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%
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
           display   cmd-go
           call     "SYSTEM" using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc03(idx)
      ** Check return code [Problem in Linux environment]     
           if (ar-tst-rtc03(idx) > 256)
                divide ar-tst-rtc03(idx) by 256
                giving ar-tst-rtc03(idx)
           end-if
      D    display  "RETURN-CODE Value : " RETURN-CODE
      ** set rtc2=%errorlevel%
      * reset 
      ** set dd_infile=
           move 'dd_infile'      to env-set-name
           move space             to env-set-value
           perform set-value-env
          .
       diff-99.
          exit.
