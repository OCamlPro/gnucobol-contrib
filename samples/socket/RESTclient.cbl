          >>SOURCE format FREE
identification division.
program-id. RESTclient.
*> 
*>  Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
*> 
*>  This program is free software; you can redistribute it and/or
*>  modify it under the terms of the GNU General Public License as
*>  published by the Free Software Foundation; either version 2,
*>  or (at your option) any later version.
*>  
*>  This program is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*>  GNU General Public License for more details.
*>  
*>  You should have received a copy of the GNU General Public
*>  License along with this software; see the file COPYING.
*>  If not, write to the Free Software Foundation, Inc.,
*>  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

*> ================================================================
*> Example1: get geocodes from geocoding.geo.census.gov
*> http://geocoding.geo.census.gov/geocoder/
*>        Geocoding_Services_API.pdf

*> Example2: get stock info from query.yahooapis.com
*> https://developer.yahoo.com/yql/
*> ================================================================

*> ================================================================
*> cobc -W httpstatus.cbl
*> cobc -W get_errno.c
*> cobc -W errnomessage.cbl
*> cobc -x -Wall RESTclient.cbl
*> chmod +x -Wall RESTclient
*> /.RESTclient > RESTclient.txt
*> less RESTclient.txt
*> ================================================================

environment division.
configuration section.
repository. function all intrinsic.

data division.
working-storage section.
01 errno binary-char unsigned.
01 errno-name pic x(16).
01 errno-message pic x(64).

01 general-message pic x(64).

01 socket-descriptor binary-int.

01 AF_INET binary-int value 2.
01 SOCK_STREAM binary-int value 1.
01 SO_RCVTIMEO binary-int value 20.
01 NL pic x value x'0A'.
01 CR pic x value x'0D'.

01 buffer pic x(100000).
01 buffer-length binary-int unsigned.

01 response pic x(100000).
01 response-length binary-int.
01 r binary-int.

01 formatted pic x(100000).
01 f binary-int.
01 i binary-int.

01 response1 pic x(16).
01 http-status-code pic x(3).
01 http-status-message pic x(40).

01 examples.
   03 example1.
      05  filler pic x(128) value
          "geocoding.geo.census.gov".
      05  filler pic x(32) value "80".
      05  filler pic x(128) value
          "/geocoder/locations/onelineaddress".
      05  filler pic x(256) value
          "address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&benchmark=9&format=json".
      05  filler pic x(256) value
          "address=4600+Silver+Hill+Rd,+Suitland,+MD+20746&benchmark=9&format=json".
   03  example2.
      05  filler pic x(128) value
          "query.yahooapis.com".
      05  filler pic x(32) value "80".
      05  filler pic x(128) value
          "/v1/public/yql".
      05  filler pic x(256) value
          'q=select * from yahoo.finance.quotes where symbol in ("YHOO","AAPL","GOOG","MSFT")'
          & '&format=json&env=http://datatables.org/alltables.env'.
      05  filler pic x(256) value
          'q=select * from yahoo.finance.quotes where symbol in ("TSLA","SCTY","BRKB","F","FKWL")'
          & '&format=json&env=http://datatables.org/alltables.env'.

01 REST-example.
   03  host pic x(128).
   03  host-service pic x(32).
   03  path pic x(128).
   03  query1 pic x(256).
   03  query2 pic x(256).
01 example-host pic x(128).
01 example-service pic x(32).


01 query pic x(256).
01 query-work pic x(256).
01 p binary-int.
01 q binary-int.

procedure division.
start-RESTclient.

    display NL 'start RESTclient' end-display

    move example1 to REST-example
    perform execute-example

    move example2 to REST-example
    perform execute-example

    display NL 'end RESTclient' end-display
    stop run
    .
execute-example.

    perform connect-to-server

    move query1 to query-work
    perform format-query
    perform send-request
    perform receive-response

    perform connect-to-server

    move query2 to query-work
    perform format-query
    perform send-request
    perform receive-response
    .
format-query.

*>  ======================================
*>  not sure we need to do this, but. . .
*>  anyway, we use p and q later on, so we
*>  don't use function substitute
*>  ======================================
    move spaces to query
    move 1 to q
    perform varying p from 1 by 1
    until query-work(p:) = spaces
        evaluate true
        when query-work(p:1) = ' '
            move '%20' to query(q:3) add 3 to q end-add
        when query-work(p:1) = ','
            move '%2C' to query(q:3) add 3 to q end-add
        when query-work(p:1) = '"'
            move '%22' to query(q:3) add 3 to q end-add
        when other
            move query-work(p:1) to query(q:1) add 1 to q end-add
        end-evaluate
    end-perform
    .
