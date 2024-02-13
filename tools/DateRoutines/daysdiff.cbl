       identification division.
       program-id.   daysdiff.
      *************************************************************
      **** returns to sysout an 8 byte number of days between two 
      **** valid dates 
      **** format is: ccyymmdd ccyymmdd 
      **** calls TEST-FORMATTED-DATETIME function for edits checks
      **** of valid dates entered on command line  
      **** compile: cobc -x daysdiff.cbl -std=mf  
      **** run: daysdiff ccyymmdd ccyymmdd 
      **** example: daysdiff 20010101 20240101 
      **** writes to sysout: 0008400
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
       procedure division.
           accept arg-knt from argument-number
           if  arg-knt <> 2
               display 'two arguments are required:' upon syserr
               display ' 1. first  date ccyymmdd'    upon syserr
               display ' 2. second date ccyymmdd'    upon syserr
               goback returning -1
           end-if
           accept w-d1 from argument-value
           accept w-d2 from argument-value
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd 
           if  tfd not = 0
               display "Date 1 invalid" upon syserr
               display "Error code = " tfd upon syserr
               goback returning tfd 
           end-if    
           move w-d1 to n-d1
           move test-formatted-datetime("YYYYMMDD", w-d2) to tfd
           if  tfd not = 0
               display "Date 2 invalid" upon syserr
               display "Error code = " tfd upon syserr
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
           display w-days
           move 0 to return-code
           goback
           .
