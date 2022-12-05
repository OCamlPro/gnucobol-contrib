       identification division.
       program-id.   secondsbetweendatetime2.
      *************************************************************
      **** returns a 31  byte number of seconds between two valid
      **** dates and times. passed as 4 arguments :
      **** ccyymmdd hhmmss ccyymmdd hhmmss
      **** calls TEST-FORMATTED-DATETIME function for edit 
      **** checks of dates and times  
      **** always check return codes when executing  
      *************************************************************
       environment division.
       configuration section.
       source-computer.
           System76
      *           with debugging mode
           .
       repository.
           function all intrinsic.
       data division.
       working-storage section.
       01 w-d1                                              pic x(08).
       01 w-t1                                              pic x(06).
       01 w-d2                                              pic x(08).
       01 w-t2                                              pic x(06).
       01 n-d1                                              pic 9(08).
       01 n-t1                                              pic 9(06).
       01 n-d2                                              pic 9(08).
       01 n-t2                                              pic 9(06).
       01 n-2                                               pic 9(02).
       01 n-d3                                              pic 9(08).
       01 n-t3                                              pic 9(06).
       01 w-i1                                       comp-x pic x(04).
       01 w-i2                                       comp-x pic x(04).
       01 w-days                                            pic 9(07).
       01 w-seconds                                         pic s9(31).
       01 arg-knt                                    comp-5 pic x(01).
       01 seconds-per-day            value 86400            pic 9(05).
       01 seconds-per-hour           value 3600             pic 9(04).
       01 seconds-per-min            value 60               pic 9(02).
       01 tfd                                               pic 9(08). 
       procedure division.
           accept arg-knt from argument-number
           if  arg-knt <> 4
               display 'four arguments are required:' upon SYSERR
               display ' 1. first  date ccyymmdd'    upon SYSERR
               display ' 2. first  time hhmmss'    upon SYSERR
               display ' 3. second date ccyymmdd'    upon SYSERR
               display ' 4. second time hhmmss'    upon SYSERR
               goback returning -1
           end-if
           accept w-d1 from argument-value
           accept w-t1 from argument-value
           accept w-d2 from argument-value
           accept w-t2 from argument-value
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd 
           if  tfd not = 0
               display "Date 1 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd 
           end-if    
           move w-d1 to n-d1
           move test-formatted-datetime("hhmmss", w-t1) to tfd
           if  tfd not = 0
               display "Time 1 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd
           end-if
           move w-t1 to n-t1
           move test-formatted-datetime("YYYYMMDD", w-d2) to tfd
           if  tfd not = 0
               display "Date 2 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd
           end-if
           move w-d2 to n-d2
           move test-formatted-datetime("hhmmss", w-t2) to tfd
           if  tfd not = 0
               display "Time 2 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd
           end-if
           move w-t2 to n-t2
           if  n-d1 greater than n-d2
               move n-d1 to n-d3
               move n-t1 to n-t3
               move n-d2 to n-d1
               move n-t2 to n-t1
               move n-d3 to n-d2
               move n-t3 to n-t2
           end-if
           move integer-of-date(n-d1) to w-i1
           move integer-of-date(n-d2) to w-i2
           compute w-days = w-i1 - w-i2
           end-compute
           compute w-seconds = (w-days * seconds-per-day)
           end-compute
      *    display w-seconds
           move  n-t1(1:2)  to n-2
           compute w-seconds = (w-seconds - (n-2 * seconds-per-hour))
           end-compute
           move  n-t1(3:2)  to n-2
           compute w-seconds = (w-seconds - (n-2 * seconds-per-min))
           end-compute
           move  n-t1(5:2)  to n-2
           compute w-seconds = (w-seconds - n-2)
           end-compute
           move  n-t2(1:2)  to n-2
           compute w-seconds = (w-seconds + (n-2 * seconds-per-hour))
           end-compute
           move  n-t2(3:2)  to n-2
           compute w-seconds = (w-seconds + (n-2 * seconds-per-min))
           end-compute
           move  n-t2(5:2)  to n-2
           compute w-seconds = (w-seconds + n-2)
           end-compute
           if  w-seconds less than 0
               compute w-seconds = (w-seconds * -1)
               end-compute
           end-if
           display w-seconds
           move 0 to return-code
           goback
           .
