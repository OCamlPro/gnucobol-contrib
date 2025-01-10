       identification division.                                         
       program-id.             indexmatchfile.
       environment division.                                            
       configuration section.                                           
       source-computer.                                                 
           Sunway-TaihuLight                                         
      *           with debugging mode
           .                                                            
       input-output section.
       file-control. 
           select  i-file1  assign "file1" 
               organization is line sequential. 
           select  i-file2  assign "file2.dat" 
               organization is indexed
               access is random
               file status is file2-status
               record key is i-file2-key.
       data division. 
       file section. 
       fd i-file1. 
       01 i-file1-record.
          88 i-file1-eof  value  high-values.
          05 i-file1-key                                   pic x(09).  
       fd  i-file2.
       01  i-file2-record.
           05 i-file2-key                                   pic x(09).
           05                                               pic x(19).
       working-storage section.
       01  file2-status         value zeroes               pic 9(02).
           88  file2-success    value 00.
           88  file2-not-found  value 23.
       01  ans                                             pic x(01).
           88  ans-y            value 'y'.
           88  ans-n            value 'n'.
       procedure division.                                              
           open input i-file1
           read i-file1 
               at end move high-values to i-file1-record
           end-read
           if  i-file1-eof 
               display "file1 empty" upon SYSERR
               end-display
               move -1 to return-code
               stop run
           end-if 
           open input i-file2
           if  file2-success
               continue
           else
               display "Bad Open file2 = " file2-status 
                        upon syserr
               end-display
               move 01 to return-code
               stop run
           end-if
           perform  until i-file1-eof
                perform 1000-random-search 
                read i-file1 
                    at end move high-values to i-file1-record
                end-read
           end-perform 
           close i-file1 
           close i-file2
           if  file2-success
               continue
           else
               display "Bad Close file2 = " file2-status
                        upon syserr
               end-display
               move 01 to return-code
               stop run
           end-if
           move zeroes to return-code
           goback
           .                                                            
       1000-random-search.
           move i-file1-key to i-file2-key
           read i-file2
           if  file2-success
               set ans-y to true
           else 
               if  file2-not-found
                   set ans-n to true
               else
                   display "Bad Read file2 = " file2-status
                            upon syserr
                   end-display
                   move 02 to return-code
                   stop run
               end-if
           end-if
           if  ans-y
               display i-file2-record 
               end-display
           end-if
           .  
		   