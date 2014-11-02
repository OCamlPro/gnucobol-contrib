      * get-iso-week
      * A small library which computes the week of the year a date is in.

      * Copyright (C) 2014 Edward Hart <edward.dan.hart@gmail.com>
      *
      * This program is free software: you can redistribute it and/or modify
      * it under the terms of the GNU General Public License as published by
      * the Free Software Foundation, either version 3 of the License, or
      * (at your option) any later version.
      *
      * This program is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public License
      * along with this program.  If not, see <http://www.gnu.org/licenses/>.

      * The date must be the number of days since 1 January 1601 (the COBOL epoch).
      * This is a translation of get_iso_week() in the FORMATTED-DATE/TIME
      * patch available at <https://sourceforge.net/p/open-cobol/patches/19/>.
      *
      * Derived from "Calculating the ISO week number for a date" by Julian M.
      * Bucknall (http://www.boyet.com/articles/publishedarticles/calculatingtheisoweeknumb.html).
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. get-iso-week.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  day-num-date                 PIC 9(7).
       01  day-of-year                  PIC 9(3) USAGE COMP.
       01  days-in-year                 PIC 9(3) USAGE COMP.
       01  days-to-dec-29               PIC 9(3) USAGE COMP.
       01  dec-29                       PIC 9(7) USAGE COMP.
       01  last-day-of-9999             PIC 9(7) USAGE COMP
                                        VALUE 3067671.
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

           COMPUTE day-num-date = FUNCTION DAY-OF-INTEGER(day-num)
           MOVE day-num-date (1:4) TO year
           MOVE day-num-date (5:3) TO day-of-year

           PERFORM get-days-in-year
           SUBTRACT 2 FROM days-in-year GIVING days-to-dec-29
           COMPUTE dec-29 = day-num - day-of-year + days-to-dec-29

           ADD days-in-year TO day-num GIVING some-day-next-year
           SUBTRACT day-of-year FROM day-num GIVING last-day-last-year

           IF day-num >= dec-29
               CALL "get-iso-week-one" USING some-day-next-year, day-of-year,
                   week-one
               IF day-num < week-one
                   CALL "get-iso-week-one" USING day-num, day-of-year,
                       week-one
               ELSE
                   ADD 1 TO year
               END-IF
           ELSE
               CALL "get-iso-week-one" USING day-num, day-of-year,
                   week-one
               IF day-num < week-one
                   SUBTRACT 1 FROM year
                   PERFORM get-days-in-year
                   CALL "get-iso-week-one" USING last-day-last-year,
                       days-in-year, week-one
               END-IF
           END-IF

           COMPUTE week = (day-num - week-one) / 7 + 1

           EXIT PROGRAM
           .
       get-days-in-year SECTION.
           IF FUNCTION MOD(year, 400) = ZERO
                   OR (FUNCTION MOD(year, 4) = ZERO
                       AND FUNCTION MOD(year, 100) NOT = ZERO)
               MOVE 366 TO days-in-year
           ELSE
               MOVE 365 TO days-in-year
           END-IF
           .
       END PROGRAM get-iso-week.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. get-iso-week-one.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  jan-4                        PIC 9(7) USAGE COMP.
       01  dday-of-week                 PIC 9 USAGE COMP.

       LINKAGE SECTION.
       01  day-num                      PIC 9(7) USAGE COMP.
       01  day-of-year                  PIC 9(3) USAGE COMP.

       01  first-monday                 PIC 9(7) USAGE COMP.

       PROCEDURE DIVISION USING day-num, day-of-year, first-monday.
           COMPUTE jan-4 = day-num - day-of-year + 4
           COMPUTE dday-of-week = FUNCTION MOD(jan-4 - 1, 7)
           SUBTRACT dday-of-week FROM jan-4 GIVING first-monday
           .
       END PROGRAM get-iso-week-one.
