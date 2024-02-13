       identification division.
       program-id.             getdatey.
      *************************************************
      **** input argument will be subtracted from current date
      **** returns date X days before run date.
      **** compile: cobc -x getdatey.cbl -std=mf
      **** run: getdatey 31
      **** returns new date 31 days before current date
      **** example for running on the current date of 20240212
      **** execute example: getdatey 31
      **** returns from sysout on next line: 20240112
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
       01 arg-knt                                 comp-5   pic x(02).
       01 num-ss                                  comp-5   pic x(02).
       01 alph-ss                                 comp-5   pic x(02).
       procedure division.
           move current-date to dx
           move integer-of-date(dn) to wi
           accept arg-knt from argument-number
           if  arg-knt not = 1
               display "usage: getdatey <arg list 1>"
               upon syserr
               display "enter number of days to subtract " 
                      "from current date"  
               upon syserr
               stop run returning -1
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
               display "argument not numeric " upon syserr
               stop run returning -3
           end-if
           subtract  arg-numeric from wi
           move date-of-integer(wi) to dn
           display dx
           move zeroes to return-code
           goback 
           .
