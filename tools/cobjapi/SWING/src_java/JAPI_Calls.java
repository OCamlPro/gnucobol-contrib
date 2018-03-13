/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Calls.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Calls.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Calls.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Calls.java
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

public class JAPI_Calls
{

    public static final int JAPI_PORT                               = 5089;            


                                                                                 
    //   JAPI_GRAPHICS                                                           
    public static final int JAPI_GRAPHICS                           = 1024;     
    public static final int JAPI_FOREGROUNDCOLOR                    = 1025;     
    public static final int JAPI_BACKGROUNDCOLOR                    = 1026;     
    public static final int JAPI_SETXOR                             = 1027;     
    public static final int JAPI_DRAWSTRING                         = 1028;     
    public static final int JAPI_CLIPRECT                           = 1029;     
    public static final int JAPI_TRANSLATE                          = 1030;     
    public static final int JAPI_DRAWLINE                           = 1031;     
    public static final int JAPI_DRAWRECT                           = 1032;     
    public static final int JAPI_FILLRECT                           = 1033;     
    public static final int JAPI_POLYLINE                           = 1034;     
    public static final int JAPI_DRAWARC                            = 1035;     
    public static final int JAPI_FILLARC                            = 1036;     
    public static final int JAPI_DRAWOVAL                           = 1037;     
    public static final int JAPI_FILLOVAL                           = 1038;     
    public static final int JAPI_POLYGON                            = 1039;     
    public static final int JAPI_FILLPOLYGON                        = 1040;     
    public static final int JAPI_ROUNDRECT                          = 1041;     
    public static final int JAPI_FILLROUNDRECT                      = 1042;     
    public static final int JAPI_LOADIMAGE                          = 1043;     
    public static final int JAPI_DRAWIMAGE                          = 1044;     
    public static final int JAPI_DRAWSCALEDIMAGE                    = 1045;     
    public static final int JAPI_GETIMAGE                           = 1046;     
    public static final int JAPI_GETSCALEDIMAGE                     = 1047;     
    public static final int JAPI_GETIMAGESOURCE                     = 1048;     
    public static final int JAPI_DRAWIMAGESOURCE                    = 1049;     
                                                                                
                                                                                 
                                                                                 
    //   JAPI_COMMANDS                                                           
    public static final int JAPI_COMMANDS                           = 2048;      
    public static final int JAPI_SELECTTEXT                         = 2049;      
    public static final int JAPI_SETECHOCHAR                        = 2050;      
    public static final int JAPI_PACK                               = 2051;      
    public static final int JAPI_SETHGAP                            = 2052;      
    public static final int JAPI_SETVGAP                            = 2053;      
    public static final int JAPI_SETINSETS                          = 2054;      
    public static final int JAPI_SETALIGN                           = 2055;      
    public static final int JAPI_HIDE                               = 2056;      
    public static final int JAPI_DISPOSE                            = 2057;      
    public static final int JAPI_CURSOR                             = 2058;      
    public static final int JAPI_SETVALUE                           = 2059;      
    public static final int JAPI_SETUNITINC                         = 2060;      
    public static final int JAPI_SETBLOCKINC                        = 2061;      
    public static final int JAPI_SETMIN                             = 2062;      
    public static final int JAPI_SETMAX                             = 2063;      
    public static final int JAPI_SETVISIBLE                         = 2064;      
    public static final int JAPI_SHOWPOPUP                          = 2065;      
    public static final int JAPI_SETFONT                            = 2066;      
    public static final int JAPI_SETFONTNAME                        = 2067;      
    public static final int JAPI_SETFONTSIZE                        = 2068;      
    public static final int JAPI_SETFONTSTYLE                       = 2069;      
    public static final int JAPI_QUIT                               = 2070;      
    public static final int JAPI_KILL                               = 2071;      
    public static final int JAPI_SETSIZE                            = 2072;      
    public static final int JAPI_SHOW                               = 2073;      
    public static final int JAPI_SETSTATE                           = 2074;      
    public static final int JAPI_BORDERPOS                          = 2075;      
    public static final int JAPI_SETPOS                             = 2076;      
    public static final int JAPI_DISABLE                            = 2077;      
    public static final int JAPI_ENABLE                             = 2078;      
    public static final int JAPI_SETFOCUS                           = 2079;      
    public static final int JAPI_SETSHORTCUT                        = 2080;      
    public static final int JAPI_DEBUG                              = 2081;      
    public static final int JAPI_ADDITEM                            = 2082;      
    public static final int JAPI_SELECT                             = 2083;      
    public static final int JAPI_DESELECT                           = 2084;      
    public static final int JAPI_MULTIPLEMODE                       = 2085;      
    public static final int JAPI_INSERT                             = 2086;      
    public static final int JAPI_REMOVE                             = 2087;      
    public static final int JAPI_REMOVEALL                          = 2088;      
    public static final int JAPI_SELECTALL                          = 2089;      
    public static final int JAPI_REPLACETEXT                        = 2090;      
    public static final int JAPI_DELETE                             = 2091;      
    public static final int JAPI_SETCURPOS                          = 2092;      
    public static final int JAPI_INSERTTEXT                         = 2093;      
    public static final int JAPI_SETTEXT                            = 2094;      
    public static final int JAPI_EDITABLE                           = 2095;      
    public static final int JAPI_PRINT                              = 2096;      
    public static final int JAPI_PLAYSOUNDFILE                      = 2097;      
    public static final int JAPI_SOUND                              = 2098;      
    public static final int JAPI_PLAY                               = 2099;      
    public static final int JAPI_ADD                                = 2100;      
    public static final int JAPI_RELEASE                            = 2101;      
    public static final int JAPI_RELEASEALL                         = 2102;      
    public static final int JAPI_FILLFLOWLAYOUT                     = 2103;      
    public static final int JAPI_SETRESIZABLE                       = 2104;      
    public static final int JAPI_SETICON                            = 2105;      
    public static final int JAPI_SETROWS                            = 2106;      
    public static final int JAPI_SETCOLUMNS                         = 2107;      
    public static final int JAPI_SETIMAGE                           = 2108;      
    public static final int JAPI_SETRADIOGROUP                      = 2109;      
    public static final int JAPI_REMOVEITEM                         = 2110;      
    public static final int JAPI_APPENDTEXT                         = 2111;      
    public static final int JAPI_BEEP                               = 2112;      
    public static final int JAPI_SETDANGER                          = 2113;      
                                                                                 
                                                                                 
                                                                                 
