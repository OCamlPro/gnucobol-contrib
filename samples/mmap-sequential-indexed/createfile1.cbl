       identification division.
       program-id.             createfile1.
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
          05 s-rec-key         pic v9(9). 
       working-storage section.
       01  num-ran             pic v9(9)  value zeroes.
       01  seed                pic s9(9)  binary.
       01  datetime21          pic x(21).
       procedure division.
           move function current-date to datetime21 
           move datetime21(8:9) to seed
           compute num-ran = function random (seed) 
           end-compute
           sort s 
                ascending key s-rec-key
                input  procedure 1000-sortin
                output procedure 2000-sortout
           move zeroes to return-code
           goback
           .     
       1000-sortin.  
           perform 100000 times  
               compute num-ran = function random () 
               end-compute
               move num-ran to s-rec
               release s-rec
           end-perform 
           . 
       2000-sortout.
           return s 
               at end
               set s-eof to true
           end-return
           move zeroes to num-ran
           perform until s-eof
               if  s-rec not equal num-ran
                   display s-rec
                   move s-rec to num-ran
               end-if
               return s
                   at end
                   set s-eof to true
               end-return
           end-perform 
           . 
		   