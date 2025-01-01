*>******************************************************************************
*>  testsys2.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  testsys2.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with testsys2.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      testsys2.cob
*>
*> Purpose:      Test program for system2_cmd.c
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2025-01-01
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2025-01-01 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. testsys2.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.
 
 DATA DIVISION.
 WORKING-STORAGE SECTION.

 01 WS-CMD-IN                          PIC X(80).
*> adapt this according to your expected output
 78 C-CMD-OUT-MAX-LEN                  VALUE 10000.
 01 WS-CMD-OUT                         PIC X(C-CMD-OUT-MAX-LEN).
 01 WS-CMD-OUT-LEN                     BINARY-LONG VALUE 0.

 01 WS-RETURN-CODE                     BINARY-LONG.

 PROCEDURE DIVISION.
 
 MAIN-TESTSYS2 SECTION.

*>  test1
    MOVE "dir" TO WS-CMD-IN

    CALL "system2_cmd"
         USING BY CONTENT CONCATENATE(TRIM(WS-CMD-IN), X"00")
               BY VALUE     C-CMD-OUT-MAX-LEN
               BY REFERENCE WS-CMD-OUT
               BY REFERENCE WS-CMD-OUT-LEN
         RETURNING WS-RETURN-CODE
    END-CALL     
    
    DISPLAY "WS-CMD-IN: "         WS-CMD-IN
    DISPLAY "C-CMD-OUT-MAX-LEN: " C-CMD-OUT-MAX-LEN
    DISPLAY "WS-CMD-OUT: "        WS-CMD-OUT(1:WS-CMD-OUT-LEN)
    DISPLAY "WS-CMD-OUT-LEN: "    WS-CMD-OUT-LEN

    DISPLAY "WS-RETURN-CODE: "    WS-RETURN-CODE
    DISPLAY " "
    DISPLAY " "
    

*>  test2
    MOVE "set" TO WS-CMD-IN

    CALL "system2_cmd"
         USING BY CONTENT CONCATENATE(TRIM(WS-CMD-IN), X"00")
               BY VALUE     C-CMD-OUT-MAX-LEN
               BY REFERENCE WS-CMD-OUT
               BY REFERENCE WS-CMD-OUT-LEN
         RETURNING WS-RETURN-CODE
    END-CALL     
    
    DISPLAY "WS-CMD-IN: "         WS-CMD-IN
    DISPLAY "C-CMD-OUT-MAX-LEN: " C-CMD-OUT-MAX-LEN
    DISPLAY "WS-CMD-OUT: "        WS-CMD-OUT(1:WS-CMD-OUT-LEN)
    DISPLAY "WS-CMD-OUT-LEN: "    WS-CMD-OUT-LEN

    DISPLAY "WS-RETURN-CODE: "    WS-RETURN-CODE
    DISPLAY " "
    DISPLAY " "


*>  test3
*>  if you have a working curl, then you can try this or something similar
*>  MOVE "curl https://sourceforge.net/p/gnucobol/discussion" TO WS-CMD-IN
*>
*>  CALL "system2_cmd"
*>       USING BY CONTENT CONCATENATE(TRIM(WS-CMD-IN), X"00")
*>             BY VALUE     C-CMD-OUT-MAX-LEN
*>             BY REFERENCE WS-CMD-OUT
*>             BY REFERENCE WS-CMD-OUT-LEN
*>       RETURNING WS-RETURN-CODE
*>  END-CALL     
*>  
*>  DISPLAY "WS-CMD-IN: "         WS-CMD-IN
*>  DISPLAY "C-CMD-OUT-MAX-LEN: " C-CMD-OUT-MAX-LEN
*>  DISPLAY "WS-CMD-OUT: "        WS-CMD-OUT(1:WS-CMD-OUT-LEN)
*>  DISPLAY "WS-CMD-OUT-LEN: "    WS-CMD-OUT-LEN
*>
*>  DISPLAY "WS-RETURN-CODE: "    WS-RETURN-CODE
*>  DISPLAY " "
*>  DISPLAY " "


*>  test4
*>  this can produce a very big output --> please adapt C-CMD-OUT-MAX-LEN above
*>  MOVE "tree c:\\" TO WS-CMD-IN
*>
*>  CALL "system2_cmd"
*>       USING BY CONTENT CONCATENATE(TRIM(WS-CMD-IN), X"00")
*>             BY VALUE     C-CMD-OUT-MAX-LEN
*>       BY REFERENCE WS-CMD-OUT
*>             BY REFERENCE WS-CMD-OUT-LEN
*>       RETURNING WS-RETURN-CODE
*>  END-CALL     
*>
*>  DISPLAY "WS-CMD-IN: "         WS-CMD-IN
*>  DISPLAY "C-CMD-OUT-MAX-LEN: " C-CMD-OUT-MAX-LEN
*>  DISPLAY "WS-CMD-OUT: "        WS-CMD-OUT(1:WS-CMD-OUT-LEN)
*>  DISPLAY "WS-CMD-OUT-LEN: "    WS-CMD-OUT-LEN
*>
*>  DISPLAY "WS-RETURN-CODE: "    WS-RETURN-CODE
*>  DISPLAY " "
*>  DISPLAY " "


    STOP RUN.
 
 END PROGRAM testsys2.
