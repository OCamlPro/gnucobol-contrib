       identification division.
       program-id.             flat2index1001.
       environment division.                                            
       configuration section.                                           
       source-computer.                                                 
           cray-1
      *           with debugging mode
           .                                                            
       input-output section.
       file-control.
           select i assign  to "testfile1001.txt"
               organization is line sequential.
           select o assign  to "testfile1001.dat"
               organization is indexed
               access       is sequential
               record key   is o-key.
       data division.                                                   
       file section.
       fd  i.
       01  i-record.          
           05 i-rec                                        pic x(121).
            88 i-eof value high-values.
       fd  o.
       01  o-rec.
           05 o-key                                        pic 9(009).
           05                                              pic x(112).
       working-storage section.
       procedure division.
       0000-mainline.
           open input i,
                output o
           read i
               at end
               set i-eof to true
           end-read
           perform until i-eof
               move i-rec to o-rec
               write o-rec 
               read i
                  at end
                  set i-eof to true
               end-read
           end-perform
           close i, o
           move zeroes to return-code
           goback
           .
