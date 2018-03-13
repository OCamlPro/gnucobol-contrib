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
 01 J-TRUE                             BINARY-INT VALUE 1.
 01 J-FALSE                            BINARY-INT VALUE 0.

*> ALIGNMENT
 01 J-LEFT                             BINARY-INT VALUE 0.
 01 J-CENTER                           BINARY-INT VALUE 1.
 01 J-RIGHT                            BINARY-INT VALUE 2.
 01 J-TOP                              BINARY-INT VALUE 3.
 01 J-BOTTOM                           BINARY-INT VALUE 4.
 01 J-TOPLEFT                          BINARY-INT VALUE 5.
 01 J-TOPRIGHT                         BINARY-INT VALUE 6.
 01 J-BOTTOMLEFT                       BINARY-INT VALUE 7.
 01 J-BOTTOMRIGHT                      BINARY-INT VALUE 8.

*> CURSOR
 01 J-DEFAULT-CURSOR                   BINARY-INT VALUE 0.
 01 J-CROSSHAIR-CURSOR                 BINARY-INT VALUE 1.
 01 J-TEXT-CURSOR                      BINARY-INT VALUE 2.
 01 J-WAIT-CURSOR                      BINARY-INT VALUE 3.
 01 J-SW-RESIZE-CURSOR                 BINARY-INT VALUE 4.
 01 J-SE-RESIZE-CURSOR                 BINARY-INT VALUE 5.
 01 J-NW-RESIZE-CURSOR                 BINARY-INT VALUE 6.
 01 J-NE-RESIZE-CURSOR                 BINARY-INT VALUE 7.
 01 J-N-RESIZE-CURSOR                  BINARY-INT VALUE 8.
 01 J-S-RESIZE-CURSOR                  BINARY-INT VALUE 9.
 01 J-W-RESIZE-CURSOR                  BINARY-INT VALUE 10.
 01 J-E-RESIZE-CURSOR                  BINARY-INT VALUE 11.
 01 J-HAND-CURSOR                      BINARY-INT VALUE 12.
 01 J-MOVE-CURSOR                      BINARY-INT VALUE 13.

*> ORIENTATION
 01 J-HORIZONTAL                       BINARY-INT VALUE 0.
 01 J-VERTICAL                         BINARY-INT VALUE 1.

*> FONTS
 01 J-PLAIN                            BINARY-INT VALUE 0.
 01 J-BOLD                             BINARY-INT VALUE 1.
 01 J-ITALIC                           BINARY-INT VALUE 2.
 01 J-COURIER                          BINARY-INT VALUE 1.
 01 J-HELVETIA                         BINARY-INT VALUE 2.
 01 J-TIMES                            BINARY-INT VALUE 3.
 01 J-DIALOGIN                         BINARY-INT VALUE 4.
 01 J-DIALOGOUT                        BINARY-INT VALUE 5.

*> COLORS
 01 J-BLACK                            BINARY-INT VALUE 0.
 01 J-WHITE                            BINARY-INT VALUE 1.
 01 J-RED                              BINARY-INT VALUE 2.
 01 J-GREEN                            BINARY-INT VALUE 3.
 01 J-BLUE                             BINARY-INT VALUE 4.
 01 J-CYAN                             BINARY-INT VALUE 5.
 01 J-MAGENTA                          BINARY-INT VALUE 6.
 01 J-YELLOW                           BINARY-INT VALUE 7.
 01 J-ORANGE                           BINARY-INT VALUE 8.
 01 J-GREEN-YELLOW                     BINARY-INT VALUE 9.
 01 J-GREEN-CYAN                       BINARY-INT VALUE 10.
 01 J-BLUE-CYAN                        BINARY-INT VALUE 11.
 01 J-BLUE-MAGENTA                     BINARY-INT VALUE 12.
 01 J-RED-MAGENTA                      BINARY-INT VALUE 13.
 01 J-DARK-GRAY                        BINARY-INT VALUE 14.
 01 J-LIGHT-GRAY                       BINARY-INT VALUE 15.
 01 J-GRAY                             BINARY-INT VALUE 16.

*> BORDERSTYLE
 01 J-NONE                             BINARY-INT VALUE 0.
 01 J-LINEDOWN                         BINARY-INT VALUE 1.
 01 J-LINEUP                           BINARY-INT VALUE 2.
 01 J-AREADOWN                         BINARY-INT VALUE 3.
 01 J-AREAUP                           BINARY-INT VALUE 4.

*> MOUSELISTENER
 01 J-MOVED                            BINARY-INT VALUE 0.
 01 J-DRAGGED                          BINARY-INT VALUE 1.
 01 J-PRESSED                          BINARY-INT VALUE 2.
 01 J-RELEASED                         BINARY-INT VALUE 3.
 01 J-ENTERERD                         BINARY-INT VALUE 4.
 01 J-EXITED                           BINARY-INT VALUE 5.
 01 J-DOUBLECLICK                      BINARY-INT VALUE 6.

*> COMPONENTLISTENER

*> J-MOVED
 01 J-RESIZED                          BINARY-INT VALUE 1.
 01 J-HIDDEN                           BINARY-INT VALUE 2.
 01 J-SHOWN                            BINARY-INT VALUE 3.

*> WINDOWLISTENER
 01 J-ACTIVATED                        BINARY-INT VALUE 0.
 01 J-DEACTIVATED                      BINARY-INT VALUE 1.
 01 J-OPENED                           BINARY-INT VALUE 2.
 01 J-CLOSED                           BINARY-INT VALUE 3.
 01 J-ICONIFIED                        BINARY-INT VALUE 4.
 01 J-DEICONIFIED                      BINARY-INT VALUE 5.
 01 J-CLOSING                          BINARY-INT VALUE 6.

*> IMAGEFILEFORMAT
 01 J-GIF                              BINARY-INT VALUE 0.
 01 J-JPG                              BINARY-INT VALUE 1.
 01 J-PPM                              BINARY-INT VALUE 2.
 01 J-BMP                              BINARY-INT VALUE 3.

*> LEDFORMAT
 01 J-ROUND                            BINARY-INT VALUE 0.
 01 J-RECT                             BINARY-INT VALUE 1.

*> RANDOMMAX
 01 J-RANDMAX                          BINARY-INT VALUE 2147483647.
