       identification division.
       program-id.             createfile2.
       environment division.
       configuration section.
       source-computer.
           System76 
      *           with debugging mode
           .
       input-output section.
       file-control.
           select  s  assign to dummy. 
       data division.
       file section.
       sd s. 
       01 s-rec. 
          88 s-eof  value high-values.
          05 s-rec-num-ran   pic v9(09).
          05 s-rec-rnum-ran  pic v9(18). 
          05 s-rec-data-out  pic x(01). 
       working-storage section.
       01  num-ran           pic v9(09) value zeroes.
       01  rnum-ran          pic v9(18) value zeroes.
       01  re-num-ran        pic 9.9(09) value zeroes.
       01  rr-num-ran        pic v9(09) value zeroes.
       01  rr-num-ran1       pic v9(09) value zeroes.
       01  seed              pic s9(09) binary.
       01  datetime21        pic x(21).
       01  data-name. 
           05 value "A"      pic x(01).
           05 value "B"      pic x(01).
           05 value "C"      pic x(01).
           05 value "D"      pic x(01).
           05 value "E"      pic x(01).
           05 value "F"      pic x(01).
           05 value "G"      pic x(01).
           05 value "H"      pic x(01).
           05 value "I"      pic x(01).
       01  data-table redefines data-name. 
           05 data-field occurs 9 times pic x(01).
       01  data-out     pic x(01). 
       01  data-value   pic 9(01).
       01  o-rec.
           05 o-rec-num-ran  pic v9(09).
           05 o-rec-rnum-ran pic v9(18).
           05 o-rec-data-out pic x(01).
       procedure division.
           move function current-date to datetime21 
           move datetime21(8:9) to seed
           compute num-ran = function random (seed) 
           end-compute
           sort s 
                ascending key s-rec-num-ran
                input  procedure 1000-sortin
                output procedure 2000-sortout
           move zeroes to return-code
           goback
           .
       1000-sortin.
           perform 350000000 times  *> creates about a 7.3 Gig file
      *> **perform 050000000 times  *> creates about a 1.4 Gig file   
               move num-ran to re-num-ran
               compute num-ran = function random () 
               end-compute
               move re-num-ran to rr-num-ran
               compute rr-num-ran1 = (rr-num-ran - 1) 
               end-compute
               compute rnum-ran = num-ran * rr-num-ran1 
               end-compute
               move rnum-ran(18:1) to data-value
               if  data-value not equal 9
                   add 1 to data-value
                   end-add
               end-if
               move data-field(data-value) to data-out(1:)
               move num-ran to s-rec-num-ran
               move rnum-ran to s-rec-rnum-ran
               move data-out to s-rec-data-out
               release s-rec  
           end-perform 
           .
       2000-sortout.
           return s 
               at end 
               set s-eof to true
           end-return
           move low-values to o-rec. 
           perform until s-eof
               if  s-rec-num-ran not equal o-rec-num-ran
                   display s-rec
                   move s-rec to o-rec
               end-if
               return s 
                   at end
                   set s-eof to true
               end-return
           end-perform
           .      
		   