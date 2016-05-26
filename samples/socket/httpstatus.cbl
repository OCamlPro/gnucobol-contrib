          >>SOURCE FORMAT FREE
identification division.
program-id. httpstatus.
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

*> ===========================================================
*> eturn the http-status-message for a given http-status-code
*> ============================================================


data division.
linkage section.
01  status-code pic x(3).
01  status-message pic x(40).
procedure division using status-code, status-message.
start-status-message.
    evaluate status-code
*>  10.1 Informational 1xx
    when '100'
        move 'Continue' to status-message
    when '101'
        move 'Switching Protocols' to status-message
*>  Successful 2xx
    when '200'
        move 'OK' to status-message
    when '201'
        move 'Created' to status-message
    when '202'
        move 'Accepted' to status-message
    when '203'
        move 'Non-Authoritative Information' to status-message
    when '204'
        move 'No Content' to status-message
    when '205'
        move 'Reset Content' to status-message
    when '206'
        move 'Partial Content' to status-message
*>  Redirection 3xx
    when '300'
        move 'Multiple Choices' to status-message
    when '301'
        move 'Moved Permanently' to status-message
    when '302'
        move 'Found' to status-message
    when '303'
        move 'See Other' to status-message
    when '304'
        move 'Not Modified' to status-message
    when '305'
        move 'Use Proxy' to status-message
    when '306'
        move '(Unused)' to status-message
*>  Client Error 4xx
    when '400'
        move 'Bad Request' to status-message
    when '401'
        move 'Unauthorized' to status-message
    when '402'
        move 'Payment Required' to status-message
    when '403'
        move 'Forbidden' to status-message
    when '404'
        move 'Not Found' to status-message
    when '405'
        move 'Method Not Allowed' to status-message
    when '406'
        move 'Not Acceptable' to status-message
    when '407'
        move 'Proxy Authentication Required' to status-message
    when '408'
        move 'Request Timeout' to status-message
    when '409'
        move 'Conflict' to status-message
    when '410'
        move 'Gone' to status-message
    when '411'
        move 'Length Required' to status-message
    when '412'
        move 'Precondition Failed' to status-message
    when '413'
        move 'Request Entity Too Large' to status-message
    when '414'
        move 'Request-URI Too Long' to status-message
    when '415'
        move 'Unsupported Media Type' to status-message
    when '416'
        move 'Requested Range Not Satisfiable' to status-message
    when '417'
        move 'Expectation Failed' to status-message
*>  Server Error 5xx
    when '500'
        move 'Internal Server Error' to status-message
    when '501'
        move 'Not Implemented' to status-message
    when '502'
        move 'Bad Gateway' to status-message
    when '503'
        move 'Service Unavailable' to status-message
    when '504'
        move 'Gateway Timeout' to status-message
    when '505'
        move 'HTTP Version Not Supported' to status-message
    when other
        move 'unknown status' to status-message
    end-evaluate
    goback
    .
end program httpstatus.

