       identification division.
       program-id.   sbrdydff.
      *************************************************************
      **** returns a 7 byte number of days between two valid dates
      **** format is: ccyymmdd ccyymmdd 
      **** compile: cobc -m sbrdydff.cbl -std=mf  
      **** three parameters.
      **** 1. valid gregorian date
      **** 2. valid gregorian date
      **** 3. number of days difference between the two dates
      **** called from other program passing two dates and 
      **** getting the absolute value of the difference in number 
      **** of days between the two 
      **** calls TEST-FORMATTED-DATETIME function for edits checks
      **** always check return codes when executing  
      **** Dedicated to the public domain.
      *************************************************************
       environment division.
       configuration section.
       source-computer.
           System76.
       repository.
           function all intrinsic.
       data division.
       working-storage section.
       01 w-d1                                              pic x(08).
       01 w-d2                                              pic x(08).
       01 n-d1                                              pic 9(08).
       01 n-d2                                              pic 9(08).
       01 n-2                                               pic 9(02).
       01 n-d3                                              pic 9(08).
       01 w-i1                                       comp-x pic x(04).
       01 w-i2                                       comp-x pic x(04).
       01 w-days                                            pic 9(07).
       01 arg-knt                                    comp-5 pic x(01).
       01 tfd                                               pic 9(08). 
       linkage section.
       01 gdate1-inx                                        pic x(08). 
       01 gdate2-inx                                        pic x(08). 
       01 seven-outn                                        pic 9(07).
       procedure division using gdate1-inx, gdate2-inx, seven-outn. 
           move gdate1-inx to w-d1
           move gdate2-inx to w-d2
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd 
           if  tfd not = 0
               display "Date 1 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to seven-outn
               goback returning tfd 
           end-if    
           move w-d1 to n-d1
           move test-formatted-datetime("YYYYMMDD", w-d2) to tfd
           if  tfd not = 0
               display "Date 2 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to seven-outn
               goback returning tfd
           end-if
           move w-d2 to n-d2
           if  n-d1 greater than n-d2
               move n-d1 to n-d3
               move n-d2 to n-d1
               move n-d3 to n-d2
           end-if
           move integer-of-date(n-d1) to w-i1
           move integer-of-date(n-d2) to w-i2
           compute w-days = w-i1 - w-i2
           end-compute
           move w-days to seven-outn
           move 0 to return-code
           goback
           .
