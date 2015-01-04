/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Const.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Const.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Const.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Const.java
*>
*> Author:       Dr. Merten Joost
*>
*> Date-Written: 2003.02.26
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added.
*>******************************************************************************
*/

public class JAPI_Const
{


    //  BOOLEAN
    public static final int J_TRUE                                  = 1;           
    public static final int J_FALSE                                 = 0;           
                                                                                   
                                                                                   
                                                                                   
    //  ALIGNMENT                                                                  
    public static final int J_LEFT                                  = 0;           
    public static final int J_CENTER                                = 1;           
    public static final int J_RIGHT                                 = 2;           
    public static final int J_TOP                                   = 3;           
    public static final int J_BOTTOM                                = 4;           
    public static final int J_TOPLEFT                               = 5;           
    public static final int J_TOPRIGHT                              = 6;           
    public static final int J_BOTTOMLEFT                            = 7;           
    public static final int J_BOTTOMRIGHT                           = 8;           
                                                                                   
                                                                                   
                                                                                   
    //  CURSOR                                                                     
    public static final int J_DEFAULT_CURSOR                        = 0;           
    public static final int J_CROSSHAIR_CURSOR                      = 1;           
    public static final int J_TEXT_CURSOR                           = 2;           
    public static final int J_WAIT_CURSOR                           = 3;           
    public static final int J_SW_RESIZE_CURSOR                      = 4;           
    public static final int J_SE_RESIZE_CURSOR                      = 5;           
    public static final int J_NW_RESIZE_CURSOR                      = 6;           
    public static final int J_NE_RESIZE_CURSOR                      = 7;           
    public static final int J_N_RESIZE_CURSOR                       = 8;           
    public static final int J_S_RESIZE_CURSOR                       = 9;           
    public static final int J_W_RESIZE_CURSOR                       = 10;          
    public static final int J_E_RESIZE_CURSOR                       = 11;          
    public static final int J_HAND_CURSOR                           = 12;          
    public static final int J_MOVE_CURSOR                           = 13;          
                                                                                   
                                                                                   
                                                                                   
    //  ORIENTATION                                                                
    public static final int J_HORIZONTAL                            = 0;           
    public static final int J_VERTICAL                              = 1;           
                                                                                   
                                                                                   
                                                                                   
    //  FONTS                                                                      
    public static final int J_PLAIN                                 = 0;           
    public static final int J_BOLD                                  = 1;               
    public static final int J_ITALIC                                = 2;           
    public static final int J_COURIER                               = 1;           
    public static final int J_HELVETIA                              = 2;           
    public static final int J_TIMES                                 = 3;           
    public static final int J_DIALOGIN                              = 4;           
    public static final int J_DIALOGOUT                             = 5;           
                                                                                   
                                                                                   
                                                                                   
    //  COLORS                                                                     
    public static final int J_BLACK                                 = 0;           
    public static final int J_WHITE                                 = 1;           
    public static final int J_RED                                   = 2;           
    public static final int J_GREEN                                 = 3;           
    public static final int J_BLUE                                  = 4;           
    public static final int J_CYAN                                  = 5;           
    public static final int J_MAGENTA                               = 6;           
    public static final int J_YELLOW                                = 7;           
    public static final int J_ORANGE                                = 8;           
    public static final int J_GREEN_YELLOW                          = 9;           
    public static final int J_GREEN_CYAN                            = 10;          
    public static final int J_BLUE_CYAN                             = 11;          
    public static final int J_BLUE_MAGENTA                          = 12;          
    public static final int J_RED_MAGENTA                           = 13;          
    public static final int J_DARK_GRAY                             = 14;          
    public static final int J_LIGHT_GRAY                            = 15;          
    public static final int J_GRAY                                  = 16;          
                                                                                   
                                                                                   
                                                                                   
    //  BORDERSTYLE                                                                
    public static final int J_NONE                                  = 0;           
    public static final int J_LINEDOWN                              = 1;           
    public static final int J_LINEUP                                = 2;           
    public static final int J_AREADOWN                              = 3;           
    public static final int J_AREAUP                                = 4;           
                                                                                   
                                                                                   
                                                                                   
    //  MOUSELISTENER                                                              
    public static final int J_MOVED                                 = 0;           
    public static final int J_DRAGGED                               = 1;           
    public static final int J_PRESSED                               = 2;           
    public static final int J_RELEASED                              = 3;           
    public static final int J_ENTERERD                              = 4;           
    public static final int J_EXITED                                = 5;           
    public static final int J_DOUBLECLICK                           = 6;           
                                                                                   
                                                                                   
                                                                                   
    //  COMPONENTLISTENER                                                          
                                                                                   
                                                                                   
                                                                                   
    //  J_MOVED                                                                    
    public static final int J_RESIZED                               = 1;           
    public static final int J_HIDDEN                                = 2;           
    public static final int J_SHOWN                                 = 3;           
                                                                                   
                                                                                   
                                                                                   
    //  WINDOWLISTENER                                                     
    public static final int J_ACTIVATED                             = 0;   
    public static final int J_DEACTIVATED                           = 1;   
    public static final int J_OPENED                                = 2;   
    public static final int J_CLOSED                                = 3;   
    public static final int J_ICONIFIED                             = 4;   
    public static final int J_DEICONIFIED                           = 5;   
    public static final int J_CLOSING                               = 6;   



    //  IMAGEFILEFORMAT
    public static final int J_GIF                                   = 0;
    public static final int J_JPG                                   = 1;
    public static final int J_PPM                                   = 2;
    public static final int J_BMP                                   = 3;



    //  LEDFORMAT
    public static final int J_ROUND                                 = 0;
    public static final int J_RECT                                  = 1;



    //  RANDOMMAX                                                                    
    public static final int J_RANDMAX                               = 2147483647;    


}
