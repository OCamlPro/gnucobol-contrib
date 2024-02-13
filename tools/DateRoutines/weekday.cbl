       identification division.
       program-id.   weekday.
      *************************************************************
      **** returns day of week name with valid yyyymmdd input argument  
      **** compile: cobc -x weekday.cbl -std=mf
      **** run: weekday ccyymmdd 
      **** example: weekday 20240212   
      **** returns from sysout on next line: MONDAY   
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
       procedure division.
           accept arg-knt from argument-number
           if  arg-knt <> 1
               display "One valid date yyyymmdd required" upon syserr
               goback returning -1
           end-if
           accept x-d1 from argument-value
           move test-formatted-datetime("YYYYMMDD", x-d1) to n-d1 
           if  n-d1 not = 0
               display "Date  invalid" upon syserr
               display "Error code = " n-d1 upon syserr
               goback returning n-d1 
           end-if    
           move x-d1 to n-d1
           move integer-of-date(n-d1) to int-day 
           move mod(int-day, 7) to w-day
           evaluate w-day
                   when = 0 display "SUNDAY"     
                   when = 1 display "MONDAY"     
                   when = 2 display "TUESDAY"     
                   when = 3 display "WEDNESDAY"     
                   when = 4 display "THURSDAY"     
                   when = 5 display "FRIDAY"     
                   when = 6 display "SATURDAY"     
                   when other 
                       display "Bad w-day mod = " w-day upon syserr
                       goback returning w-day
           end-evaluate                
           move 0 to return-code
           goback
           .
