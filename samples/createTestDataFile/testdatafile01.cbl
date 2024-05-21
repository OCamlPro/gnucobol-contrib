       identification division.
       program-id.           testdatafile01.
      * file creater program 
       environment division.
       configuration section.
       source-computer.
           System76
      *           with debugging mode
           .
       repository.
           function all intrinsic.
       input-output section.
       file-control.
      *    select  i-file1  assign "null.file"
           select  i-file1  assign "yobALL.txt"
               organization is line sequential.
           select  i-file2  assign "last.all.txt"
               organization is line sequential.
           select  i-file3  assign "newdedup.address.csv"
               organization is line sequential.
           select  i-file4  assign "zip.city.state.csv"
               organization is line sequential.
           select  o-file5  assign "testdatafile01.out"
               organization is line sequential.
       data division.
       file section.
       fd i-file1.
       01 i-file1-rec.
          88 i-file1-eof  value  high-values.
          05 i-file1-first-name                            pic x(15).
       fd i-file2.
       01 i-file2-rec.
          88 i-file2-eof  value  high-values.
          05 i-file2-last-name                             pic x(13).
       fd i-file3.
       01 i-file3-rec.
          88 i-file3-eof  value  high-values.
          05 i-file3-address                               pic x(33).
       fd i-file4.
       01 i-file4-rec.
          88 i-file4-eof  value  high-values.
          05 i-file4-csz                                   pic x(36). 
       fd o-file5.
       01 o-file5-rec.
          05 o-file5-rec-count                             pic 9(09).
          05 o-file5-first-name                            pic x(15).
          05 o-file5-last-name                             pic x(13). 
          05 o-file5-house-number                          pic x(08). 
          05 o-file5-street-name                           pic x(30).
          05 o-file5-city                                  pic x(30).
          05 o-file5-state                                 pic x(02).
          05 o-file5-zip                                   pic x(05). 
          05 o-file5-year-pay                              pic 9(09).  

       working-storage section.
       01 record-counts.
          05  file1-count                                  pic 9(09).
          05  file2-count                                  pic 9(09).
          05  file3-count                                  pic 9(09).
          05  file4-count                                  pic 9(09).
          05  file5-count                                  pic 9(09).
       01 table-subscript.
          05  file1-ss                                     pic 9(09).
          05  file2-ss                                     pic 9(09).
          05  file3-ss                                     pic 9(09).
          05  file4-ss                                     pic 9(09).
          05  file5-ss                                     pic 9(09).
       01 fname-table.
          05 fname-tbl occurs  40493 times. 
             10 fname-rec                                  pic x(15).
       01 lname-table.
          05 lname-tbl occurs  88799 times.
             10 lname-rec                                  pic x(13).
       01 housestreet-table.
          05 hst-tbl  occurs  252600 times.
             10 hst-rec.
                15 house-num                               pic x(08).
                15 street-name                             pic x(30).
       01 csz-table.
          05 csz-tbl occurs 42522 times.
             10 csz-rec.
                15 csz-city                                pic x(30).
                15 csz-state                               pic x(02).
                15 csz-zip                                 pic x(05).

       procedure division.
           perform 1000-read-load-files
           perform 2000-random-write-file
           move zeroes to return-code
           goback
           .
       1000-read-load-files.     
           open input i-file1
           read i-file1
               at end move high-values to i-file1-rec
           end-read
           if  i-file1-eof
               display "file1 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           perform 1100-read-file1 until i-file1-eof
           close i-file1
           open input i-file2
           read i-file2
               at end move high-values to i-file2-rec
           end-read
           if  i-file2-eof
               display "file2 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           perform 1200-read-file2 until i-file2-eof
           close i-file2
           open input i-file3
           read i-file3
               at end move high-values to i-file3-rec
           end-read
           if  i-file3-eof
               display "file3 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           perform 1300-read-file3 until i-file3-eof
           close i-file3
           open input i-file4
           read i-file4
               at end move high-values to i-file4-rec
           end-read
           if  i-file4-eof
               display "file4 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           perform 1400-read-file4 until i-file4-eof
           close i-file4
           .
       1100-read-file1.
           add 1 to file1-count
           move i-file1-first-name to fname-rec(file1-count) 
           read i-file1
               at end move high-values to i-file1-rec
           end-read
           .
       1200-read-file2.
           add 1 to file2-count
           move i-file2-last-name to lname-rec(file2-count)
           read i-file2
               at end move high-values to i-file2-rec
           end-read
           .
       1300-read-file3.
           add 1 to file3-count
           unstring i-file3-rec delimited by ',' into 
                    house-num(file3-count) 
                   street-name(file3-count) 
           end-unstring
           read i-file3
               at end move high-values to i-file3-rec
           end-read
           .
       1400-read-file4.
           add 1 to file4-count
           unstring i-file4-rec delimited by ',' into 
                    csz-zip(file4-count)
                    csz-city(file4-count)
                    csz-state(file4-count)
           read i-file4
               at end move high-values to i-file4-rec
           end-read
           .
       2000-random-write-file.
           open output o-file5
           initialize o-file5-rec
           perform 100000 times
               add 1 to o-file5-rec-count
               perform 2100-random-fname
               perform 2200-random-lname
               perform 2300-random-address
               perform 2400-random-csz
               perform 2500-random-pay
               perform 2900-write-file5
           end-perform
           close o-file5
           .
       2100-random-fname.
           compute file1-ss = 1 + 40493 *  random  
           move fname-rec(file1-ss) to o-file5-first-name  
           .
       2200-random-lname.
           compute file2-ss = 1 + 88799 *  random 
           move lname-rec(file2-ss) to o-file5-last-name
           .
       2300-random-address.
           compute file3-ss = 1 + 252600 * random
           move house-num(file3-ss) to o-file5-house-number
           move street-name(file3-ss) to o-file5-street-name
           . 
       2400-random-csz.
           compute file4-ss = 1 + 42522 * random
           move csz-city(file4-ss) to o-file5-city
           move csz-state(file4-ss) to o-file5-state
           move csz-zip(file4-ss) to o-file5-zip 
           .
       2500-random-pay.
           compute file5-ss = 1 + 19999999 * random
           move file5-ss to o-file5-year-pay
           .
       2900-write-file5.
           write o-file5-rec
           .
