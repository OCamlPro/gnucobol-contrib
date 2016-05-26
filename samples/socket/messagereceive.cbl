        >>SOURCE FORMAT FREE
identification division.
program-id. messagereceive.
*> 
*>  Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
*> 
*>  This program is free software; you can redistribute it and/or
*>  modify it under the terms of the GNU General Public License as
*>  receiveed by the Free Software Foundation; either version 2,
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

*> =========================================================
*>
*> receive a UDP datagram message from a sender or publisher
*> and terminate
*>
*>     cobc -x messagereceive.cbl
*>     chmod +x messagereceive
*>
*> usage:
*>     ./messagereceive receiveport
*>
*> example:
*>     ./receive 8001
*>
*> =========================================================

environment division.
configuration section.
repository. function all intrinsic.

data division.

working-storage section.
01  errno binary-char unsigned.
01  errno-name pic x(16).
01  errno-message pic x(64).

01  general-message pic x(128).

01 receive-descriptor binary-int.
01 receive-address.
   03  receive-family binary-short.
   03  receive-port binary-short unsigned.
   03  receive-ip-address binary-int.
   03  filler pic x(8) value low-values.

01 AF_INET binary-int value 2.
01 SOCK_DGRAM binary-int value 2.
01 SOL_SOCKET binary-int value 1.
01 SO_REUSEADDR binary-int value 2.
01 YES binary-int value 1.

01 message pic x(32).
01 message-length binary-short unsigned.

01 command-port pic X(16).
01 command-binary-port binary-short.

01 abort-message pic x(64).

01 timestamp pic x(23).

procedure division.
start-messagereceive.

    call 'gettimestamp' using timestamp end-call

    accept command-port from command-line end-accept
    display timestamp space 'messagereceive started on port ' command-port end-display

    call 'socket' using
        by value AF_INET
        by value SOCK_DGRAM
        by value 0
        giving receive-descriptor
    end-call
    if return-code = -1
        move "messagereceive call 'socket' failed" to abort-message
        perform abort-receive
    end-if

    call 'setsockopt' using
        by value receive-descriptor
        by value SOL_SOCKET
        by value SO_REUSEADDR
        by reference YES
        by value length(YES)
    end-call 
    if return-code = -1
        move "messagereceive call 'setsockopt' failed" to abort-message
        perform abort-receive
    end-if

    unstring command-port delimited by space
        into command-binary-port
    end-unstring
    call 'htons' using by value
        command-binary-port
        giving receive-port
    end-call

    compute receive-family = AF_INET end-compute

    move 0 to receive-ip-address

    call 'bind' using
        by value receive-descriptor
        by reference receive-address
        by value length(receive-address)
    end-call
    if return-code = -1
        move "messagereceive call 'bind' failed" to abort-message
        perform abort-receive
    end-if

    move spaces to message
    call 'recv' using
        by value receive-descriptor
        by reference message
        by value length(message)
        by value 0
    end-call
    if return-code = -1
        move "messagereceive call 'recv' failed" to abort-message
        perform abort-receive
    end-if
    compute message-length = return-code end-compute
    if message-length = 0
        move 'empty message' to message
        move 13 to message-length
    end-if
    call 'close' using by value receive-descriptor end-call

    move spaces to general-message
    call 'gettimestamp' using timestamp end-call
    string timestamp delimited by size
        ' messagereceive received message ' delimited by size
        message(1:message-length) delimited by size
        into general-message
    end-string
    display general-message end-display

    display timestamp ' messagereceive end' end-display
    stop run
    .
abort-receive.
    call 'gettimestamp' using timestamp end-call
    display timestamp space abort-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program messagereceive.


