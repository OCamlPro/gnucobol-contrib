       identification division.
       program-id.             bio2.
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
       01 w-d2                                              pic x(08).
       01 n-d1                                              pic 9(08).
       01 n-d2                                              pic 9(08).
       01 w-i1                                       comp-x pic x(04).
       01 w-i2                                       comp-x pic x(04).
       01 w-days                                            pic 9(07).
       01 arg-knt                                    comp-5 pic x(01).
       01 bx                                       pic 9.    
       01 bio-tbl  value 'Physical 23Emotional28Mental   33'.
               05  bio-entry  occurs 3 times.
                   10  bio-cyc                     pic x(09).
                   10  bio-lth                     pic 9(02).
       01 bio-data occurs 3 times.
          05  bio-mod                              pic 9(02).
          05  bio-sin                              pic s999v9.     
          05  bio-dsc                              pic x(09). 
       01 tfd                                      pic 9(09).    

       procedure division.
           accept arg-knt from argument-number
           if arg-knt <> 2
           then
            display 'two arguments are required:' upon SYSERR
            display ' 1. first  date ccyymmdd'    upon SYSERR
            display ' 2. second date ccyymmdd'    upon SYSERR
            stop run returning -1
           end-if
           accept w-d1 from argument-value
           accept w-d2 from argument-value
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd
           if  tfd not = 0
               display "Date 1 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd
           end-if
           move w-d1 to n-d1
           move test-formatted-datetime("YYYYMMDD", w-d2) to tfd
           if  tfd not = 0
               display "Date 2 invalid" upon SYSERR
               display "Error code = " tfd upon SYSERR
               goback returning tfd
           end-if
           move w-d2 to n-d2
           move integer-of-date(n-d1) to w-i1
           move integer-of-date(n-d2) to w-i2
           compute w-days = w-i1 - w-i2
           display w-days
           perform  varying  bx from 1 by 1 until bx greater than 3 
               move mod(w-days, bio-lth(bx)) to bio-mod(bx) 
               compute bio-sin(bx) rounded 
                  = 100 * sin(2 * PI * bio-mod(bx) / bio-lth(bx)) 
               end-compute
               display bio-cyc(bx) " " 
                       bio-mod(bx) ":" 
                       bio-sin(bx) "%" with no advancing 
               end-display                 
               if  bio-sin(bx) > 95
                   move  " peak" to bio-dsc(bx)
               end-if 
               if  bio-sin(bx) < -95
                   move  " valley" to bio-dsc(bx)
               end-if   
               if  abs(bio-sin(bx)) < 5
                   move " critical" to bio-dsc(bx)  
               end-if        
               display bio-dsc(bx)  
           end-perform
           move 0 to return-code
           goback
           .

