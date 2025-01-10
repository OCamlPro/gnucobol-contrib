       identification division.
       program-id.             seqmatchfile.
       environment division.
       configuration section.
       source-computer.
           Summit
      *           with debugging mode
           .
       input-output section.
       file-control.
           select  i-file1  assign "file1"
               organization is line sequential.
           select  i-file2  assign "file2"
               organization is line sequential.
       data division.
       file section.
       fd i-file1.
       01 i-file1-rec.
          88 i-file1-eof  value  high-values.
          05 i-file1-key                                    pic x(09).
       fd i-file2.
       01 i-file2-rec.
          88 i-file2-eof  value  high-values.
          05 i-file2-key                                    pic x(09).
          05                                                pic x(19).
       working-storage section.
       procedure division.
           open input i-file1
           perform 0100-read-file1
           if  i-file1-eof
               display "file1 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           open input i-file2
           perform  until (i-file1-eof or i-file2-eof)
                perform 1000-seq-search
           end-perform
           close i-file1
           close i-file2
           move zeroes to return-code
           goback
           .
       0100-read-file1.
           read i-file1
               at end move high-values to i-file1-rec
           end-read
           .
       0200-read-file2.
           read i-file2
               at end move high-values to i-file2-rec
           end-read
           .
       1000-seq-search.
            if  i-file1-key < i-file2-key
                perform 0100-read-file1
            else
                if  i-file1-key > i-file2-key
                    perform 0200-read-file2
                else
                   if  i-file1-key = i-file2-key
                       display i-file2-rec
                       perform 0100-read-file1
                       perform 0200-read-file2
                   end-if
               end-if
            end-if
           . 
		   