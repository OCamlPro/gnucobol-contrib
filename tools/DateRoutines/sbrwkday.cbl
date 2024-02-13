       identification division.
       program-id.   sbrwkday.
      *************************************************************
      **** returns day of week name with valid yyyymmdd input parameter  
      **** compile: cobc -m weekday.cbl -std=mf
      **** two parameters.
      **** 1. valid gregorain date ccyymmdd
      **** 2. returns name of weekday
      **** called from other program passing valid date in gdate-inx parameter
      **** returns name of week day in wkday-outx
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
       01 x-d1                                            pic x(08).
       01 n-d1                                            pic 9(08). 
       01 int-day                                         pic s9(07).
       01 w-day                                           pic 9(07).
       01 arg-knt                                  comp-5 pic x(01).
       linkage section.
       01 gdate-inx                                       pic x(08).
       01 wkday-outx                                      pic x(09).
       procedure division using gdate-inx, wkday-outx.
           move gdate-inx to x-d1
           move test-formatted-datetime("YYYYMMDD", x-d1) to n-d1 
           if  n-d1 not = 0
               display "Date  invalid" upon syserr
               display "Error code = " n-d1 upon syserr
               move spaces to wkday-outx
               goback returning n-d1 
           end-if    
           move x-d1 to n-d1
           move integer-of-date(n-d1) to int-day 
           move mod(int-day, 7) to w-day
           evaluate w-day
                   when = 0 move "SUNDAY"    to wkday-outx  
                   when = 1 move "MONDAY"    to wkday-outx     
                   when = 2 move "TUESDAY"   to wkday-outx  
                   when = 3 move "WEDNESDAY" to wkday-outx    
                   when = 4 move "THURSDAY"  to wkday-outx   
                   when = 5 move "FRIDAY"    to wkday-outx 
                   when = 6 move "SATURDAY"  to wkday-outx   
                   when other 
                       display "Bad w-day mod = " w-day upon syserr
                       move spaces to wkday-outx
                       goback returning w-day
           end-evaluate                
           move 0 to return-code
           goback
           .
