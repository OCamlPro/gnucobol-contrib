          >>SOURCE FORMAT FREE
identification division.
program-id. tcpipclient.
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

*> ========================================================
*> A simple tcp/ip client which talks to a simple tcp/ip
*> server and issues some simple commands
*>
*>     cobc -Wall get_errno.c
*>     cobc -Wall errnomessage.cbl
*>     cobc -x -Wall tcpipclient.cbl
*>     chmod +x tcpipclient
*>
*> usage:
*>     ./tcpclient host/port/command1[/command2[/command3]]
*> 
*> commands are get, put, ls, and quit
*> -- anything else will be echoed 
*>
*> examples
*>     ./tcpclient localhost/8080/get/put/ls
*>     ./tcpclient localhost/8080/whatever
*>     ./tcpclient localhost/8080/ls/quit
*> ========================================================

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
01 errno binary-char unsigned.
01 errno-name pic x(16).
01 errno-message pic x(40).
01 abort-message pic x(64).

01 socket-descriptor binary-int.
01 AF_INET binary-int value 2.
01 SOCK_STREAM binary-int unsigned value 1.
01 SOL_SOCKET binary-int value 1.
01 SO_REUSEADDR binary-int value 2.
01 YES binary-int value 1.
01 NL pic x value x'0A'.

01 buffer pic x(1024).
01 buffer-length binary-short unsigned.

01 command-string pic x(64) value spaces.
01 command-host pic x(32) value spaces.
01 command-port pic x(16) value spaces.
01 commands value spaces.
   03  command occurs 3 pic x(8).
01 command-idx pic 9.
01 command-lim pic 9 value 3.

01 system-file-name pic x(64).
01 system-file-status pic x(2).

procedure division.
start-tcpipclient.

    display NL 'start tcpipclient' end-display

    accept command-string from command-line end-accept
    unstring command-string delimited by all spaces into
        command-host command-port
        command(1) command(2) command(3)
    end-unstring

    display 'command-host = ' command-host end-display
    display 'command-port = ' command-port end-display

    perform varying command-idx from 1 by 1
    until command-idx > command-lim
    or command(command-idx) = spaces
        display NL 'processing ' command(command-idx) end-display

*>      we connect to the server for each command because
*>      previous commands may have terminated the connection

        perform connect-to-server

        move 1 to buffer-length
        string command(command-idx) delimited by space
            into buffer with pointer buffer-length
        end-string
        subtract 1 from buffer-length end-subtract
        perform send-to-server
        perform receive-from-server

        evaluate true
        when command(command-idx) = 'put' or 'PUT'
*>          send a file to the server
*>          client will close the connection after processing
            move 'tcpipclient.cbl' to system-file-name
            open input system-file
            read system-file end-read
            perform until system-file-status <> '00'
                perform varying buffer-length from 1 by 1
                until system-record(buffer-length:) = spaces
                    continue
                end-perform
                move system-record(1:buffer-length) to buffer
                perform send-to-server
                perform receive-from-server
                read system-file end-read
            end-perform
            close system-file
            move spaces to system-file-status
        when command(command-idx) = 'get' or 'GET'
*>          server sends a file
        when command(command-idx) = 'ls' or 'LS'
*>          server sends a directory listing
        when command(command-idx) = 'quit' or 'QUIT'
*>          server terminates
        when 1 = 1 *> WHEN OTHER gets a syntax error here
*>          server echoes the command
*>          server will close the connection after processing
            perform until buffer-length = 0
                display buffer(1:buffer-length) end-display
                move 'OK' to buffer
                move 2 to buffer-length
                perform send-to-server
                perform receive-from-server
            end-perform
        end-evaluate

        call 'close' using by value socket-descriptor end-call
    end-perform

    display NL 'end tcpipclient' end-display
    stop run
    .
connect-to-server.
    call 'connecttoserver' using
        AF_INET
        SOCK_STREAM
        command-host
        command-port
        socket-descriptor
    end-call
    .
    call 'setsockopt' using by value socket-descriptor
        by value SOL_SOCKET by value SO_REUSEADDR
        by reference YES by value length(YES)
    end-call 
    if return-code = -1
        move "client call 'setsockopt' failed" to abort-message
        perform abort-client
    end-if

    if socket-descriptor = 0
        move "client call 'connect' failed" to abort-message
        perform abort-client
    end-if
    .
send-to-server.
    display 'sending to server ' buffer-length buffer(1:buffer-length) end-display
    call 'send' using by value socket-descriptor
        by reference buffer
        by value buffer-length
        by value 0
    end-call
    if return-code = -1
        move "client call 'send' failed" to abort-message
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
    evaluate true
    when return-code = -1
        move "client call 'recv' failed" to abort-message
        perform abort-client
    when return-code = 0
        display 'server closed the connection' end-display
        compute buffer-length = return-code end-compute
    when other
        compute buffer-length = return-code end-compute
        display 'receiving from server ' buffer-length buffer(1:buffer-length) end-display
    end-evaluate
    .
abort-client.
    display abort-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program tcpipclient.