    //   JAPI_QUESTIONS                                                          
    public static final int JAPI_QUESTIONS                          = 3072;     
    public static final int JAPI_GETKEYCHAR                         = 3073;     
    public static final int JAPI_GETKEYCODE                         = 3074;     
    public static final int JAPI_HASFOCUS                           = 3075;     
    public static final int JAPI_GETMOUSEPOS                        = 3076;     
    public static final int JAPI_GETMOUSEX                          = 3077;     
    public static final int JAPI_GETMOUSEY                          = 3078;     
    public static final int JAPI_GETMOUSEBUTTON                     = 3079;     
    public static final int JAPI_GETSTATE                           = 3080;     
    public static final int JAPI_GETSELECT                          = 3081;     
    public static final int JAPI_ISSELECT                           = 3082;     
    public static final int JAPI_GETTEXT                            = 3083;     
    public static final int JAPI_GETLENGTH                          = 3084;     
    public static final int JAPI_GETSELSTART                        = 3085;     
    public static final int JAPI_GETSELEND                          = 3086;     
    public static final int JAPI_GETSELTEXT                         = 3087;     
    public static final int JAPI_GETCURPOS                          = 3088;     
    public static final int JAPI_GETWIDTH                           = 3089;     
    public static final int JAPI_GETHEIGHT                          = 3090;     
    public static final int JAPI_GETPOS                             = 3091;     
    public static final int JAPI_GETXPOS                            = 3092;     
    public static final int JAPI_GETYPOS                            = 3093;     
    public static final int JAPI_GETVALUE                           = 3094;     
    public static final int JAPI_VIEWHEIGHT                         = 3095;     
    public static final int JAPI_VIEWWIDTH                          = 3096;     
    public static final int JAPI_SYNC                               = 3097;     
    public static final int JAPI_STRINGWIDTH                        = 3098;     
    public static final int JAPI_FONTHEIGHT                         = 3099;     
    public static final int JAPI_FONTASCENT                         = 3100;     
    public static final int JAPI_GETITEM                            = 3101;     
    public static final int JAPI_GETITEMCOUNT                       = 3102;     
    public static final int JAPI_GETINWIDTH                         = 3103;     
    public static final int JAPI_GETINHEIGHT                        = 3104;     
    public static final int JAPI_GETINSETS                          = 3105;     
    public static final int JAPI_ISRESIZABLE                        = 3106;     
    public static final int JAPI_GETSCREENWIDTH                     = 3107;     
    public static final int JAPI_GETSCREENHEIGHT                    = 3108;     
    public static final int JAPI_GETPARENTID                        = 3109;     
    public static final int JAPI_GETROWS                            = 3110;     
    public static final int JAPI_GETCOLUMNS                         = 3111;     
    public static final int JAPI_GETLAYOUTID                        = 3112;     
    public static final int JAPI_ISPARENT                           = 3113;     
    public static final int JAPI_ISVISIBLE                          = 3114;     
    public static final int JAPI_GETDANGER                          = 3115;     
                                                                                 
                                                                                 
                                                                                 
