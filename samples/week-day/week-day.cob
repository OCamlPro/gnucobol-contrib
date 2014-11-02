       >>SOURCE FREE
*> get-iso-week
*> A small library which computes the week of the year a date is in.

*> Copyright (C) 2014 Edward Hart <edward.dan.hart@gmail.com>
*>
*> This program is free software: you can redistribute it and/or modify
*> it under the terms of the GNU General Public License as published by
*> the Free Software Foundation, either version 3 of the License, or
*> (at your option) any later version.
*>
*> This program is distributed in the hope that it will be useful,
*> but WITHOUT ANY WARRANTY; without even the implied warranty of
*> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*> GNU General Public License for more details.
*>
*> You should have received a copy of the GNU General Public License
*> along with this program.  If not, see <http://www.gnu.org/licenses/>.

*> The date must be the number of days since 1 January 1601 (the COBOL epoch).
*> This is a faithful translation of get_iso_week() in the FORMATTED-DATE/TIME
*> patch available at <https://sourceforge.net/p/open-cobol/patches/19/>.
*> Derived from "Calculating the ISO week number for a date" by Julian M.
*> Bucknall (http://www.boyet.com/articles/publishedarticles/calculatingtheisoweeknumb.html).


IDENTIFICATION DIVISION.
PROGRAM-ID. get-iso-week.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION get-days-in-year
    FUNCTION get-iso-week-one
    .
DATA DIVISION.
WORKING-STORAGE SECTION.
01  day-num-date.
    03  day-num-year             PIC 9(4).
    03  day-num-day-of-year      PIC 9(3).

01  day-of-year                  PIC 9(3) USAGE COMP.
01  days-in-year                 PIC 9(3) USAGE COMP.
01  days-to-dec-29               PIC 9(3) USAGE COMP.
01  dec-29                       PIC 9(7) USAGE COMP.
01  last-day-of-9999             CONSTANT 3067671.
01  last-day-last-year           PIC 9(7) USAGE COMP.
01  some-day-next-year           PIC 9(7) USAGE COMP.
01  week-one                     PIC 9(7) USAGE COMP.

LINKAGE SECTION.
01  day-num                      PIC 9(7) USAGE COMP.
01  year                         PIC 9(4) USAGE COMP.
01  week                         PIC 99 USAGE COMP.

PROCEDURE DIVISION USING day-num, year, week.
    IF day-num = ZERO OR > last-day-of-9999
        MOVE ZERO TO year, week
        EXIT PROGRAM
    END-IF

    MOVE FUNCTION DAY-OF-INTEGER(day-num) TO day-num-date
    MOVE day-num-year TO year
    MOVE day-num-day-of-year TO day-of-year

    MOVE FUNCTION get-days-in-year(year) TO days-in-year
    SUBTRACT 2 FROM days-in-year GIVING days-to-dec-29
    COMPUTE dec-29 = day-num - day-of-year + days-to-dec-29

    ADD days-in-year TO day-num GIVING some-day-next-year
    SUBTRACT day-of-year FROM day-num GIVING last-day-last-year

    IF day-num >= dec-29
        MOVE FUNCTION get-iso-week-one(some-day-next-year, day-of-year)
            TO week-one
        IF day-num < week-one
            MOVE FUNCTION get-iso-week-one(day-num, day-of-year) TO week-one
        ELSE
            ADD 1 TO year
        END-IF
    ELSE
        MOVE FUNCTION get-iso-week-one(day-num, day-of-year) TO week-one
        IF day-num < week-one
            SUBTRACT 1 FROM year
            MOVE FUNCTION get-days-in-year(year) TO days-in-year
            MOVE FUNCTION get-iso-week-one(last-day-last-year, days-in-year)
                TO week-one
        END-IF
    END-IF

    COMPUTE week = (day-num - week-one) / 7 + 1
    .
END PROGRAM get-iso-week.


IDENTIFICATION DIVISION.
FUNCTION-ID. get-iso-week-one.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION get-day-of-week
    .
DATA DIVISION.
WORKING-STORAGE SECTION.
01  jan-4                        PIC 9(7) USAGE COMP.
01  dday-of-week                 PIC 9 USAGE COMP.

LINKAGE SECTION.
01  day-num                      PIC 9(7) USAGE COMP.
01  day-of-year                  PIC 9(3) USAGE COMP.

01  first-monday                 PIC 9(7) USAGE COMP.

PROCEDURE DIVISION USING day-num, day-of-year RETURNING first-monday.
    COMPUTE jan-4 = day-num - day-of-year + 4
    MOVE FUNCTION get-day-of-week (jan-4) TO dday-of-week
    SUBTRACT dday-of-week FROM jan-4 GIVING first-monday
    .
END FUNCTION get-iso-week-one.


IDENTIFICATION DIVISION.
FUNCTION-ID. get-days-in-year.

DATA DIVISION.
LINKAGE SECTION.
01  year                                PIC 9(4) USAGE COMP.
01  days-in-year                        PIC 9(3) USAGE COMP.

PROCEDURE DIVISION USING year RETURNING days-in-year.
    IF FUNCTION MOD(year, 400) = ZERO
            OR (FUNCTION MOD(year, 4) = ZERO
                AND FUNCTION MOD(year, 100) <> ZERO)
        MOVE 366 TO days-in-year
    ELSE
        MOVE 365 TO days-in-year
    END-IF
    .
END FUNCTION get-days-in-year.


IDENTIFICATION DIVISION.
FUNCTION-ID. get-day-of-week.

DATA DIVISION.
LINKAGE SECTION.
01  day-num                             PIC 9(7) USAGE COMP.
01  the-day-of-week                     PIC 9 USAGE COMP.

PROCEDURE DIVISION USING day-num RETURNING the-day-of-week.
    MOVE FUNCTION MOD(day-num - 1, 7) TO the-day-of-week
    .
END FUNCTION get-day-of-week.
