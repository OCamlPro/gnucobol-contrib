       identification division.
       program-id.           processexcelxmlMS.
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
           select i-file assign to i-name
               organization is line sequential. 
           select o-file assign to o-name
               organization is line sequential.
       data division.
       file section.
       fd i-file. 
       01 i-rec                        pic x(3000).
          88 i-eof  value  high-values.
       fd o-file.
       01 o-rec                        pic x(100).
       working-storage section.
       01 arg-knt            comp-5    pic x(01).
       01 t-knt1                       pic 9(03).
       01 t-knt2                       pic 9(03).
       01 column-count                 pic 9(04).
       01 col-print-count              pic 9(04).
       01 table-column-literal value '<Table ss:ExpandedC' pic x(19).
       01 text-cell-literal    value '<Cell><Data ss:'     pic x(15).
       01 end-row-literal      value '</Row>'              pic x(06).
       01 print-line.
          05 print-row occurs 999 times.
             10  print-col   pic x(20).
             10  filler      pic x(10).

       procedure division.
       0000-mainline.
           perform 9000-init
           open input  i-file
           open output o-file
           perform 0200-read-file
           if  not i-eof
               perform 1000-process-file 
                   until i-eof
           end-if
           close i-file
           close o-file
           move zero to return-code
           goback
           .
       0200-read-file.
           read i-file 
              at end
                  set i-eof to true
           end-read
           .
       0400-write-file.
           write o-rec
           end-write
           .
       1000-process-file. 
           if  i-rec(3:19) = table-column-literal 
               move 0 to t-knt1
               inspect i-rec(18:150) tallying t-knt1 for all characters
                                             after  '="'
                                             before  '" ss:ExpandedR'
               move i-rec(34:t-knt1) to column-count
           end-if
           if  i-rec(4:06) = end-row-literal
               move print-line(1:(30 * column-count)) 
                    to o-rec
               perform 0400-write-file
               move spaces to print-line(1:(30 * column-count)) 
               move 0 to col-print-count
           end-if
           if  i-rec(5:15) = text-cell-literal 
               add 1 to col-print-count
               move 0 to t-knt2	
               inspect i-rec(1:200) tallying t-knt2 for all characters
                                             after  '">'
                                             before  '</'
               move i-rec(34:t-knt2) to print-col(col-print-count) 
           end-if
           perform 0200-read-file
           .
       9000-init.
           accept arg-knt from argument-number
           if  arg-knt <> 2
               display 'two arguments are required' upon SYSERR
               display '1: name of input file'      upon SYSERR
               display '2: name of output file'     upon SYSERR
               move -1 to return-code
               stop run
           end-if
           accept i-name from argument-value
           accept o-name from argument-value
           .

