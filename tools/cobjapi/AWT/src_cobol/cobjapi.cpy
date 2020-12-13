*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  cobjapi.cpy is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  cobjapi.cpy is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with cobjapi.cpy.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      cobjapi.cpy
*>
*> Purpose:      Constants for the cobjapi wrapper
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    ---
*>
*> Usage:        Use this copy file in GnuCOBOL GUI programs.
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - japi.h converted into cobjapi.cpy. 
*>******************************************************************************

*> BOOLEAN
 01 J-TRUE                             BINARY-LONG VALUE 1.
 01 J-FALSE                            BINARY-LONG VALUE 0.

*> ALIGNMENT
 01 J-LEFT                             BINARY-LONG VALUE 0.
 01 J-CENTER                           BINARY-LONG VALUE 1.
 01 J-RIGHT                            BINARY-LONG VALUE 2.
 01 J-TOP                              BINARY-LONG VALUE 3.
 01 J-BOTTOM                           BINARY-LONG VALUE 4.
 01 J-TOPLEFT                          BINARY-LONG VALUE 5.
 01 J-TOPRIGHT                         BINARY-LONG VALUE 6.
 01 J-BOTTOMLEFT                       BINARY-LONG VALUE 7.
 01 J-BOTTOMRIGHT                      BINARY-LONG VALUE 8.

*> CURSOR
 01 J-DEFAULT-CURSOR                   BINARY-LONG VALUE 0.
 01 J-CROSSHAIR-CURSOR                 BINARY-LONG VALUE 1.
 01 J-TEXT-CURSOR                      BINARY-LONG VALUE 2.
 01 J-WAIT-CURSOR                      BINARY-LONG VALUE 3.
 01 J-SW-RESIZE-CURSOR                 BINARY-LONG VALUE 4.
 01 J-SE-RESIZE-CURSOR                 BINARY-LONG VALUE 5.
 01 J-NW-RESIZE-CURSOR                 BINARY-LONG VALUE 6.
 01 J-NE-RESIZE-CURSOR                 BINARY-LONG VALUE 7.
 01 J-N-RESIZE-CURSOR                  BINARY-LONG VALUE 8.
 01 J-S-RESIZE-CURSOR                  BINARY-LONG VALUE 9.
 01 J-W-RESIZE-CURSOR                  BINARY-LONG VALUE 10.
 01 J-E-RESIZE-CURSOR                  BINARY-LONG VALUE 11.
 01 J-HAND-CURSOR                      BINARY-LONG VALUE 12.
 01 J-MOVE-CURSOR                      BINARY-LONG VALUE 13.

*> ORIENTATION
 01 J-HORIZONTAL                       BINARY-LONG VALUE 0.
 01 J-VERTICAL                         BINARY-LONG VALUE 1.

*> FONTS
 01 J-PLAIN                            BINARY-LONG VALUE 0.
 01 J-BOLD                             BINARY-LONG VALUE 1.
 01 J-ITALIC                           BINARY-LONG VALUE 2.
 01 J-COURIER                          BINARY-LONG VALUE 1.
 01 J-HELVETIA                         BINARY-LONG VALUE 2.
 01 J-TIMES                            BINARY-LONG VALUE 3.
 01 J-DIALOGIN                         BINARY-LONG VALUE 4.
 01 J-DIALOGOUT                        BINARY-LONG VALUE 5.

*> COLORS
 01 J-BLACK                            BINARY-LONG VALUE 0.
 01 J-WHITE                            BINARY-LONG VALUE 1.
 01 J-RED                              BINARY-LONG VALUE 2.
 01 J-GREEN                            BINARY-LONG VALUE 3.
 01 J-BLUE                             BINARY-LONG VALUE 4.
 01 J-CYAN                             BINARY-LONG VALUE 5.
 01 J-MAGENTA                          BINARY-LONG VALUE 6.
 01 J-YELLOW                           BINARY-LONG VALUE 7.
 01 J-ORANGE                           BINARY-LONG VALUE 8.
 01 J-GREEN-YELLOW                     BINARY-LONG VALUE 9.
 01 J-GREEN-CYAN                       BINARY-LONG VALUE 10.
 01 J-BLUE-CYAN                        BINARY-LONG VALUE 11.
 01 J-BLUE-MAGENTA                     BINARY-LONG VALUE 12.
 01 J-RED-MAGENTA                      BINARY-LONG VALUE 13.
 01 J-DARK-GRAY                        BINARY-LONG VALUE 14.
 01 J-LIGHT-GRAY                       BINARY-LONG VALUE 15.
 01 J-GRAY                             BINARY-LONG VALUE 16.

*> BORDERSTYLE
 01 J-NONE                             BINARY-LONG VALUE 0.
 01 J-LINEDOWN                         BINARY-LONG VALUE 1.
 01 J-LINEUP                           BINARY-LONG VALUE 2.
 01 J-AREADOWN                         BINARY-LONG VALUE 3.
 01 J-AREAUP                           BINARY-LONG VALUE 4.

*> MOUSELISTENER
 01 J-MOVED                            BINARY-LONG VALUE 0.
 01 J-DRAGGED                          BINARY-LONG VALUE 1.
 01 J-PRESSED                          BINARY-LONG VALUE 2.
 01 J-RELEASED                         BINARY-LONG VALUE 3.
 01 J-ENTERERD                         BINARY-LONG VALUE 4.
 01 J-EXITED                           BINARY-LONG VALUE 5.
 01 J-DOUBLECLICK                      BINARY-LONG VALUE 6.

*> COMPONENTLISTENER

*> J-MOVED
 01 J-RESIZED                          BINARY-LONG VALUE 1.
 01 J-HIDDEN                           BINARY-LONG VALUE 2.
 01 J-SHOWN                            BINARY-LONG VALUE 3.

*> WINDOWLISTENER
 01 J-ACTIVATED                        BINARY-LONG VALUE 0.
 01 J-DEACTIVATED                      BINARY-LONG VALUE 1.
 01 J-OPENED                           BINARY-LONG VALUE 2.
 01 J-CLOSED                           BINARY-LONG VALUE 3.
 01 J-ICONIFIED                        BINARY-LONG VALUE 4.
 01 J-DEICONIFIED                      BINARY-LONG VALUE 5.
 01 J-CLOSING                          BINARY-LONG VALUE 6.

*> IMAGEFILEFORMAT
 01 J-GIF                              BINARY-LONG VALUE 0.
 01 J-JPG                              BINARY-LONG VALUE 1.
 01 J-PPM                              BINARY-LONG VALUE 2.
 01 J-BMP                              BINARY-LONG VALUE 3.

*> LEDFORMAT
 01 J-ROUND                            BINARY-LONG VALUE 0.
 01 J-RECT                             BINARY-LONG VALUE 1.

*> RANDOMMAX
 01 J-RANDMAX                          BINARY-LONG VALUE 2147483647.
