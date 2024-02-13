       identification division.
       program-id.   sbrsbdt2.
      *************************************************************
      **** returns a 31  byte number of seconds between two valid
      **** dates and times. passed as 4 parameters:
      **** ccyymmdd hhmmss ccyymmdd hhmmss
      **** returns the number of seconds between the two date/times
      **** five parameters:
      **** 1. first valid gregorian date: ccyymmdd
      **** 2. first valid time: hhmmss
      **** 3. second valid gregorian date: ccyymmdd
      **** 4. second valid time: hhmmss
      **** 5. returned number of seconds between the to date-times pic s9(31) 
      **** output parameter diffsecs-outn 32 bytes
      **** calls TEST-FORMATTED-DATETIME function for edit 
      **** checks of dates and times  
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
       linkage section.
       01 gdate1-inx                                        pic x(08). 
       01 time1-inx                                         pic x(06).
       01 gdate2-inx                                        pic x(08).  
       01 time2-inx                                         pic x(06).
       01 diffsecs-outn                                     pic s9(31). 
       procedure division using gdate1-inx, time1-inx,
                                gdate2-inx, time2-inx, 
                                diffsecs-outn.
           move gdate1-inx to w-d1
           move time1-inx  to w-t1
           move gdate2-inx to w-d2
           move time2-inx  to w-t2
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd 
           if  tfd not = 0
               display "Date 1 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to diffsecs-outn
               goback returning tfd 
           end-if    
           move w-d1 to n-d1
           move test-formatted-datetime("hhmmss", w-t1) to tfd
           if  tfd not = 0
               display "Time 1 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to diffsecs-outn
               goback returning tfd
           end-if
           move w-t1 to n-t1
           move test-formatted-datetime("YYYYMMDD", w-d2) to tfd
           if  tfd not = 0
               display "Date 2 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to diffsecs-outn
               goback returning tfd
           end-if
           move w-d2 to n-d2
           move test-formatted-datetime("hhmmss", w-t2) to tfd
           if  tfd not = 0
               display "Time 2 invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to diffsecs-outn
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
           move w-seconds to diffsecs-outn
           move 0 to return-code
           goback
           .
