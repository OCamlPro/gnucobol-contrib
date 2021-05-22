*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  ifrm_product_category.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  ifrm_product_category.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with ifrm_product_category.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      ifrm_product_category.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2021.05.15
*>
*> Tectonics:    Example for static link.
*>               cobc -m -free ifrm_product_category.cob cobjapi.o \
*>                                                       japilib.o \
*>                                                       imageio.o \
*>                                                       fileselect.o
*>
*> Usage:        ./ifrm_product_category.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.05.15 Laszlo Erdos: 
*>            - first version.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. ifrm_product_category.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC
    COPY "CobjapiFunctions.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 COPY "CobjapiConstants.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-INTERNALFRAME                   BINARY-LONG.
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-HELP                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-HELP-IFRM                       BINARY-LONG.
 01 WS-BUTTON                          BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-PANEL                           BINARY-LONG.
 01 WS-ICON                            BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-RESIZABLE                       BINARY-LONG.
 01 WS-CLOSABLE                        BINARY-LONG.
 01 WS-MAXIMIZABLE                     BINARY-LONG.
 01 WS-ICONIFIABLE                     BINARY-LONG.

*> for the CURRENT-DATE function
 01 CURRENT-DATE-AND-TIME.
   02 CDT-YEAR                         PIC 9(4).
   02 CDT-MONTH                        PIC 9(2). *> 01-12
   02 CDT-DAY                          PIC 9(2). *> 01-31
   02 CDT-HOUR                         PIC 9(2). *> 00-23
   02 CDT-MINUTES                      PIC 9(2). *> 00-59
   02 CDT-SECONDS                      PIC 9(2). *> 00-59
   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99
   02 CDT-GMT-DIFF-HOURS               PIC S9(2) SIGN LEADING SEPARATE.
   02 CDT-GMT-DIFF-MINUTES             PIC 9(2). *> 00 OR 30 
*> time fields
 01 WS-DATE-TIME.
   02 CDT-YEAR                         PIC 9(4).
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-MONTH                        PIC 9(2). *> 01-12
   02 FILLER                           PIC X(1) VALUE "-".
   02 CDT-DAY                          PIC 9(2). *> 01-31
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-HOUR                         PIC 9(2). *> 00-23
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-MINUTES                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE ":".
   02 CDT-SECONDS                      PIC 9(2). *> 00-59
   02 FILLER                           PIC X(1) VALUE ".".
   02 CDT-HUNDREDTHS-OF-SECS           PIC 9(2). *> 00-99

 LINKAGE SECTION.
 01 LNK-MAIN-FRAME                     BINARY-LONG.
 01 LNK-DESKTOPPANE                    BINARY-LONG.
 01 LNK-ACTION-OBJ                     BINARY-LONG.
 01 LNK-NODE-NAME                      PIC X(40).
 01 LNK-IFRAME-CREATED                 PIC 9(1).
    88 V-NO                            VALUE 0.
    88 V-YES                           VALUE 1.

 PROCEDURE DIVISION USING LNK-MAIN-FRAME
                          LNK-DESKTOPPANE
                          LNK-ACTION-OBJ
                          LNK-NODE-NAME
                          LNK-IFRAME-CREATED.

*>------------------------------------------------------------------------------
 MAIN-IFRM SECTION.
*>------------------------------------------------------------------------------

    IF V-NO OF LNK-IFRAME-CREATED
    THEN
       PERFORM CREATE-INTERNAL-FRAME
    ELSE
       PERFORM PROCESS-ACTION-EVENT
    END-IF   

    GOBACK
    
    .
 MAIN-IFRM-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CREATE-INTERNAL-FRAME SECTION.
*>------------------------------------------------------------------------------

    SET V-YES OF LNK-IFRAME-CREATED TO TRUE

    MOVE J-TRUE TO WS-RESIZABLE  
    MOVE J-TRUE TO WS-CLOSABLE   
    MOVE J-TRUE TO WS-MAXIMIZABLE
    MOVE J-TRUE TO WS-ICONIFIABLE
    MOVE J-INTERNALFRAME(LNK-DESKTOPPANE, LNK-NODE-NAME, 
         WS-RESIZABLE, WS-CLOSABLE, WS-MAXIMIZABLE, WS-ICONIFIABLE) TO WS-INTERNALFRAME

    MOVE J-MENUBAR(WS-INTERNALFRAME)        TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")         TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")        TO WS-QUIT
    MOVE J-HELPMENU(WS-MENUBAR, "Help")     TO WS-HELP
    MOVE J-MENUITEM(WS-HELP, LNK-NODE-NAME) TO WS-HELP-IFRM

    MOVE J-LOADIMAGE("images/new.gif") TO WS-ICON  
    MOVE J-SETICON(WS-INTERNALFRAME, WS-ICON) TO WS-RET
         
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-INTERNALFRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-INTERNALFRAME, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE J-SETBORDERLAYOUT(WS-INTERNALFRAME)              TO WS-RET

    MOVE J-PANEL(WS-INTERNALFRAME) TO WS-PANEL

    MOVE J-LABEL(WS-PANEL, "Test Label")     TO WS-LABEL
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)  TO WS-RET

    MOVE J-BUTTON(WS-PANEL, "Test Button")   TO WS-BUTTON
    MOVE 30 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-SHOW(WS-INTERNALFRAME) TO WS-RET
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 PROCESS-ACTION-EVENT SECTION.
*>------------------------------------------------------------------------------

*>  the action loop is in the main program
    IF LNK-ACTION-OBJ = WS-QUIT
    THEN
       SET V-NO OF LNK-IFRAME-CREATED TO TRUE
       MOVE J-HIDE(WS-INTERNALFRAME)    TO WS-RET
       MOVE J-DISPOSE(WS-INTERNALFRAME) TO WS-RET
    END-IF

    IF LNK-ACTION-OBJ = WS-INTERNALFRAME
    THEN
       SET V-NO OF LNK-IFRAME-CREATED TO TRUE
    END-IF

    IF LNK-ACTION-OBJ = WS-HELP-IFRM
    THEN
       MOVE J-ALERTBOX(LNK-MAIN-FRAME, 
            "Help for this internal frame",
            "TODO: short description of this internal frame...",
            "OK"
            )
         TO WS-RET                    
    END-IF

    IF LNK-ACTION-OBJ = WS-BUTTON
    THEN
       MOVE FUNCTION CURRENT-DATE      TO CURRENT-DATE-AND-TIME
       MOVE CORR CURRENT-DATE-AND-TIME TO WS-DATE-TIME
       MOVE J-SETTEXT(WS-LABEL, WS-DATE-TIME) TO WS-RET
    END-IF

    EXIT SECTION .
    
 END PROGRAM ifrm_product_category.
