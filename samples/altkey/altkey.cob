       Identification division.
       Program-id. altkey.

      *>  altkey * Alternate Key Demo. 
      *>  Published under GNU General Public License. 

       Environment division.
       Configuration section.
       Source-computer.  GNU-Cobol.
       Object-computer.  GNU-Cobol.
       Special-names.
      * Display x upon std-out, to get 1>file1.txt.
           console is std-out
      * Display x upon std-err, to get 2>file2.txt
           syserr  is std-err.

       input-output section.
       file-control.

           Select iftest
               assign to "/tmp/iftest"
               organization is indexed
               access mode is dynamic
               record key is iftest-key
               alternate key is iftest-alternate
                   with duplicates
                   suppress when space
               file status is ws-file-status.

       Data division.
       file section.

       fd  iftest.
       01  iftest-record.
           02 iftest-key                     pic x(10).
           02                                pic x(05).
           02 iftest-alternate               pic x(10).
           02                                pic x(05).

       Working-storage section.

       01  display-message                pic x(80).

       01  flag-done                      pic x(01).
           88 flag-done-no   value low-value.
           88 flag-done-yes  value high-value.
       01  flag-eof                       pic x(01).
           88 flag-eof-no   value low-value.
           88 flag-eof-yes  value high-value.
       01  flag-rewrite                   pic x(01).
           88 flag-rewrite-no  value low-value.
           88 flag-rewrite-yes value high-value.
       01  flag-suppressed                pic x(01) value high-value.
           88 flag-suppressed-no  value low-value.
           88 flag-suppressed-yes value high-value.

       01  hold-record                    pic x(30).

       01  table-messages.
           02 table-messages-defined value
               "                                                  "
             & "   This program shows how alternate keys are used."
             & "The first field in the record is the primary key, "
             & "and the second is the alternate key.              "
             & "                                                  "
             & "   Blank alternate keys do not appear in the read "
             & "loop because of the 'suppress when spaces' clause."
             & "As an exercise, comment out the clause and see    "
             & "the difference when the program is run again.     "
             & "                                                  "
             & "1)  The file is opened output, to create it.      "
             & "2)  Six sample records are written, some with     "
             & "    blank alternate keys.                         "
             & "3)  The file is opened i-o, for read, rewrite,    "
             & "    and delete functions.                         "
             & "4)  Record 6, with a blank key, is rewritten with "
             & "    non blank key.                                "
             & "5)  The file is started on the alternate key,     "
             & "    so that read next statements read by the      "
             & "    alternate key and not by the primary key.     "
             & "6)  The records are read until there are no more  "
             & "    alternate keys.                               "
             & "7)  After all of the records are read, the first  "
             & "    non blank alternate key record is either      "
             & "    rewritten with a blank alternate key or       "
             & "    deleted.                                      "
             & "8)  The file is started again in step 5) and      "
             & "    the process repeated until there are no       "
             & "    more records with non blank alternate keys.   "
             & "                                                  ".
           02 table-message redefines table-messages-defined
              pic x(50) occurs 30 times.
       01  end-table                      pic 9(04) binary value 30.
       01  sub-table                      pic 9(04) binary.

       01  ws-file-status                 pic x(02).
       01  ws-operation                   pic x(15).
       01  ws-record                      pic x(30).

       Procedure division.

      **  Display the table messages.

           Perform dm-display-message thru dm-exit
               varying sub-table
                  from 1
                    by 1
               until sub-table is greater than end-table.

      ** Open output to create the indexed file.

           Open output iftest.
           Move "open output" to ws-operation.
           Move space         to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

      ** Write 6 records, 1, 3, 5, and 6 have space alternate key.
           Move "write" to ws-operation.

           Move space         to iftest-record.
           Move "key-1"       to iftest-key.
           Move space         to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space         to iftest-record.
           Move "key-2"       to iftest-key.
           Move "key-2"       to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space         to iftest-record.
           Move "key-3"       to iftest-key.
           Move space         to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space         to iftest-record.
           Move "key-4"       to iftest-key.
           Move "key-4"       to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space         to iftest-record.
           Move "key-5"       to iftest-key.
           Move space         to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space         to iftest-record.
           Move "key-6"       to iftest-key.
           Move space         to iftest-alternate.
           Move iftest-record to ws-record.
           Write iftest-record end-write.
           Perform sfo-show-file-operation thru sfo-exit.

      ** Open I/O.

           Close iftest.
           Move "close" to ws-operation.
           Move space   to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

           Open i-o iftest.
           Move "open i-o" to ws-operation.
           Move space      to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

      ** Test rewrite of blank alternate key to non-blank.

           Move space         to iftest-record.
           Move "key-6"       to iftest-key.
           Move "key-6"       to iftest-alternate.
           Move iftest-record to ws-record.
           Rewrite iftest-record end-rewrite.
           Move "rewrite" to ws-operation.
           Perform sfo-show-file-operation thru sfo-exit.

      ** Read loop, with a rewrite or delete.

           Set flag-rewrite-yes to true.
           Set flag-done-no to true.
           Perform 1-loop thru 1-exit
               until flag-done-yes.

      ** Finish.

           Close iftest.
           Move "close" to ws-operation.
           Move space   to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

           Move space to display-message.
           Perform sm-show-message thru sm-exit.
           If flag-suppressed-no
               Move
                   "* Blank alternate keys are not suppressed "
                   &  "in this run."
                 to display-message
               Perform sm-show-message thru sm-exit
             else
               Move
                   "* Blank alternate keys are suppressed in this run."
                 to display-message
               Perform sm-show-message thru sm-exit
           end-if.
           Move space to display-message.
           Perform sm-show-message thru sm-exit.

           Goback.

       1-loop.

      ** Start the file on the first alternate key.

           Move low-values to iftest-alternate.
           Start iftest
               key not less than iftest-alternate
               invalid key Continue
           end-start.
           Move "start alternate" to ws-operation.
           Move space             to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

           If ws-file-status is equal to "23"
               Set flag-done-yes to true
               Go to 1-exit
           end-if.

      ** Read next and show records.

           Move high-value to hold-record.
           Set flag-eof-no to true.
           Perform 11-report thru 11-exit
               until flag-eof-yes.

      ** Exit if all alternate keys are blank.

           If hold-record is equal to high-value
               Set flag-done-yes to true
               Go to 1-exit
           end-if.

      ** Blank out rewrite or delete the first non-blank alternate key.

           Move hold-record   to iftest-record.
           If flag-rewrite-yes
      * Rewrite, blanking out non-blank alternate key.
               Move space         to iftest-alternate
               Move iftest-record to ws-record
               Rewrite iftest-record
                   invalid key Continue
               end-rewrite
               Move "rewrite" to ws-operation
               Set flag-rewrite-no to true
             else
      * Delete with non-blank alternate key.
               Move iftest-record to ws-record
               Delete iftest record
               end-delete
               Move "delete" to ws-operation
               Set flag-rewrite-yes to true
           end-if.
           Perform sfo-show-file-operation thru sfo-exit.

       1-exit.
           Exit.

       11-report.

      ** Read next.

           Move space to iftest-record.
           Read iftest
               next record
               at end Continue
           end-read.
           Move "read next"   to ws-operation.
           Move iftest-record to ws-record.
           Perform sfo-show-file-operation thru sfo-exit.

           If ws-file-status is equal to "10"
               Set flag-eof-yes to true
               Go to 11-exit
           end-if.

      ** Check if read next alternate key has blank keys.

           If iftest-alternate is equal to space
               Set flag-suppressed-no to true
               Go to 11-exit
           end-if.

      ** Save first record for rewrite or delete.

           If hold-record is equal to high-value
               Move iftest-record to hold-record
           end-if.

       11-exit.
           Exit.

      ** Display a table message line.

       dm-display-message.
           Move table-message (sub-table)
             to display-message.
           Perform sm-show-message thru sm-exit.
       dm-exit.
           Exit.

      ** Display the file operation and output.

       sfo-show-file-operation.
           Move space to display-message.
           String
               "Operation "   
                   delimited by size
               ws-operation   
                   delimited by size
               " Status "     
                   delimited by size
               ws-file-status 
                   delimited by size
               " Record "     
                   delimited by size
               ws-record      
                   delimited by size
               into display-message
           end-string.
           Perform sm-show-message thru sm-exit.
       sfo-exit.
           Exit.

      ** General display message.

       sm-show-message.
           Display display-message
               upon std-out
           end-display.
       sm-exit.
           Exit.

      * end of file.