    //   JAPI_CONSTRUCTORS                                                       
    public static final int JAPI_CONSTRUCTORS                       = 4096;      
    public static final int JAPI_FRAME                              = 4097;      
    public static final int JAPI_CANVAS                             = 4098;      
    public static final int JAPI_BUTTON                             = 4099;      
    public static final int JAPI_MENUBAR                            = 4100;      
    public static final int JAPI_MENU                               = 4101;      
    public static final int JAPI_HELPMENU                           = 4102;      
    public static final int JAPI_MENUITEM                           = 4103;      
    public static final int JAPI_CHECKMENUITEM                      = 4104;      
    public static final int JAPI_SEPERATOR                          = 4105;      
    public static final int JAPI_PANEL                              = 4106;      
    public static final int JAPI_LABEL                              = 4107;      
    public static final int JAPI_CHECKBOX                           = 4108;      
    public static final int JAPI_RADIOGROUP                         = 4109;      
    public static final int JAPI_RADIOBUTTON                        = 4110;      
    public static final int JAPI_LIST                               = 4111;      
    public static final int JAPI_CHOICE                             = 4112;      
    public static final int JAPI_TEXTAREA                           = 4113;      
    public static final int JAPI_TEXTFIELD                          = 4114;      
    public static final int JAPI_FILEDIALOG                         = 4115;      
    public static final int JAPI_DIALOG                             = 4116;      
    public static final int JAPI_WINDOW                             = 4117;      
    public static final int JAPI_POPMENU                            = 4118;      
    public static final int JAPI_SCROLLPANE                         = 4119;      
    public static final int JAPI_VSCROLL                            = 4120;      
    public static final int JAPI_HSCROLL                            = 4121;      
    public static final int JAPI_MESSAGEBOX                         = 4122;      
    public static final int JAPI_ALERTBOX                           = 4123;      
    public static final int JAPI_CHOICEBOX2                         = 4124;      
    public static final int JAPI_CHOICEBOX3                         = 4125;      
    public static final int JAPI_GRAPHICBUTTON                      = 4126;      
    public static final int JAPI_GRAPHICLABEL                       = 4127;      
    public static final int JAPI_BORDERPANEL                        = 4128;      
    public static final int JAPI_RULER                              = 4129;      
    public static final int JAPI_PRINTER                            = 4130;      
    public static final int JAPI_IMAGE                              = 4131;      
    public static final int JAPI_PROGRESSBAR                        = 4132;      
    public static final int JAPI_LED                                = 4133;      
    public static final int JAPI_SEVENSEGMENT                       = 4134;      
    public static final int JAPI_METER                              = 4135;      
                                                                                 
                                                                                 
                                                                                 
    //   JAPI_LISTENERS                                                          
    public static final int JAPI_LISTENERS                          = 5120;      
    public static final int JAPI_KEYLISTENER                        = 5121;      
    public static final int JAPI_FOCUSLISTENER                      = 5122;      
    public static final int JAPI_MOUSELISTENER                      = 5123;      
    public static final int JAPI_COMPONENTLISTENER                  = 5124;      
    public static final int JAPI_WINDOWLISTENER                     = 5125;      



    //   JAPI_LAYOUTMANAGER
    public static final int JAPI_LAYOUTMANAGER                      = 6144;       
    public static final int JAPI_FLOWLAYOUT                         = 6145;       
    public static final int JAPI_GRIDLAYOUT                         = 6146;       
    public static final int JAPI_BORDERLAYOUT                       = 6147;       
    public static final int JAPI_CARDLAYOUT                         = 6148;       
    public static final int JAPI_FIXLAYOUT                          = 6149;       
    public static final int JAPI_NOLAYOUT                           = 6150;       


}