connect-to-server.
    move host to example-host
    move host-service to example-service
    call 'connecttoserver' using
        AF_INET
        SOCK_STREAM
        example-host
        example-service
        socket-descriptor
    end-call
    call 'setsockopt' using
        by value socket-descriptor
        by value SO_RCVTIMEO
        by value 10000 *> milliseconds
    end-call 
    .
send-request.
    move 1 to buffer-length
    string
       'GET ' delimited by size
        path delimited by space
        '?' delimited by size
        query(1:q) delimited by size
        ' HTTP/1.1' CR NL delimited by size

        'Host: ' delimited by size
        host delimited by x'00'
        CR NL delimited by size

        'Content-type: application/x-www-form-urlencoded' delimited by size
        CR NL delimited by size

        'Connection: close' delimited by size
        CR NL CR NL delimited by size

        into buffer with pointer buffer-length
    end-string
    subtract 1 from buffer-length end-subtract
    perform send-to-server
    .
receive-response.
    move 1 to response-length
    move spaces to response
    perform receive-from-server
    perform until buffer-length = 0
        string buffer(1:buffer-length) delimited by size
            into response with pointer response-length
        end-string
        perform receive-from-server
    end-perform
    perform check-response
    call 'close' using by value socket-descriptor end-call
    .
check-response.
*>  skip the header
    perform varying r from 1 by 1
    until r >= response-length
    or response(r:1) = '{'
        continue
    end-perform

    evaluate true
    when response-length = 1
        move spaces to general-message
        string 'no response from ' delimited by size
            host delimited by space
            into general-message
        end-string
        display general-message end-display
        display 'for query' end-display
        display query-work(1:p) end-display
    when r >= response-length 
        perform get-status-message
        move spaces to general-message
        string NL 'bad response from ' delimited by size
            host delimited by space
            into general-message
        end-string
        display general-message end-display
        display response(1:r) end-display
        display '=============' end-display
        display http-status-code space http-status-message end-display
        display 'for query' end-display
        display query-work(1:p) end-display
        display '=============' end-display
    when other
*>      show the response
        perform get-status-message
        move 1 to f
        move 1 to i
        move spaces to formatted
        perform format-response until r >= response-length
        display formatted(1:f) end-display
        display '=============' end-display
        display http-status-code space http-status-message end-display
        display 'for query' end-display
        display query-work(1:p) end-display
        display '=============' end-display
    end-evaluate
    .
get-status-message.
    move spaces to response1 http-status-code
    unstring response delimited by spaces into
        response1 http-status-code
    end-unstring
    call 'httpstatus' using http-status-code http-status-message end-call
    .
format-response.
     evaluate response(r:1)
     when '"'
         move response(r:1) to formatted(f:1) add 1 to r end-add
         perform varying r from r by 1
         until response(r:1) = '"'
             add 1 to f end-add move response(r:1) to formatted(f:1)
         end-perform
         add 1 to f end-add move response(r:1) to formatted(f:1)
     when '{'
         move response(r:1) to formatted(f:1)   
         add 1 to f end-add move NL to formatted(f:1)
         add 4 to i end-add add i to f end-add
     when '['
         move response(r:1) to formatted(f:1)   
         add 1 to f end-add move NL to formatted(f:1)
         add 4 to i end-add add i to f end-add
     when ','
         move NL to formatted(f:1)
	 add i to f end-add move response(r:1) to formatted(f:1)
     when ']'
         move NL to formatted(f:1)
         subtract 4 from i end-subtract
         add i to f end-add move response(r:1) to formatted(f:1)
     when '}'
         move NL to formatted(f:1)
         subtract 4 from i end-subtract
         add i to f end-add move response(r:1) to formatted(f:1)
     when other
         move response(r:1) to formatted(f:1)
     end-evaluate
     add 1 to r end-add
     add 1 to f end-add 
     .
send-to-server.
    call 'send' using
        by value socket-descriptor
        by reference buffer
        by value buffer-length
        by value 0
    end-call
    if return-code = -1
        move "call 'send' failed" to general-message
        perform abort-client
    end-if
    .
receive-from-server.
    move spaces to buffer
    call 'recv' using
        by value socket-descriptor
        by reference buffer
        by value length(buffer)
        by value 0
    end-call
    if return-code = -1
        move "call 'recv' failed" to general-message
        move 0 to buffer-length
    else
        move return-code to buffer-length
    end-if
    .
abort-client.
    display general-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program RESTclient.

