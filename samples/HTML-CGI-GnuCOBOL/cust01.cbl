       identification division.
       program-id.   cust01.
       environment division.
       input-output section.
       file-control.
           select customer-file assign to "testfile1001.dat"
           organization is indexed
           access mode is dynamic
           record key is cust-acct-no
           file status is file-status.

       data division.
       file section.
       fd  customer-file.
       01  customer-record.
           05 cust-acct-no             pic x(09).
           05 cust-fname               pic x(15).
           05 cust-lname               pic x(13).
           05 cust-house-no            pic x(08).
           05 cust-street              pic x(30).
           05 cust-city                pic x(30).
           05 cust-state               pic x(02).
           05 cust-zip                 pic x(05).
           05 cust-income              pic x(09).

       working-storage section.
       01  file-status                 pic 99.
       01  arg-knt           comp-5    pic x.
       01  ws-message                  pic x(100).
       01  ws-parameters.
           05 ws-acct-no               pic x(09).
           05 ws-fname                 pic x(15).
           05 ws-lname                 pic x(13).
           05 ws-house-no              pic x(08).
           05 ws-street                pic x(30).
           05 ws-city                  pic x(30).
           05 ws-state                 pic x(02).
           05 ws-zip                   pic x(05).
           05 ws-income                pic x(09).
           05 ws-action                pic x(07).

       procedure division.
           move spaces to ws-message
           move spaces to ws-parameters
           accept arg-knt from argument-number
           if  arg-knt  = 0 
              or
               arg-knt > 10
               display 'arguments invalid'  upon SYSERR
               move 'arguments invalid'     to ws-message
               move -1 to return-code
               goback
           end-if
           accept ws-acct-no       from argument-value
           accept ws-fname         from argument-value
           accept ws-lname         from argument-value
           accept ws-house-no      from argument-value
           accept ws-street        from argument-value
           accept ws-city          from argument-value
           accept ws-state         from argument-value
           accept ws-zip           from argument-value
           accept ws-income        from argument-value
           accept ws-action        from argument-value
           open i-o customer-file
           if  file-status not = "00"
               display 'file status = ' file-status upon syserr
               move "error opening file" to ws-message
               perform output-para
               move file-status to return-code
               goback
           end-if

           evaluate ws-action
               when "inquire"
                   perform inquire-para
               when "update"
                   perform update-para
               when "add"
                   perform add-para
               when "delete"
                   perform delete-para
               when "clear" 
                   perform clear-para
               when other
                   move "invalid action" to ws-message
           end-evaluate

           close customer-file
           if  file-status not = "00"
               display 'file status = ' file-status upon syserr
               move "error closing file" to ws-message
               perform output-para
               move file-status to return-code
               goback
           end-if

           perform output-para
           move zeroes to return-code
           goback
           .

       inquire-para.
           move ws-acct-no to cust-acct-no
           read customer-file
               invalid key
                   move "record not found on inquire" to ws-message
                   move low-values to customer-record(10:) 
               not invalid key
                   move "record found" to ws-message
           end-read
           .

       update-para.
           move ws-acct-no to cust-acct-no
           read customer-file
               invalid key
                   move "record not found on update" to ws-message
               not invalid key
                   perform update-record
           end-read
           .

       add-para.
           move ws-acct-no to cust-acct-no
           read customer-file
               invalid key
                   perform add-record
               not invalid key
                   move "record already exists on add" to ws-message
           end-read
           .

       delete-para.
           move ws-acct-no to cust-acct-no
           read customer-file
               invalid key
                   move "record not deleted" to ws-message
               not invalid key
                   delete customer-file
                   move "record  deleted" to ws-message
           end-read
           .
       
       clear-para.
            move low-values to customer-record
            .

       update-record.
           move ws-acct-no  to cust-acct-no
           move ws-fname    to cust-fname
           move ws-lname    to cust-lname
           move ws-house-no to cust-house-no
           move ws-street   to cust-street
           move ws-city     to cust-city
           move ws-state    to cust-state
           move ws-zip      to cust-zip
           move ws-income   to cust-income
           rewrite customer-record
           if  file-status not = "00"
               display 'file status = ' file-status upon syserr
               move "error updating record" to ws-message
               move file-status to return-code
               goback
           end-if
           move "record updated" to ws-message
           .

       add-record.
           move ws-acct-no  to cust-acct-no
           move ws-fname    to cust-fname
           move ws-lname    to cust-lname
           move ws-house-no to cust-house-no
           move ws-street   to cust-street
           move ws-city     to cust-city
           move ws-state    to cust-state
           move ws-zip      to cust-zip
           move ws-income   to cust-income
           write customer-record
           if  file-status not = "00"
               display 'file status = ' file-status upon syserr
               move "error adding record" to ws-message
               perform output-para
               move file-status to return-code
               goback
           end-if
           move "record added" to ws-message
           .

       output-para.
           display cust-acct-no "|" cust-fname "|" cust-lname "|"
                   cust-house-no "|" cust-street "|" cust-city "|"
                   cust-state "|" cust-zip "|" cust-income "|"
                   ws-message
           .

