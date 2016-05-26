        >>SOURCE FORMAT FREE
identification division.
program-id. tcpipserver.
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

*> ===================================================
*> A simple tcp/ip server which receives commands from
*> (a) simple tcp/ip client(s)
*>
*>     cobc -x -Wall tcpipserver.cbl
*>     chmod +x tcpipserver
*>     ./tcpipserver [serverquadaddress]/serverport
*>
*> client commands are get, put, ls, and quit
*> -- anything else will be echoed 
*>
*> ===================================================

environment division.
configuration section.
repository. function all intrinsic.

input-output section.
file-control.
    select system-file
        assign using system-file-name
        file status is system-file-status
        organization is line sequential.

data division.
file section.
fd  system-file.
01  system-record pic x(256).

working-storage section.
01  errno binary-char unsigned.
01  errno-name pic x(16).
01  errno-message pic x(40).

01 server-descriptor binary-int.
01 server-address.
   03  server-family binary-short unsigned.
   03  server-port binary-short unsigned.
   03  server-ip-address binary-int unsigned.
   03  filler pic x(8) value low-values.

01 AF_INET binary-short unsigned value 2.
01 SOCK_STREAM binary-short unsigned value 1.
01 SOL_SOCKET binary-int value 1.
01 SO_REUSEADDR binary-int value 2.
01 YES binary-int value 1.
01 NL pic x value x'0A'.

01 queue-length binary-char value 2.

01 peer-descriptor binary-int.
01 peer-address.
   03  peer-family binary-short unsigned.
   03  peer-port binary-short unsigned.
   03  peer-ip-address binary-int unsigned.
   03  filler pic x(8) value low-values.
01 peer-address-length binary-short unsigned.

01 buffer pic x(1024).
01 buffer-length binary-short unsigned.

01 command-string pic x(64).
01 command-ip-address pic x(15) value spaces.
01 command-port pic 9(5).
01 command-binary-port binary-short.

01 abort-message pic x(64).
01 quit-received pic x.

01 system-file-name pic x(64).
01 system-file-status pic x(2).
01 system-command pic x(64).

procedure division.
start-tcpipserver.

    display NL 'start tcpipserver' NL end-display

    accept command-string from command-line end-accept
    unstring command-string delimited by all spaces into
        command-ip-address command-port
    end-unstring

    display 'command-ip-address = ' command-ip-address end-display
    display 'command-port = ' command-port end-display

    call 'socket' using
        by value AF_INET
        by value SOCK_STREAM
        by value 0
        giving server-descriptor
    end-call
    if return-code = -1
        move "server call 'socket' failed" to abort-message
        perform abort-server
    end-if

    call 'setsockopt' using
        by value server-descriptor
        by value SOL_SOCKET
        by value SO_REUSEADDR
        by reference YES
        by value length(YES)
    end-call 
    if return-code = -1
        move "server call 'setsockopt' failed" to abort-message
        perform abort-server
    end-if

    compute command-binary-port = command-port end-compute
    call 'htons' using by value
        command-binary-port
        giving server-port
    end-call

    move AF_INET to server-family

    if command-ip-address = 'localhost' or 'INADDR_ANY'
        move 0 to server-ip-address
    else
        call 'inet_addr' using
            by reference command-ip-address
            giving server-ip-address
        end-call
    end-if

    call 'bind' using
        by value server-descriptor
        by reference server-address
        by value length(server-address)
    end-call
    if return-code = -1
        move "server call 'bind' failed" to abort-message
        perform abort-server
    end-if

    call 'listen' using
        by value server-descriptor
        by value queue-length
    end-call
    if return-code = -1
        move "server call 'listen' failed" to abort-message
        perform abort-server
    end-if

    move 'N' to quit-received
    perform until quit-received = 'Y'

        move length(peer-address) to peer-address-length
        call 'accept' using
            by value server-descriptor
            by reference peer-address
            by reference peer-address-length
            giving peer-descriptor
        end-call
        if return-code = -1
            move "server call 'accept' failed" to abort-message
            perform abort-server
        end-if

        call 'setsockopt' using
            by value peer-descriptor
            by value SOL_SOCKET by value SO_REUSEADDR
            by reference YES by value length(YES)
        end-call 
        if return-code = -1
            move "server peer call 'setsockopt' failed" to abort-message
            perform abort-server
        end-if

*>      get a peer command
        perform read-from-peer
        perform until buffer-length = 0
        or quit-received = 'Y'
            display NL 'received from peer ' buffer(1:buffer-length) end-display
            evaluate true
            when buffer(1:4) = 'quit' or 'QUIT'
*>              peer commands the server to shut down
                move 'Y' to quit-received
            when buffer(1:2) = 'ls' or 'LS'
*>              send a directory listing to the peer
*>              the server will close the connection
                move spaces to system-command system-file-status
                move 'ls > servertemp' to system-command
                call 'SYSTEM' using system-command end-call
                if return-code = 0
                    move 'servertemp' to system-file-name
                    perform send-file
                end-if
                move 0 to buffer-length
            when buffer(1:3) = 'get' or 'GET'
*>              send a file to the peer
                move 'tcpipserver.cbl' to system-file-name
                perform send-file
                move 0 to buffer-length
            when buffer(1:3) = 'put' or 'PUT'
*>              get a file from the peer
*>              the peer will close the connection
                perform until buffer-length = 0
                    move 'OK' to buffer
                    move 2 to buffer-length
                    perform send-to-peer
                    perform read-from-peer
                    if buffer-length > 0
                        display buffer-length space buffer(1:buffer-length) end-display
                    end-if
                end-perform
            when other
*>              echo the command to the peer
*>              the server will close the connection
                perform send-to-peer
                perform read-from-peer
                move 0 to buffer-length
            end-evaluate
        end-perform

*>      the server closes the peer connection after processing
        call 'close' using by value peer-descriptor end-call
        if return-code = -1
            move 'server call peer "close" failed' to abort-message
            perform abort-server
        end-if

    end-perform

    call 'close' using by value server-descriptor end-call
    if return-code = -1
        move 'server call server "close" failed' to abort-message
        perform abort-server
    end-if

    display NL 'end tcpipserver' end-display
    stop run
    .
send-file.
    open input system-file
    read system-file end-read
    perform until system-file-status <> '00'
        move system-record to buffer
        perform varying buffer-length from 1 by 1
        until buffer-length >= length(buffer)
        or buffer(buffer-length:) = spaces
            continue
        end-perform
        perform send-to-peer
        perform read-from-peer
        read system-file end-read
    end-perform
    close system-file
    move spaces to system-file-status
    .
send-to-peer.
    call 'send' using
        by value peer-descriptor
        by reference buffer
        by value buffer-length
        by value 0
    end-call
    if return-code = -1
        move 'send to peer failed' to abort-message
        perform abort-server
    end-if
    .
read-from-peer.
    move spaces to buffer
    call 'recv' using
        by value peer-descriptor
        by reference buffer
        by value length(buffer)
        by value 0
    end-call
    evaluate true
    when return-code = -1
        call 'errnomessage' using
            by reference errno errno-name errno-message
        end-call
    when return-code = 0
        display 'server received close connection from peer' end-display
        compute buffer-length = return-code end-compute
    when other
        compute buffer-length = return-code end-compute
    end-evaluate
    .
abort-server.
    display NL abort-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program tcpipserver.


