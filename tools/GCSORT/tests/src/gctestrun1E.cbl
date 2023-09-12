      ****************************************************************
      *
      * AUTHOR   Sauro Menna
      * DATE     20230207  
      * LICENSE
      *  Copyright (c) 2023 Sauro Menna
      *  GNU Lesser General Public License, LGPL, 3.0 (or superior)
      * PURPOSE
      *  run test script for GCSort
      * CMD line to compile program
      *  cobc -x  -std=default -debug -Wall  -o gctestrun1 gctestrun1.cbl 
      ****************************************************************
 	   identification division.
       program-id.  gctestrun1.
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
       01  cmd-gcsort-ebcdic    pic x(70) value 
            ' -fsign=EBCDIC -fcolseq=EBCDIC  -febcdic-table=DEFAULT '.
       
      *
       01       array-retcode-epilog-gr01.
          03    ar-retcode-ele occurs 18 times.
           05   ar-tst-name           pic x(11).
           05   ar-tst-rtc01          USAGE BINARY-LONG.
           05   ar-tst-rtc02          USAGE BINARY-LONG.
           05   ar-tst-rtc03          USAGE BINARY-LONG.
      *  array-name
       01    array-name.
          03 ar-name-max-ele        pic 99  value     18.
          03 ar-ele-name.
            05 ar-ele-name-01         pic x(11) value 'susesqf01E'.
            05 ar-ele-name-02         pic x(11) value 'susesqf02E'.
            05 ar-ele-name-03         pic x(11) value 'susesqf03E'.
            05 ar-ele-name-04         pic x(11) value 'susesqf16E'.
            05 ar-ele-name-05         pic x(11) value 'sfrmsqf17E'.
            05 ar-ele-name-06         pic x(11) value 'sfrmsqf18E'.
            05 ar-ele-name-07         pic x(11) value 'sincsqf04E'.
            05 ar-ele-name-08         pic x(11) value 'sincsqf05E'.
            05 ar-ele-name-09         pic x(11) value 'sincsqf06E'.
            05 ar-ele-name-10         pic x(11) value 'sincsqf07E'.
            05 ar-ele-name-11         pic x(11) value 'sincsqf08E'.
            05 ar-ele-name-12         pic x(11) value 'sincsqf19E'.
            05 ar-ele-name-13         pic x(11) value 'somisqf09E'.
            05 ar-ele-name-14         pic x(11) value 'somisqf11E'.
            05 ar-ele-name-15         pic x(11) value 'somisqf12E'.
            05 ar-ele-name-16         pic x(11) value 'somisqf13E'.
            05 ar-ele-name-17         pic x(11) value 'sinrsqf14E'.
            05 ar-ele-name-18         pic x(11) value 'soutsqf10E'.
            05 ar-ele-name-19         pic x(11) value 'soutfsqf04E'.
          03 ar-ele-vet redefines ar-ele-name
                        occurs 19 times pic x(11).
       01  array-pgm-diff.
          03 ar-pgm-name.
            05 ar-pgm-name-01         pic x(11) value 'diffileE'.
            05 ar-pgm-name-02         pic x(11) value 'diffileE'.
            05 ar-pgm-name-03         pic x(11) value 'diffileE'.
            05 ar-pgm-name-04         pic x(11) value 'diffileE'.
            05 ar-pgm-name-05         pic x(11) value 'diffileE'.
            05 ar-pgm-name-06         pic x(11) value 'diffileE'.
            05 ar-pgm-name-07         pic x(11) value 'diffileE'.
            05 ar-pgm-name-08         pic x(11) value 'diffile4E'.
            05 ar-pgm-name-09         pic x(11) value 'diffile4E'.
            05 ar-pgm-name-10         pic x(11) value 'diffileE'.
            05 ar-pgm-name-11         pic x(11) value 'diffileE'.
            05 ar-pgm-name-12         pic x(11) value 'diffileE'.
            05 ar-pgm-name-13         pic x(11) value 'diffileE'.
            05 ar-pgm-name-14         pic x(11) value 'diffileE'.
            05 ar-pgm-name-15         pic x(11) value 'diffile3E'.
            05 ar-pgm-name-16         pic x(11) value 'diffileE'.
            05 ar-pgm-name-17         pic x(11) value 'diffile4E'.
            05 ar-pgm-name-18         pic x(11) value 'diffile3E'.
          03 ar-ele-vetdiff redefines ar-pgm-name
                        occurs 18 times pic x(11).

      **          
      * rows for take file 
      * key is name of test
      **
       01      array-takefile.
          03   ar-ele-take-num            pic 9(3)  value 196.
          03   ar-ele-take-rows.
           05  ar-ele-take-row-01.
      * 3     
            07 ar-ele-take-row-01001      pic x(11) value 'susesqf01E'.
            07 ar-ele-take-row-01002      pic x(80) value 
                ' SORT FIELDS=(8,5,CH,A,13,3,BI,D,16,4,FI,A,20,8,FL,D,28
      -',4,PD,A,32,7,ZD,D) '.                            
            07 ar-ele-take-row-01003      pic x(11) value 'susesqf01E'.
            07 ar-ele-take-row-01004      pic x(80) value 
                ' USE  dd_infile   RECORD F,90 ORG SQ '. 
            07 ar-ele-take-row-01005      pic x(11) value 'susesqf01E'.
            07 ar-ele-take-row-01006      pic x(80) value 
                ' GIVE dd_outfile  RECORD F,90 ORG SQ '. 
      *  13        
            07 ar-ele-take-row-02001    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02002    pic x(80) 
                    value ' SORT FIELDS=(8,5,CH,A)   '.     
            07 ar-ele-take-row-02003    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02004    pic x(80) 
                    value ' SUM FIELDS=(13,3,BI,     '.  
            07 ar-ele-take-row-02005    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02006    pic x(80) 
                    value '             16,4,FI,     '.   
            07 ar-ele-take-row-02007    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02008    pic x(80) 
                    value '             20,8,FL,     '.  
            07 ar-ele-take-row-02009    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02010    pic x(80) 
                    value '             28,4,PD,     '.  
            07 ar-ele-take-row-02011    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02012    pic x(80) 
                    value '             32,7,ZD,     '.  
            07 ar-ele-take-row-02013    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02014    pic x(80) 
                    value '             39,4,FL,     '.  
            07 ar-ele-take-row-02015    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02016    pic x(80) 
                    value '             43,7,CLO,    '.  
            07 ar-ele-take-row-02017    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02018    pic x(80) 
                    value '             50,8,CST,    '.  
            07 ar-ele-take-row-02019    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02020    pic x(80) 
                    value '             58,8,CSL     '.  
            07 ar-ele-take-row-02021    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02022    pic x(80) 
                    value '             )            '.  
            07 ar-ele-take-row-02023    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02024    pic x(80) 
                    value ' USE  dd_infile   RECORD F,90 ORG SQ '. 
            07 ar-ele-take-row-02025    pic x(11) value 'susesqf02E'.
            07 ar-ele-take-row-02026    pic x(80) 
                    value ' GIVE dd_outfile  RECORD F,90 ORG SQ '.
      * 4
            07 ar-ele-take-row-03001    pic x(11) value 'susesqf03E'.
            07 ar-ele-take-row-00302    pic x(80) 
                    value ' SORT FIELDS=(8,5,CH,A)   '.
            07 ar-ele-take-row-03003    pic x(11) value 'susesqf03E'.
            07 ar-ele-take-row-03004    pic x(80) 
                    value ' SUM FIELDS=(NONE)        '.    
            07 ar-ele-take-row-03005    pic x(11) value 'susesqf03E'.
            07 ar-ele-take-row-03006    pic x(80) 
                    value ' USE  dd_infile   RECORD F,90 ORG SQ ' .
            07 ar-ele-take-row-03007    pic x(11) value 'susesqf03E'.
            07 ar-ele-take-row-03008    pic x(80) 
                    value ' GIVE dd_outfile  RECORD F,90 ORG SQ '.
      * 9
            07 ar-ele-take-row-04001    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04002    pic x(80) value 
             'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-04003    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04004    pic x(80) value 
             'USE  dd_infile     RECORD F,90 ORG SQ     '.
            07 ar-ele-take-row-04005    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04006    pic x(80) value  
             'GIVE dd_outfile    RECORD F,90 ORG SQ     '.
            07 ar-ele-take-row-04007    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04008    pic x(80) value 
      **       'INCLUDE COND=(8,2,CH,GT,C''GG'',AND,13,3,BI,GT,10,AND,'.
             'INCLUDE COND=(8,2,CH,GT,X''C7C7'',AND,13,3,BI,GT,10,AND,'.
            07 ar-ele-take-row-04009    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04010    pic x(80) value 
             '16,4,FI,LT,40,AND,20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,'.
            07 ar-ele-take-row-04011    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04012    pic x(80) value 
             '32,7,ZD,LT,40)'.
            07 ar-ele-take-row-04013    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04014    pic x(80) value 
             'SUM FIELDS=(NONE)                         '.                 
            07 ar-ele-take-row-04015    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04016    pic x(80) value 
            'OPTION SKIPREC=5                          '.
            07 ar-ele-take-row-04017    pic x(11) value 'susesqf16E'.
            07 ar-ele-take-row-04018    pic x(80) value 
            'STOPAFT=15                                '.
      *  8                   
            07 ar-ele-take-row-05001    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05002    pic x(80) value 
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-05003    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05004    pic x(80) value 
      **          'INCLUDE COND=(8,2,CH,LE,C''FF'',AND,      '.
                'INCLUDE COND=(8,2,CH,LE,X''C6C6'',AND,      '.
            07 ar-ele-take-row-05005    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05006    pic x(80) value 
                '             39,4,FL,GT,-10,OR,           '.
            07 ar-ele-take-row-05007    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05008    pic x(80) value 
                '             43,7,CLO,GT,10,AND,          '.
            07 ar-ele-take-row-05009    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05010    pic x(80) value 
                '             50,8,CST,LE,-30,OR,          '.
            07 ar-ele-take-row-05011    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05012    pic x(80) value 
                '             58,8,CSL,LE,10)              '.
            07 ar-ele-take-row-05013    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05014    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-05015    pic x(11) value 'sfrmsqf17E'.
            07 ar-ele-take-row-05016    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
      * 8
            07 ar-ele-take-row-06001    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06002    pic x(80) value 
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-06003    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06004    pic x(80) value 
      **          'OMIT COND=(8,2,CH,LE,C''FF'',AND,         '.
                'OMIT COND=(8,2,CH,LE,X''C6C6'',AND,         '.
            07 ar-ele-take-row-06005    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06006    pic x(80) value 
                '             39,4,FL,GT,-10,OR,           '.
            07 ar-ele-take-row-06007    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06008    pic x(80) value 
                '             43,7,CLO,GT,10,AND,          '.
            07 ar-ele-take-row-06009    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06010    pic x(80) value 
                '             50,8,CST,LE,-30,OR,          '.
            07 ar-ele-take-row-06011    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06012    pic x(80) value 
                '             58,8,CSL,LE,10)              '.
            07 ar-ele-take-row-06013    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06014    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-06015    pic x(11) value 'sfrmsqf18E'.
            07 ar-ele-take-row-06016    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
      * 7
            07 ar-ele-take-row-07001    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07002    pic x(80) value 
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-07003    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07004    pic x(80) value 
      **          'INCLUDE COND=(8,2,CH,GT,C''GG'',AND,      '.
                'INCLUDE COND=(8,2,CH,GT,X''C7C7'',AND,      '.
            07 ar-ele-take-row-07005    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07006    pic x(80) value 
                '    13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,  '.
            07 ar-ele-take-row-07007    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07008    pic x(80) value 
                '    20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,  '.
            07 ar-ele-take-row-07009    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07010    pic x(80) value 
                '    32,7,ZD,LT,40)                        '.
            07 ar-ele-take-row-07011    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07012    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-07013    pic x(11) value 'sincsqf04E'.
            07 ar-ele-take-row-07014    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
      * 15
            07 ar-ele-take-row-08001    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08002    pic x(80) value 
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-08003    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08004    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-08005    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08006    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-08007    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08008    pic x(80) value 
                'OUTREC FIELDS(1,7,                        '.
            07 ar-ele-take-row-08009    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08010    pic x(80) value 
                '              32,7,                       '.
            07 ar-ele-take-row-08011    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08012    pic x(80) value 
                '              20,8,                       '.
            07 ar-ele-take-row-08013    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08014    pic x(80) value 
                '              16,4,                       '.
            07 ar-ele-take-row-08015    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08016    pic x(80) value 
                '              28,4,                       '.
            07 ar-ele-take-row-08017    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08018    pic x(80) value 
                '              13,3,                       '.
            07 ar-ele-take-row-08019    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08020    pic x(80) value 
                '               8,5,                       '.
            07 ar-ele-take-row-08021    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08022    pic x(80) value 
                '              39,4,                       '.
            07 ar-ele-take-row-08023    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08024    pic x(80) value 
                '              43,7,                       '.
            07 ar-ele-take-row-08025    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08026    pic x(80) value 
                '              50,8,                       '.
            07 ar-ele-take-row-08027    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08028    pic x(80) value 
                '              58,8,                       '.
            07 ar-ele-take-row-08029    pic x(11) value 'sincsqf05E'.
            07 ar-ele-take-row-08030    pic x(80) value 
                '              66,25)                      '.
      *  19     
            07 ar-ele-take-row-09001    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09002    pic x(80) value 
                'SORT FIELDS=(34,5,CH,A)                   '. 
            07 ar-ele-take-row-09003    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09004    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                  
            07 ar-ele-take-row-09005    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09006    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                  
            07 ar-ele-take-row-09007    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09008    pic x(80) value 
                'INREC    FIELDS(1,7,              '.
            07 ar-ele-take-row-09009    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09010    pic x(80) value 
                '               32,7,              '.
            07 ar-ele-take-row-09011    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09012    pic x(80) value 
                '               20,8,              '.
            07 ar-ele-take-row-09013    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09014    pic x(80) value 
                '               16,4,              '.
            07 ar-ele-take-row-09015    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09016    pic x(80) value 
                '               28,4,              '.
            07 ar-ele-take-row-09017    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09018    pic x(80) value 
                '               13,3,              '.
            07 ar-ele-take-row-09019    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09020    pic x(80) value 
                '                8,5,              '.
            07 ar-ele-take-row-09021    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09022    pic x(80) value 
                '               39,4,              '.
            07 ar-ele-take-row-09023    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09024    pic x(80) value 
                '               43,7,              '.
            07 ar-ele-take-row-09025    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09026    pic x(80) value 
                '               50,8,              '.
            07 ar-ele-take-row-09027    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09028    pic x(80) value 
                '               58,8,              '.
            07 ar-ele-take-row-09029    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09030    pic x(80) value 
                '               66,25)             '.
            07 ar-ele-take-row-09031    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09032    pic x(80) value 
      **          'INCLUDE COND=(8,2,CH,GT,C''GG'',AND, '.
                'INCLUDE COND=(8,2,CH,GT,X''C7C7'',AND, '.
            07 ar-ele-take-row-09033    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09034    pic x(80) value 
                ' 13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,'. 
            07 ar-ele-take-row-09035    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09036    pic x(80) value 
                ' 20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,'.
            07 ar-ele-take-row-09037    pic x(11) value 'sincsqf06E'.
            07 ar-ele-take-row-09038    pic x(80) value 
                '32,7,ZD,LT,40)'                       .                 
      * 8
            07 ar-ele-take-row-10001    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10002    pic x(80) value 
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-10003    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10004    pic x(80) value 
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-10005    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10006    pic x(80) value 
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-10007    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10008    pic x(80) value 
      **          'INCLUDE COND=(8,2,CH,GT,C''GG'',AND, '.
                'INCLUDE COND=(8,2,CH,GT,X''C7C7'',AND, '.
            07 ar-ele-take-row-10009    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10010    pic x(80) value 
                ' 13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,'. 
            07 ar-ele-take-row-10011    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10012    pic x(80) value 
                ' 20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,'.
            07 ar-ele-take-row-10013    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10014    pic x(80) value 
                '32,7,ZD,LT,40)'                       .                 
            07 ar-ele-take-row-10015    pic x(11) value 'sincsqf07E'.
            07 ar-ele-take-row-10016    pic x(80) value 
                'SUM FIELDS=(NONE) '                   .                 
      * 8
            07 ar-ele-take-row-11001    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                '.
            07 ar-ele-take-row-11003    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11004    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ '.                 
            07 ar-ele-take-row-11005    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11006    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ '.                 
            07 ar-ele-take-row-11007    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11008    pic x(80) value  
      **          'INCLUDE COND=(8,2,CH,GT,C''GG'',AND, ' .
                'INCLUDE COND=(8,2,CH,GT,X''C7C7'',AND, ' .
            07 ar-ele-take-row-11009    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11010    pic x(80) value  
                ' 13,3,BI,GT,10,AND,16,4,FI,LT,40,AND,' . 
            07 ar-ele-take-row-11011    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11012    pic x(80) value  
                ' 20,8,FL,GT,10,AND,28,4,PD,GT,10,AND,' .
            07 ar-ele-take-row-11013    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11014    pic x(80) value  
                '32,7,ZD,LT,40)'                        .                
            07 ar-ele-take-row-11015    pic x(11) value 'sincsqf08E'.
            07 ar-ele-take-row-11016    pic x(80) value  
                'OPTION STOPAFT=15 SKIPREC=5 '          .                 
      * 8
            07 ar-ele-take-row-12001    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                   '.
            07 ar-ele-take-row-12003    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12004    pic x(80) value  
      **         'INCLUDE COND=(8,4,CH,SS,C''DDDD,GGGG,HHHH,JJJJ,OOOO'')'.
               'INCLUDE COND=(8,4,CH,EQ,X''C4C4C4C4'',OR,'.
            07 ar-ele-take-row-12005    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12006    pic x(80) value  
                '            8,4,CH,EQ,X''C7C7C7C7'',OR,'.                 
            07 ar-ele-take-row-12007    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12008    pic x(80) value  
                '            8,4,CH,EQ,X''C8C8C8C8'',OR,'.                 
            07 ar-ele-take-row-12009    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12010    pic x(80) value  
                '            8,4,CH,EQ,X''D1D1D1D1'',OR,'.                 
            07 ar-ele-take-row-12011    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12012    pic x(80) value  
                '            8,4,CH,EQ,X''D6D6D6D6'')'.                 
            07 ar-ele-take-row-12013    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12014    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-12015    pic x(11) value 'sincsqf19E'.
            07 ar-ele-take-row-12016    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.            
      * 8
            07 ar-ele-take-row-13001    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                   '.
            07 ar-ele-take-row-13003    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13004    pic x(80) value  
      **          'OMIT COND=((8,2,CH,LT,C''GG'',AND,'.
                'OMIT COND=((8,2,CH,LT,X''C7C7'',AND,'.
            07 ar-ele-take-row-13005    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13006    pic x(80) value  
                '13,3,BI,LT,15,AND,16,4,FI,GT,6)'.
            07 ar-ele-take-row-13007    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13008    pic x(80) value  
                ',OR,'.
            07 ar-ele-take-row-13009    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13010    pic x(80) value  
                '(20,8,FL,GE,25,AND,28,4,PD,LE,18,'.
            07 ar-ele-take-row-13011    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13012    pic x(80) value  
                'AND,32,7,ZD,EQ,12))'.
            07 ar-ele-take-row-13013    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13014    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.
            07 ar-ele-take-row-13015    pic x(11) value 'somisqf09E'.
            07 ar-ele-take-row-13016    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
      * 7
            07 ar-ele-take-row-14001    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-14003    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14004    pic x(80) value  
                'OMIT COND=(8,2,CH,LE,X''D4D4'',AND,         '.
            07 ar-ele-take-row-14005    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14006    pic x(80) value  
                '13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,      '.
            07 ar-ele-take-row-14007    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14008    pic x(80) value  
                '20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,       '.
            07 ar-ele-take-row-14009    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14010    pic x(80) value  
                '32,7,ZD,GE,15)                            '.
            07 ar-ele-take-row-14011    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14012    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-14013    pic x(11) value 'somisqf11E'.
            07 ar-ele-take-row-14014    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
      * 22
            07 ar-ele-take-row-15001    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-15003    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15004    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-15005    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15006    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-15007    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15008    pic x(80) value  
                'OMIT COND=(8,2,CH,LE,C''D4D4'',AND,       '.
      **          'OMIT COND=(8,2,CH,LE,C''MM'',AND,         '.
            07 ar-ele-take-row-15009    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15010    pic x(80) value  
                '13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,      '.
            07 ar-ele-take-row-15011    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15012    pic x(80) value  
                '20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,       '.
            07 ar-ele-take-row-15013    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15014    pic x(80) value  
                '32,7,ZD,GE,15)                            '.
            07 ar-ele-take-row-15015    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15016    pic x(80) value  
                'OUTREC FIELDS=(C''FIELD SPEC'',           '.    
            07 ar-ele-take-row-15017    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15018    pic x(80) value  
                '               11:1,7,                    '.  
            07 ar-ele-take-row-15019    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15020    pic x(80) value  
                '               22:X,                      '.  
            07 ar-ele-take-row-15021    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15022    pic x(80) value  
                '               C''ALPHA'',                '.    
            07 ar-ele-take-row-15023    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15024    pic x(80) value  
                '               8,5,                       '.  
            07 ar-ele-take-row-15025    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15026    pic x(80) value  
                '               40:Z,                      '.  
            07 ar-ele-take-row-15027    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15028    pic x(80) value  
                '               3C''XYZ'',                 '.   
            07 ar-ele-take-row-15029    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15030    pic x(80) value  
                '               X''7B'',                   '.    
            07 ar-ele-take-row-15031    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15032    pic x(80) value  
                '               6Z,                        '.  
            07 ar-ele-take-row-15033    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15034    pic x(80) value  
                '               2X''3C2B3E'',              '.    
            07 ar-ele-take-row-15035    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15036    pic x(80) value  
                '               X''7D'',                   '.    
            07 ar-ele-take-row-15037    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15038    pic x(80) value  
                '               32,7,                      '.  
            07 ar-ele-take-row-15039    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15040    pic x(80) value  
                '               8X,                        '.  
            07 ar-ele-take-row-15041    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15042    pic x(80) value  
                '               C''+'',                    '.    
            07 ar-ele-take-row-15043    pic x(11) value 'somisqf12E'.
            07 ar-ele-take-row-15044    pic x(80) value  
                '               11X)                       '.  
      * 16
            07 ar-ele-take-row-16001    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-16003    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16004    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                
            07 ar-ele-take-row-16005    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16006    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                
            07 ar-ele-take-row-16007    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16008    pic x(80) value  
                ' OMIT COND=(8,2,CH,LE,X''D4D4'',AND,      '.                
            07 ar-ele-take-row-16009    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16010    pic x(80) value  
                '13,3,BI,GT,-10,OR,16,4,FI,GT,10,AND,      '.                
            07 ar-ele-take-row-16011    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16012    pic x(80) value  
                '20,8,FL,LE,40,OR,28,4,PD,LE,10,AND,       '.                
            07 ar-ele-take-row-16013    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16014    pic x(80) value  
                '32,7,ZD,GE,15)                            '.                
            07 ar-ele-take-row-16015    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16016    pic x(80) value  
                ' SUM FIELDS=(13,3,BI,    '.
            07 ar-ele-take-row-16017    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16018    pic x(80) value  
                '             16,4,FI,    '.
            07 ar-ele-take-row-16019    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16020    pic x(80) value  
                '             20,8,FL,    '.
            07 ar-ele-take-row-16021    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16022    pic x(80) value  
                '             28,4,PD,    '.
            07 ar-ele-take-row-16023    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16024    pic x(80) value  
                '             32,7,ZD,    '.
            07 ar-ele-take-row-16025    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16026    pic x(80) value  
                '             39,4,FL,    '.
            07 ar-ele-take-row-16027    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16028    pic x(80) value  
                '             43,7,CLO,   '.
            07 ar-ele-take-row-16029    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16030    pic x(80) value  
                '             50,8,CST,   '.
            07 ar-ele-take-row-16031    pic x(11) value 'somisqf13E'.
            07 ar-ele-take-row-16032    pic x(80) value  
                '             58,8,CSL)   '.
      * 15     
            07 ar-ele-take-row-17001    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17002    pic x(80) value  
                'SORT FIELDS=(34,5,CH,A)                   '.
            07 ar-ele-take-row-17003    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17004    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-17005    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17006    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                 
            07 ar-ele-take-row-17007    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17008    pic x(80) value  
                'INREC    FIELDS(1,7,              '.
            07 ar-ele-take-row-17009    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17010    pic x(80) value  
                '               32,7,              '.
            07 ar-ele-take-row-17011    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17012    pic x(80) value  
                '               20,8,              '.
            07 ar-ele-take-row-17013    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17014    pic x(80) value  
                '               16,4,              '.
            07 ar-ele-take-row-17015    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17016    pic x(80) value  
                '               28,4,              '.
            07 ar-ele-take-row-17017    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17018    pic x(80) value  
                '               13,3,              '.
            07 ar-ele-take-row-17019    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17020    pic x(80) value  
                '                8,5,              '.
            07 ar-ele-take-row-17021    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17022    pic x(80) value  
                '               39,4,              '.
            07 ar-ele-take-row-17023    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17024    pic x(80) value  
                '               43,7,              '.
            07 ar-ele-take-row-17025    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17026    pic x(80) value  
                '               50,8,              '.
            07 ar-ele-take-row-17027    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17028    pic x(80) value  
                '               58,8,              '.
            07 ar-ele-take-row-17029    pic x(11) value 'sinrsqf14E'.
            07 ar-ele-take-row-17030    pic x(80) value  
                '               66,25)             '.
      * 
      *(174 elements)
      *
      * 18
            07 ar-ele-take-row-18001    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18002    pic x(80) value  
                'SORT FIELDS=(8,5,CH,A)                    '.
            07 ar-ele-take-row-18003    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18004    pic x(80) value  
                'OUTREC FIELDS=(C''FIELD SPEC'',           '.   
            07 ar-ele-take-row-18005    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18006    pic x(80) value  
                '               11:1,7,                    '. 
            07 ar-ele-take-row-18007    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18008    pic x(80) value  
                '               22:X,                      '. 
            07 ar-ele-take-row-18009    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18010    pic x(80) value  
                '               C''ALPHA'',                '.   
            07 ar-ele-take-row-18011    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18012    pic x(80) value  
                '               8,5,                       '. 
            07 ar-ele-take-row-18013    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18014    pic x(80) value  
                '               40:Z,                      '. 
            07 ar-ele-take-row-18015    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18016    pic x(80) value  
                '               3C''XYZ'',                 '.  
            07 ar-ele-take-row-18017    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18018    pic x(80) value  
                '               X''7B'',                   '.   
            07 ar-ele-take-row-18019    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18020    pic x(80) value  
                '               6Z,                        '. 
            07 ar-ele-take-row-18021    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18022    pic x(80) value  
                '               2X''3C2B3E'',              '.   
            07 ar-ele-take-row-18023    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18024    pic x(80) value  
                '               X''7D'',                   '.   
            07 ar-ele-take-row-18025    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18026    pic x(80) value  
                '               32,7,                      '. 
            07 ar-ele-take-row-18027    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18028    pic x(80) value  
                '               8X,                        '. 
            07 ar-ele-take-row-18029    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18030    pic x(80) value  
                '               C''+'',                    '.   
            07 ar-ele-take-row-18031    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18032    pic x(80) value  
                '               11X)                       '. 
            07 ar-ele-take-row-18033    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18034    pic x(80) value  
                'USE  dd_infile     RECORD F,90 ORG SQ     '.                
            07 ar-ele-take-row-18035    pic x(11) value 'soutsqf10E'.
            07 ar-ele-take-row-18036    pic x(80) value  
                'GIVE dd_outfile    RECORD F,90 ORG SQ     '.                
      
      *      
          03 filler redefines ar-ele-take-rows 
               occurs 196 times.
           05  ar-ele-take-vet.
            07 ar-ele-take-vet-01         pic x(11).                       ** name
            07 ar-ele-take-vet-02         pic x(80).                       ** value of takefile
          
       77   ntype               BINARY-LONG .
       77   nver                pic 9(9) .
       77   cmd-go              pic x(256) value space.
           
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
           display '  gctestrun1           SORT'
           display '                       Group1'
           display '*===============================================*'
           call 'gctestgetop' using ntype, nver
           display ' Environment : ' ntype 
           display ' Version     : ' nver 
 
      *
           perform exec-all-gr01 varying idx from 1 by 1
                  until idx > ar-name-max-ele
      *     
           perform epilog-gr01
           perform epilog-calculate-gr01
           if  retcode-sum not = zero
                move 25  to RETURN-CODE
           end-if
           .
       end-99.
           goback.
           
      * 
      *
      *---------------------------------------------------------*
       exec-all-gr01              section.
      *---------------------------------------------------------*
       exal-00.
           display '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
           display '*===============================================*'
           display ' ID test : ' ar-ele-vet(idx)  "   Start "
           display '*===============================================*'
           move    ar-ele-vet(idx)    to ar-tst-name(idx)
           perform genfile-input-gr01
           perform sort-cbl-gr01
           perform sort-gc-gr01
           perform diffile-gr01
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
       epilog-gr01                section.
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
      
           perform epilog-view-gr01 
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
       epilog-view-gr01           section.
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
           display "| " ar-tst-name(idx)    "  |  "
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
       epilog-calculate-gr01      section.
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
       genfile-input-gr01         section.
      *---------------------------------------------------------*
       gein-00.
           move 'dd_outfile'          to env-set-name
           move '../files/fsqf01E.dat' to env-set-value
           perform set-value-env
           move 'genfileE' to cmd-string
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
           display  cmd-go
      ****************** 
           call     'SYSTEM' using cmd-go
      D    display  'RETURN-CODE Value : ' RETURN-CODE
      * reset 
           move 'dd_outfile'     to env-set-name
           move space            to env-set-value
           perform set-value-env
           .
       gein-99.
          exit.
      *---------------------------------------------------------*
       sort-cbl-gr01              section.
      *---------------------------------------------------------*
       stcb-00.
           move 99  to ar-tst-rtc01(idx)  
       
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01E.dat'    to env-set-value
           perform set-value-env
      ** 
           move 'dd_outfile'             to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cblE.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
           move 'dd_sortwork'            to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_srtE.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      *
      ** %exedir%\susesqf01b 
      *******     move 'susesqf01b '       to       cmd-string
           move space               to cmd-string
           string ar-ele-vet(idx) delimited by space
                  'b'             delimited by size
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
           display cmd-go
      *******************
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
      *---------------------------------------------------------*
       sort-gc-gr01               section.
      *---------------------------------------------------------*
       stgc-00.
           move 99  to ar-tst-rtc02(idx)  
      ** set dd_infile=%filedir%\fsqf01.dat 
           move 'dd_infile'              to env-set-name
           move '../files/fsqf01E.dat'    to env-set-value
           perform set-value-env
      ** set dd_outfile=%filedir%\susesqf01_gcs.srt
           move 'dd_outfile'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcsE.srt'      delimited by size
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
           perform write-takefile-gr01 
           close fcmd
      ** 
           move space              to cmd-string
           string  'gcsort '        delimited by size
                cmd-gcsort-ebcdic   delimited by size
                            'TAKE ../takefile/tmp/'
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
           display cmd-go
      *************
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
       write-takefile-gr01        section.
      *---------------------------------------------------------*
       wrta-00.
           perform write-takerecord-gr01 varying idx-take
               from 1 by 1 until (idx-take > ar-ele-take-num) 
           .    
       wrta-99.
           exit.
      * 
      *---------------------------------------------------------*
       write-takerecord-gr01      section. 
      *---------------------------------------------------------*
       wrtr-00.
           if(ar-ele-take-vet-01(idx-take) = ar-ele-vet(idx))
              move ar-ele-take-vet-02(idx-take)  to r-cmd
              write r-cmd
           .
       wrtr-99.
           exit.
      *---------------------------------------------------------*
       diffile-gr01               section.
      *---------------------------------------------------------*
       diff-00.
           move 99  to ar-tst-rtc03(idx)  
      ** set dd_incobol=%filedir%\susesqf01_cbl.srt
           move 'dd_incobol'              to env-set-name
           move space                    to env-set-value
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_cblE.srt'      delimited by size
                    into env-set-value
           perform set-value-env
      ** set dd_ingcsort=%filedir%/susesqf01_gcs.srt
           move 'dd_ingcsort'              to env-set-name
           string '../files/'       delimited by size
                    ar-ele-vet(idx) delimited by space
                    '_gcsE.srt'      delimited by size
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
           display cmd-go
      *****************
           call     "SYSTEM" using cmd-go
      *
           move  RETURN-CODE  to ar-tst-rtc03(idx)
      D    display  "RETURN-CODE Value : " RETURN-CODE
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
