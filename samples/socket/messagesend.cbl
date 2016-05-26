          >>SOURCE FORMAT FREE
identification division.
program-id. messagesend.
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

*> ==================================================
*> Send a UDP datagram message and terminate
*>
*>     cobc -x messagesend.cbl
*>     chmod +x messagesend
*>
*> usage:
*>     ./messagesend targetaddress targetport message
*> 
*> example
*>     ./messagesend localhost 8000 backupcomplete
*> ==================================================

environment division.
configuration section.
repository. function all intrinsic.

data division.
working-storage section.
01 errno binary-char unsigned.
01 errno-name pic x(16).
01 errno-message pic x(64).

01 abort-message pic x(64).

01 general-message pic x(128).

01 socket-descriptor binary-int.

01 AF_INET binary-int value 2.
01 SOCK_DGRAM binary-int value 2.

01 command-parameters pic x(128).
01 command-server pic x(64) value spaces.
01 command-port  pic x(16) value spaces.
01 command-message pic x(32) value spaces.

01 message-length binary-int.

01 timestamp pic x(23).

procedure division.
start-messagesend.

    accept command-parameters from command-line end-accept
    unstring command-parameters delimited by all spaces
        into command-server command-port command-message
    end-unstring

    perform connect-to-server

    perform varying message-length from 1 by 1
    until message-length > length(command-message)
    or command-message(message-length:) = space
        continue
    end-perform
    subtract 1 from message-length end-subtract

    call 'send' using by value socket-descriptor
        by reference command-message
        by value message-length
        by value 0
    end-call
    if return-code = -1
        move "messagesend call 'send' failed" to abort-message
        perform abort-client
    end-if

    call 'close' using by value socket-descriptor end-call

    move spaces to general-message
    call 'gettimestamp' using timestamp end-call
    string timestamp delimited by size
        ' messagesend sent message ' delimited by size
        command-message(1:message-length) delimited by size
        ' to ' delimited by size
        command-server delimited by spaces
        space delimited by size
        command-port delimited by spaces
        into general-message
    end-string
    display general-message end-display

    stop run
    .
connect-to-server.
    call 'connecttoserver' using
        AF_INET
        SOCK_DGRAM
        command-server
        command-port
        socket-descriptor
    end-call
    .
abort-client.
    call 'gettimestamp' using timestamp end-call
    display timestamp space abort-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program messagesend.

