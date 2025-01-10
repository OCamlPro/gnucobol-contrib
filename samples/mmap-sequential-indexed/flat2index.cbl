       identification division.
       program-id.             flat2index.
       environment division.                                            
       configuration section.                                           
       source-computer.                                                 
           cray-1
      *           with debugging mode
           .                                                            
       input-output section.
       file-control.
           select i assign  to i-nam 
               organization is line sequential.
           select o assign  to o-nam
               organization is indexed
               access       is sequential
               record key   is o-key.
       data division.                                                   
       file section.
       fd  i.
       01  i-record.          
           05 i-rec                                        pic x(29).
            88 i-eof value high-values.
       fd  o.
       01  o-rec.
           05 o-key                                        pic 9(09).
           05                                              pic x(19).
       working-storage section.
       01  arg-knt                                comp-5   pic x(01).
       procedure division.
       0000-mainline.
           perform 9000-init
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
       9000-init.
           accept arg-knt from argument-number
           if  arg-knt <> 2
               display 'two arguments are required' upon SYSERR
               display '1: name of flat file'       upon SYSERR
               display '2: name of ksds file'       upon SYSERR
               move -1 to return-code
               stop run
           end-if
           accept i-nam from argument-value
           accept o-nam from argument-value
           . 
		   