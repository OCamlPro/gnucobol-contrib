        >>SOURCE FORMAT FREE
identification division.
program-id. gettimestamp.
*> 
*>  Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
*> 
*>  This program is free software; you can redistribute it and/or
*>  modify it under the terms of the GNU General Public License as
*>  publishered by the Free Software Foundation; either version 2,
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

*> ====================================================
*>
*> return the current-date formatted to the caller
*>
*>     cobc gettimestamp.cbl
*>
*> usage:
*>     call 'gettimestamp' returning timestamp end-call
*>
*> ====================================================

environment division.
configuration section.
repository. function all intrinsic.

data division.
working-storage section.
01 current-date-and-time.
   05 cdt-year pic 9(4).
   05 cdt-month pic 9(2).
   05 cdt-day pic 9(2).
   05 cdt-hour pic 9(2).
   05 cdt-minutes pic 9(2).
   05 cdt-seconds pic 9(2).
   05 cdt-hundredths pic 9(2).

linkage section.
01 timestamp pic x(23).

procedure division using timestamp.
start-gettimestamp.
    move current-date to current-date-and-time    
    string cdt-year '-' cdt-month '-' cdt-day delimited by size
        space cdt-hour ':' cdt-minutes "'" cdt-seconds '.' cdt-hundredths '"' delimited by size
        into timestamp
    end-string
    goback
    .
end program gettimestamp.


