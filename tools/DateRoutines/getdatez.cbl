       identification division.
       program-id.             getdatez.
      *********************************************************
      **** this program will add or subtract a number of days
      **** for the gregorian date that is passed to this program.
      **** three input arguments.
      **** 1. valid gregorian date: ccyymmdd
      **** 2. plus or minus sign for arithmetic function 
      **** 3. number days to add/subtract from passed date argument (max seven digits)
      **** returns gregorian date X days from/to passed date
      **** some minor edits are done 
      **** compile: cobc -x getdatex.cbl -std=mf
      **** run: getdatez 20241231 + 31 
      **** returns from sysout on next line: 20250131  
      **** some minor edits are done 
      **** ALWAYS Check return-code
      **** Dedicated to the public domain.
      *********************************************************
       environment division.
       configuration section.
       source-computer.
           System76.
       repository.
           function all intrinsic.
       data division.
       working-storage section.
       01 dx                                               pic x(08).
       01 d9 redefines dx                                  pic 9(08).
       01 arg-alph-in            value spaces              pic x(07).
       01 arg-numeric            value zeroes              pic 9(07).
       01 arg-knt                                 comp-5   pic x(02).
       01 num-ss                                  comp-5   pic x(02).
       01 alph-ss                                 comp-5   pic x(02).
       01 w-d1                                             pic x(08).
       01 w-plus-minus                                     pic x(01).
          88 sign-add            value '+'.
          88 sign-minus          value '-'.
       01 n-d1                                              pic 9(08).
       01 w-i1                                       comp-x pic x(04).
       01 tfd                                               pic 9(08).
       procedure division.
           accept arg-knt from argument-number
           if  arg-knt not = 3
               display 'usage: getdatez <arg list 3>' upon syserr
               move 1 to return-code
               goback 
           end-if
           accept w-d1 from argument-value
           move test-formatted-datetime("YYYYMMDD", w-d1) to tfd
           if  tfd not = 0
               display "Date 1 invalid" upon syserr
               display "Error code = " tfd upon syserr
               goback returning tfd
           end-if
           move w-d1 to n-d1
           accept w-plus-minus from argument-value
           if  (w-plus-minus = '+' or '-')
               continue
           else
               display ' arthimatic operation not + or - ' upon syserr
               move 5 to return-code
               goback
           end-if
           accept arg-alph-in from argument-value
           move 7 to num-ss
           perform test after varying alph-ss
             from 7 by -1
             until alph-ss = 1
             if  arg-alph-in(alph-ss:1) not = space
                 move arg-alph-in(alph-ss:1) to arg-numeric(num-ss:1)
                 subtract 1 from num-ss
             end-if
           end-perform
           if  arg-numeric not numeric
               display 'operand not numeric ' upon syserr
               move 6 to return-code
               goback
           end-if
           move integer-of-date(n-d1) to w-i1
           if  sign-add
               add arg-numeric to w-i1
           else
              subtract arg-numeric from w-i1
           end-if
           move date-of-integer(w-i1) to d9
           display dx
           move 0 to return-code
           goback
           .
