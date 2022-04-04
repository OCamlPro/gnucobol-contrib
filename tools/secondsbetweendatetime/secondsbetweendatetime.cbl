       identification division.
       program-id.   secondsbetweendatetime.
      *************************************************************
      **** returns a 31  byte number of seconds between two valid
      **** dates and times. passed as 4 arguments :
      **** ccyymmdd hhmmss ccyymmdd hhmmss
      **** some edits on dates and times for correct numerics.
      **** always check return codes after execution.
      *************************************************************
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
       procedure division.
      *    display ' enter date ccyymmdd time hhmmss (24 hours)'
      *    display ' first date and time and then second set'
           accept arg-knt from argument-number
           if  arg-knt <> 4
               display 'four arguments are required:' upon SYSERR
               display ' 1. first  date ccyymmdd'    upon SYSERR
               display ' 2. first  time hhmmss'    upon SYSERR
               display ' 3. second date ccyymmdd'    upon SYSERR
               display ' 4. second time hhmmss'    upon SYSERR
               stop run returning -1
           end-if
           accept w-d1 from argument-value
           if  w-d1 not numeric
               display ' first date not numeric ' upon syserr
               move 2 to return-code
               stop run
           end-if
           move w-d1 to n-d1
           if  (n-d1 > 99991231)
               display ' first date must be less than 99991232'
                       upon syserr
               move 3 to return-code
               stop run
           end-if
           if  (n-d1 < 16010101)
               display ' first date must be greater than 16010100'
                       upon syserr
               move 4 to return-code
               stop run
           end-if
           if  ((n-d1(5:2) = '00')
               or
                (n-d1(5:2) > '12'))
               display ' invalid month for first date ' upon syserr
               move 5 to return-code
               stop run
           end-if
           if  ((n-d1(7:2) = '00')
               or
                (n-d1(7:2) > '31'))
               display ' invalid day for first date ' upon syserr
               move 6 to return-code
               stop run
           end-if
           accept w-t1 from argument-value
           if  w-t1 not numeric
               display ' first time not numeric ' upon syserr
               move 21 to return-code
               stop run
           end-if
           move w-t1 to n-t1
           if  n-t1 > 235959
               display ' first time must be less than 235959'
                       upon syserr
               move 31 to return-code
               stop run
           end-if
           if  n-t1(1:2) > '23'
               display ' invalid hour for first time ' upon syserr
               move 51 to return-code
               stop run
           end-if
           if  n-t1(3:2) > '59'
               display ' invalid min  for first time ' upon syserr
               move 61 to return-code
               stop run
           end-if
           if  n-t1(5:2) > '59'
               display ' invalid sec  for first time ' upon syserr
               move 71 to return-code
               stop run
           end-if
           accept w-d2 from argument-value
           if  w-d2 not numeric
               display 'second date not numeric ' upon syserr
               move 12 to return-code
               stop run
           end-if
           move w-d2 to n-d2
           if  (n-d2 > 99991231)
               display ' second date must be less than 99991232'
                       upon syserr
               move 13 to return-code
               stop run
           end-if
           if  (n-d2 < 16010101)
               display ' second date must be greater than 16010100'
                       upon syserr
               move 14 to return-code
               stop run
           end-if
           if  ((n-d2(5:2) = '00')
               or
                (n-d2(5:2) > '12'))
               display ' invalid month for second date ' upon syserr
               move 15 to return-code
               stop run
           end-if
           if  ((n-d2(7:2) = '00')
               or
                (n-d2(7:2) > '31'))
               display ' invalid day for second date ' upon syserr
               move 16 to return-code
               stop run
           end-if
           accept w-t2 from argument-value
           if  w-t2 not numeric
               display ' second time not numeric ' upon syserr
               move 22 to return-code
               stop run
           end-if
           move w-t2 to n-t2
           if  n-t2 > 235959
               display ' second time must be less than 235959'
                       upon syserr
               move 32 to return-code
               stop run
           end-if
           if  n-t2(1:2) > '23'
               display ' invalid hour for second time ' upon syserr
               move 52 to return-code
               stop run
           end-if
           if  n-t2(3:2) > '59'
               display ' invalid min  for second time ' upon syserr
               move 62 to return-code
               stop run
           end-if
           if  n-t2(5:2) > '59'
               display ' invalid sec  for second time ' upon syserr
               move 72 to return-code
               stop run
           end-if
           move w-d1 to n-d1
           move w-d2 to n-d2
           if  n-d1 greater than n-d2
               move n-d1 to n-d3
               move n-t1 to n-t3
               move n-d2 to n-d1
               move n-t2 to n-t1
               move n-d3 to n-d2
               move n-t3 to n-t2
           end-if
           move function integer-of-date(n-d1) to w-i1
           move function integer-of-date(n-d2) to w-i2
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
