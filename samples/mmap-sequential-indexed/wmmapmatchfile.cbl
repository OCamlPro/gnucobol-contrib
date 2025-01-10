       identification division.
       program-id.           wmmapmatchfile.
       environment division.
       configuration section.
       source-computer.
           System76.
       input-output section.
       file-control.
           select  i-file1  assign "file1"
               organization is line sequential.
       data division.
       file section.
       fd i-file1.
       01 i-file1-rec.
          88 i-file1-eof  value  high-values.
          05 i-file1-key                                  pic x(09).
       working-storage section.
       01 map-handle                               comp-5 pic x(08).
       01 file-handle                              comp-5 pic x(08).
       01 view-handle                              comp-5 pic x(08).
       01 file-size-struct.
          05 file-size-low                         comp-5 pic x(04).
          05 file-size-high                        comp-5 pic x(04).
       77 mmap-qnty                                comp-5 pic x(08).
       77 mmap-ptr                         pointer.
       77 record-length                            comp-5 pic x(08).
       77 fl2-lo                                   comp-5 pic x(08).
       77 fl2-hi                                   comp-5 pic x(08).
       77 fl2-mid                                  comp-5 pic x(08).
       77                                                 pic x(01).
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
             10                                            pic x(02).
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
           call "UnmapViewOfFile" using
               by value mmap-ptr
           end-call
           call "CloseHandle" using
               by value map-handle
           end-call
           call "CloseHandle" using
               by value file-handle
           end-call
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
           call "CreateFileA" using
               by content z"file2" & x"00"
               by value 2147483648  *> GENERIC_READ
               by value 1  *> FILE_SHARE_READ
               by value 0
               by value 3  *> OPEN_EXISTING
               by value 128  *> FILE_ATTRIBUTE_NORMAL
               by value 0
               returning file-handle
           end-call
           if file-handle = -1
              display 'cant open file2' upon syserr
              move -1 to return-code
              stop run
           end-if
           *> Get file size using GetFileSizeEx for 64-bit support
           call "GetFileSizeEx" using
               by value file-handle
               by reference file-size-struct
           end-call
           compute record-length = length of mmap-rec(1)
           end-compute
            *> Calculate number of records handling both small and large files
           if file-size-high = 0
               *> File is under 4GB, can do direct division
               divide file-size-low by record-length 
                      giving mmap-qnty
               end-divide
           else
               *> File is over 4GB
               *> Handle the high part first
               compute mmap-qnty = 
                   (file-size-high * 4294967296) / record-length
               end-compute
               *> Add in the low part
               compute mmap-qnty = 
                   mmap-qnty + (file-size-low / record-length)
               end-compute
           end-if
           *> Display diagnostic information
           display "File size high = " file-size-high upon syserr
           display "File size low = " file-size-low upon syserr
           display "Record length = " record-length upon syserr
           display "Total records = " mmap-qnty upon syserr 
           *> Create file mapping
           call "CreateFileMappingA" using
               by value file-handle
               by value 0
               by value 2  *> PAGE_READONLY
               by value file-size-high
               by value file-size-low
               by value 0  *> Anonymous mapping
               returning map-handle
           end-call
           if map-handle = 0
              display 'cant create file mapping' upon syserr
              move -1 to return-code
              stop run
           end-if
           *> Map the entire file
           call "MapViewOfFile" using
               by value map-handle
               by value 4  *> FILE_MAP_READ
               by value 0
               by value 0
               by value 0
               returning mmap-ptr
           end-call
           if mmap-ptr = null
              display 'cant map view of file' upon syserr
              move -1 to return-code
              stop run
           end-if
           set address of mmap-table to mmap-ptr
           if  mmap-qnty = zeroes
               display "file2 empty" upon syserr
               move -1 to return-code
               stop run
           end-if
           . 
		   