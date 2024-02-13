       identification division.                                         
       program-id.    sbrdatex.                               
      *************************************************
      **** input parameter will be added to current date
      **** returns date X days after run date.
      **** compile: cobc -m sbrdatex.cbl -std=mf
      **** two parameters.
      **** 1. number days to add to the current date
      **** 2. returned new date with arithmetic applied
      **** called from other program passing number of days
      **** in seven-inx parameter to be added to the current date
      **** returns new date X days past current date
      **** in the eight-outn parameter 
      **** ALWAYS Check return-code
      **** Dedicated to the public domain.
      *************************************************
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
       01 wi                                      comp-x   pic x(08).
       01 arg-alph-in            value spaces              pic x(07).
       01 arg-numeric            value zeroes              pic 9(07).
       01 num-ss                                  comp-5   pic x(02).
       01 alph-ss                                 comp-5   pic x(02).
       linkage section.
       01 seven-inx                                       pic x(07).
       01 eight-outn                                      pic 9(08).
       procedure division using seven-inx, eight-outn.
           move current-date to dx
           move integer-of-date(dn) to wi
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
               display "argument not numeric " upon syserr 
               move zeroes to eight-outn
               goback returning -3
           end-if
           add arg-numeric to wi
           move date-of-integer(wi) to eight-outn 
           move zeroes to return-code
           goback                                                       
           .                                                            
