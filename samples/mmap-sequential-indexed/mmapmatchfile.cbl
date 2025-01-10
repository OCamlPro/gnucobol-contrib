       identification division.
       program-id.             mmapmatchfile.
       environment division.
       configuration section.
       source-computer.
           System76 
      *           with debugging mode
           .
       input-output section.
       file-control.
           select  i-file1  assign "file1"
               organization is line sequential.
       data division.
       file section.
       fd i-file1.
       01 i-file1-rec.
          88 i-file1-eof  value  high-values.
          05 i-file1-key                                    pic x(09).
       working-storage section.
       01 mmap-hndl                                         pic x(04).
       01 mmap-hndl-x redefines mmap-hndl            comp-5 pic x(04).
       77 mmap-size                                  comp-x pic x(08).
       77 mmap-qnty                                  comp-5 pic x(08).
       77 mmap-ptr                                            pointer.
       77 len1                                       comp-x pic x(04).
       77 flag1                                      comp-x pic x(01).
       77 fl2-lo                                     comp-5 pic x(08).
       77 fl2-hi                                     comp-5 pic x(08).
       77 fl2-mid                                    comp-5 pic x(08).
       77                                                   pic x(01).
          88 fl2-found value high-value false low-value.
       linkage section.
       01 mmap-table.
          05 mmap-rec occurs 2 times
                      depending on mmap-qnty
                      ascending key mmap-key.
             10 mmap-key.
                15 mmap-num-ran                            pic x(09).
             10 mmap-rnum-ran                              pic x(18).
             10 mmap-data-out                              pic x(01).
             10                                            pic x(01).
       procedure division.
           perform 9000-init
           open input i-file1
           read i-file1
               at end move high-values to i-file1-rec
           end-read
           if  i-file1-eof
               display "file1 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           perform  until i-file1-eof
                perform 1000-binary-search
                read i-file1
                    at end move high-values to i-file1-rec
                end-read
           end-perform
           close i-file1
           move zeroes to return-code
           goback
           .
       1000-binary-search.
           set fl2-found          to false
           move 1                 to fl2-lo
           move mmap-qnty         to fl2-hi
           perform until ( (fl2-lo > fl2-hi) or (fl2-found) )
               compute fl2-mid = (fl2-lo + fl2-hi) / 2
               end-compute
               evaluate true
                  when mmap-key(fl2-mid)  >  i-file1-key
                       subtract 1 from fl2-mid giving fl2-hi
                       end-subtract
                  when mmap-key(fl2-mid)  <  i-file1-key
                       add      1 to   fl2-mid giving fl2-lo
                       end-add
                  when other
                       display mmap-num-ran(fl2-mid)
                               mmap-rnum-ran(fl2-mid)
                               mmap-data-out(fl2-mid)
                       set fl2-found to true
               end-evaluate
           end-perform
           .
       9000-init.
           move 0 to mmap-hndl-x
           call 'open' using
               by content   'file2' & x'00'
               by value     0,
               returning    mmap-hndl-x
           end-call
           if mmap-hndl-x < 3
              display 'cant open file2' upon SYSERR
              display "hndl=" mmap-hndl-x upon SYSERR
              end-display
              move -1 to return-code
              stop run
           end-if
           move zero to len1
           move 128 to flag1
           call 'CBL_READ_FILE' using
                by content mmap-hndl,
                by reference mmap-size,
                by content len1,
                by content flag1,
                by reference mmap-rec(1)
           end-call
           if  return-code not equal 0
              display 'cant read file2' upon syserr
              display "hndl=" mmap-hndl-x upon syserr
              display "return code=" return-code upon syserr
              end-display
              move -1 to return-code
              stop run
           end-if

           call 'mmap' using
               by value     0,
               by value size is 8    mmap-size,
               by value     1,
               by value     1,
               by value size is 8   mmap-hndl-x,
               by value     0,
               returning    mmap-ptr
           end-call
      D    display "mmap return code = " return-code upon syserr 
      D    display 'mmaphndlx = ' mmap-hndl-x upon syserr
      D    display 'mmap-ptr  = ' mmap-ptr upon syserr

           if  return-code not equal 0
              display 'cant  mmap  file2' upon syserr
              display "hndl=" mmap-hndl-x upon syserr
              display "return code=" return-code upon syserr
              end-display
              move -1 to return-code
              stop run
           end-if
           
      D    display "mmap size = " mmap-size upon syserr
           call 'close' using
               by value      mmap-hndl-x
           end-call
           set address of mmap-table to mmap-ptr
           divide mmap-size by length of mmap-rec(1) giving mmap-qnty
           end-divide
      D    display "mmap qnty = " mmap-qnty upon syserr
           if  mmap-qnty = zeroes
               display "file2 empty" upon SYSERR
               end-display
               move -1 to return-code
               stop run
           end-if
           .
