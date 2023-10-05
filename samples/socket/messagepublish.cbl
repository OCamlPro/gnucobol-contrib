        >>SOURCE FORMAT FREE
identification division.
program-id. messagepublish.
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
*>
*> 1) receive a UDP datagram message from an messagesend
*> 2) scan a list of subscribers waiting for messages
*> 3) for each subscriber waiting for the received message,
*>    send the message to the listening subscriber
*>
*>     cobc -x messagepublish.cbl
*>     chmod +x messagepublish
*>
*> usage:
*>     ./messagepublish publishport
*>
*> example:
*>     ./messagepublish 8000
*>
*> the subscriber list is maintained in subscriberfile.txt
*> with format subscriberhost subscriberport message
*>
*> the subscriberfile is loaded to a table at startup
*> and also when the message 'load' is received
*>
*> messagepublish terminates when the message 'quit'
*> is received
*>
*> =======================================================

environment division.
configuration section.
repository. function all intrinsic.
input-output section.
file-control.
    select subscriber-file
        assign using subscriber-file-name
        organization is line sequential
        file status is subscriber-file-status.

data division.
file section.
fd  subscriber-file.
01  subscriber-record pic x(128).

working-storage section.
01  subscriber-file-name pic x(32) value 'subscriberfile.txt'.
01  subscriber-file-status pic xx.

01  errno binary-char unsigned.
01  errno-name pic x(16).
01  errno-message pic x(64).

01  general-message pic x(128).

01 publish-descriptor binary-int.
01 publish-address.
   03  publish-family binary-short.
   03  publish-port binary-short unsigned.
   03  publish-ip-address binary-int.
   03  filler pic x(8) value low-values.

01 AF_INET binary-int value 2.
01 SOCK_DGRAM binary-int value 2.
01 SOL_SOCKET binary-int value 1.
01 SO_REUSEADDR binary-int value 2.
01 YES binary-int value 1.
01 NL pic x value x'0A'.
01 CR pic x value x'0D'.

01 subscriber-descriptor binary-int.

01 message-data pic x(32).
01 message-length binary-short unsigned.

01 command-port pic X(16).
01 command-binary-port binary-short.

01 abort-message pic x(64).

01 subscribers.
   03  subscriber-entry occurs 100.
       05  subscriber-host pic x(64).
       05  subscriber-port pic x(16).
       05  subscriber-message pic x(32).
01 s pic 9(3).
01 s-max pic 9(3).
01 s-lim pic 9(3) value 100.
01 host pic x(64).
01 port pic x(16).

01 timestamp pic x(23).

procedure division.
start-messagepublish.

    call 'gettimestamp' using timestamp end-call

    accept command-port from command-line end-accept
    display timestamp space 'messagepublish started on port ' command-port end-display

    perform load-subscribers

    call 'socket' using
        by value AF_INET
        by value SOCK_DGRAM
        by value 0
        giving publish-descriptor
    end-call
    if return-code = -1
        move "messagepublish call 'socket' failed" to abort-message
        perform abort-publish
    end-if

    call 'setsockopt' using
        by value publish-descriptor
        by value SOL_SOCKET
        by value SO_REUSEADDR
        by reference YES
        by value length(YES)
    end-call 
    if return-code = -1
        move "messagepublish call 'setsockopt' failed" to abort-message
        perform abort-publish
    end-if

    unstring command-port delimited by space
        into command-binary-port
    end-unstring
    call 'htons' using by value
        command-binary-port
        giving publish-port
    end-call

    compute publish-family = AF_INET end-compute

    move 0 to publish-ip-address

    call 'bind' using
        by value publish-descriptor
        by reference publish-address
        by value length(publish-address)
    end-call
    if return-code = -1
        move "messagepublish call 'bind' failed" to abort-message
        perform abort-publish
    end-if

    perform receive-message
    perform until message-data = 'quit' or 'QUIT'
        evaluate true
        when message-data = 'load' or 'LOAD'
*>          load the list of subscribers
            perform load-subscribers
        when other
*>          scan the subscriber list
            perform varying s from 1 by 1
            until s > s-max
                if subscriber-message(s) = message-data(1:message-length)
                    move subscriber-host(s) to host
                    move subscriber-port(s) to port
                    call 'connecttoserver' using
                        AF_INET
                        SOCK_DGRAM
                        host
                        port
                        subscriber-descriptor
                    end-call
                    call 'send' using
                        by value subscriber-descriptor
                        by reference message-data
                        by value message-length
                        by value 0
                    end-call
                    move spaces to general-message
                    if return-code = -1
                        string timestamp ' messagepublish send ' delimited by size
                            message-data(1:message-length) delimited by size
                            ' to ' delimited by size
                            subscriber-host(s) delimited by space
                            space delimited by size
                            subscriber-port(s) delimited by space
                            ' failed ' delimited by size
                            into general-message
                        end-string
                     else
                        string timestamp ' messagepublish sent ' delimited by size
                            message-data(1:message-length) delimited by size
                            ' to ' delimited by size
                            subscriber-host(s) delimited by space
                            space delimited by size
                            subscriber-port(s) delimited by space
                            into general-message
                        end-string
                    end-if
                    display general-message end-display
                    call 'close' using by value subscriber-descriptor end-call
                end-if
            end-perform
        end-evaluate
        perform receive-message
    end-perform

    display timestamp ' messagepublish end' end-display
    stop run
    .
receive-message.
    move spaces to message-data
    call 'recv' using
        by value publish-descriptor
        by reference message-data
        by value length(message-data)
        by value 0
    end-call
    if return-code = -1
        move 'messagepublish recv failed' to abort-message
        perform abort-publish
    end-if
    compute message-length = return-code end-compute
    if message-length = 0
        move 'empty message' to message-data
        move 13 to message-length
    end-if
    call 'gettimestamp' using timestamp end-call
    display timestamp 
        ' messagepublish received message '
        message-data(1:message-length)
    end-display
    .
load-subscribers.
    move 0 to s-max
    open input subscriber-file
    read subscriber-file end-read
    perform until subscriber-file-status <> '00'
    or s-max >= s-lim
        if subscriber-record <> spaces
            add 1 to s-max end-add
            move space to subscriber-entry(s-max)
            unstring subscriber-record delimited by all spaces
                into subscriber-host(s-max) subscriber-port(s-max) subscriber-message(s-max)
            end-unstring
        end-if
        read subscriber-file end-read
    end-perform
    close subscriber-file
    if s-max >= s-lim
        move spaces to general-message
        string timestamp delimited by size
            ' messagepublish number of subscribers exceeds ' delimited by size
            s-lim delimited by size
            ' in ' delimited by size
            subscriber-file-name delimited by space
            into general-message
        end-string
        display general-message end-display
    end-if
    move spaces to general-message
    string timestamp delimited by size
        ' messagepublish loaded ' delimited by size
        s-max delimited by size
        ' subscribers from ' delimited by size
        subscriber-file-name delimited by space
        into general-message
    end-string
    display general-message end-display
    .
abort-publish.
    call 'gettimestamp' using timestamp end-call
    display timestamp space abort-message end-display
    call 'errnomessage' using
        by reference errno errno-name errno-message
    end-call
    display errno space errno-name errno-message end-display
    stop run
    .
end program messagepublish.

