       identification division.
       program-id.    sbrdatez.
      *********************************************************
      **** this program will add or subtract a number of days
      **** for the gregorian date that is passed to this program.
      **** compile: cobc -m sbrdatez.cbl -std=mf
      **** four parameters.
      **** 1. valid gregorian date: ccyymmdd
      **** 2. plus or minus sign for arithmetic function
      **** 3. number days to add/subtract from date parameter
      **** 4. returned new date with arithmetic applied
      **** returns gregorian date X days from/to passed date.
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
       01 dn redefines dx                                  pic 9(08).
       01 arg-alph-in            value spaces              pic x(07).
       01 arg-numeric            value zeroes              pic 9(07).
       01 num-ss                                  comp-5   pic x(02).
       01 alph-ss                                 comp-5   pic x(02).
       01 w-d1                                             pic x(08).
       01 w-plus-minus                                     pic x(01).
          88 sign-add            value '+'.
          88 sign-minus          value '-'.
       01 n-d1                                              pic 9(08).
       01 w-i1                                       comp-x pic x(04).
       01 tfd                                               pic 9(08).
       linkage section.
       01 gdate-inx                                         pic x(08).
       01 sign-inx                                          pic x(01).
       01 seven-inx                                         pic x(07).
       01 eight-outn                                        pic 9(08).
       procedure division using gdate-inx, sign-inx,
                                seven-inx, eight-outn.
           move gdate-inx to dx
           move test-formatted-datetime("YYYYMMDD", dn) to tfd
           if  tfd not = 0
               display "Date invalid" upon syserr
               display "Error code = " tfd upon syserr
               move zeroes to eight-outn
               goback returning tfd
           end-if
           move dn to n-d1
           move sign-inx to  w-plus-minus 
           if  (w-plus-minus = '+' or '-')
               continue
           else
               display 'Arthimatic operation not + or - ' upon syserr 
               move 5 to return-code
               move zeroes to eight-outn
               goback
           end-if
           move seven-inx to arg-alph-in
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
               move zeroes to eight-outn
               move 6 to return-code
               goback
           end-if
           move integer-of-date(n-d1) to w-i1
           if  sign-add
               add arg-numeric to w-i1
           else
              subtract arg-numeric from w-i1
           end-if
           move date-of-integer(w-i1) to dn
           move dn to eight-outn
           move 0 to return-code
           goback
           .
