/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  japi_p.h is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  japi_p.h is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with japi_p.h.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      japi_p.h
*>
*> Purpose:      Include file
*>
*> Author:       Dr. Merten Joost
*>
*> Date-Written: 2003.02.26
*>
*> Tectonics:    ---
*>
*> Usage:        Use in fileselect.c, imageio.c, japilib.c
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added.
*>------------------------------------------------------------------------------
*> 2018.03.10 Laszlo Erdos: 
*>            - Small change for JAPI 2.0.
*>------------------------------------------------------------------------------
*> 2020.05.10 Laszlo Erdos: 
*>            - JAPI_FORMATTEDTEXTFIELD and japi_formattedtextfield added.
*>------------------------------------------------------------------------------
*> 2020.05.21 Laszlo Erdos: 
*>            - JAPI_TABBEDPANE, japi_tabbedpane.
*>            - JAPI_ADDTAB, japi_addtab.
*>------------------------------------------------------------------------------
*> 2020.05.30 Laszlo Erdos: 
*>            - JAPI_ADDTABWITHICON, japi_addtabwithicon.
*>------------------------------------------------------------------------------
*> 2020.10.03 Laszlo Erdos: 
*>            - JAPI_NODE, JAPI_ADDNODE, JAPI_TREE
*>            - JAPI_ENABLEDOUBLECLICK, JAPI_DISABLEDOUBLECLICK
*>            - JAPI_SETTREETEXTSELCOLOR   
*>            - JAPI_SETTREEBGSELCOLOR     
*>            - JAPI_SETTREEBORDERSELCOLOR 
*>            - JAPI_SETTREETEXTNONSELCOLOR
*>            - JAPI_SETTREEBGNONSELCOLOR  
*>
*>            - japi_node, japi_addnode, japi_tree
*>            - japi_enabledoubleclick, japi_disabledoubleclick
*>            - japi_settreetextselnamedcolor
*>            - japi_settreebgselnamedcolor
*>            - japi_settreeborderselnamedcolor
*>            - japi_settreetextnonselnamedcolor
*>            - japi_settreebgnonselnamedcolor
*>            - japi_settreetextselcolor
*>            - japi_settreebgselcolor
*>            - japi_settreeborderselcolor
*>            - japi_settreetextnonselcolor
*>            - japi_settreebgnonselcolor
*>------------------------------------------------------------------------------
*> 2020.12.22 Laszlo Erdos: 
*>            - JAPI_INTERNALFRAME, JAPI_DESKTOPPANE
*>            - japi_internalframe, japi_desktoppane
*>------------------------------------------------------------------------------
*> 2020.12.30 Laszlo Erdos: 
*>            - JAPI_TABLE, JAPI_ADDROW, JAPI_CLEARTABLE, JAPI_SETCOLUMNWIDTHS
*>            - JAPI_SETGRIDCOLOR
*>            - JAPI_SETHEADERCOLOR
*>            - JAPI_SETHEADERCOLORBG
*>
*>            - japi_table, japi_addrow, japi_cleartable, japi_setcolumnwidths
*>            - japi_setgridnamedcolor
*>            - japi_setheadernamedcolor
*>            - japi_setheadernamedcolorbg
*>            - japi_setgridcolor
*>            - japi_setheadercolor
*>            - japi_setheadercolorbg
*>------------------------------------------------------------------------------
*> 2021.03.21 Laszlo Erdos: 
*>            - JAPI_TITLEDCOLORPANEL, JAPI_TITLEDNAMEDCOLORPANEL
*>            - japi_titledcolorpanel, japi_titlednamedcolorpanel
*>------------------------------------------------------------------------------
*> 2021.05.02 Laszlo Erdos: 
*>            - JAPI_INITIALIZE, japi_initialize.
*>------------------------------------------------------------------------------
*> 2022.12.10 Laszlo Erdos: 
*>            - JAPI_TOFRONT, japi_tofront
*>******************************************************************************
*/

#ifdef JAPI_P_H
#else
  #define JAPI_P_H


  #define JAPI_PORT                               5089



  /*   JAPI_GRAPHICS  */
  #define JAPI_GRAPHICS                           1024
  #define JAPI_FOREGROUNDCOLOR                    1025
  #define JAPI_BACKGROUNDCOLOR                    1026
  #define JAPI_SETXOR                             1027
  #define JAPI_DRAWSTRING                         1028
  #define JAPI_CLIPRECT                           1029
  #define JAPI_TRANSLATE                          1030
  #define JAPI_DRAWLINE                           1031
  #define JAPI_DRAWRECT                           1032
  #define JAPI_FILLRECT                           1033
  #define JAPI_POLYLINE                           1034
  #define JAPI_DRAWARC                            1035
  #define JAPI_FILLARC                            1036
  #define JAPI_DRAWOVAL                           1037
  #define JAPI_FILLOVAL                           1038
  #define JAPI_POLYGON                            1039
  #define JAPI_FILLPOLYGON                        1040
  #define JAPI_ROUNDRECT                          1041
  #define JAPI_FILLROUNDRECT                      1042
  #define JAPI_LOADIMAGE                          1043
  #define JAPI_DRAWIMAGE                          1044
  #define JAPI_DRAWSCALEDIMAGE                    1045
  #define JAPI_GETIMAGE                           1046
  #define JAPI_GETSCALEDIMAGE                     1047
  #define JAPI_GETIMAGESOURCE                     1048
  #define JAPI_DRAWIMAGESOURCE                    1049
  #define JAPI_SETTREETEXTSELCOLOR                1050
  #define JAPI_SETTREEBGSELCOLOR                  1051
  #define JAPI_SETTREEBORDERSELCOLOR              1052
  #define JAPI_SETTREETEXTNONSELCOLOR             1053
  #define JAPI_SETTREEBGNONSELCOLOR               1054
  #define JAPI_SETGRIDCOLOR                       1055
  #define JAPI_SETHEADERCOLOR                     1056
  #define JAPI_SETHEADERCOLORBG                   1057  


  /*   JAPI_COMMANDS  */
  #define JAPI_COMMANDS                           2048
  #define JAPI_SELECTTEXT                         2049
  #define JAPI_SETECHOCHAR                        2050
  #define JAPI_PACK                               2051
  #define JAPI_SETHGAP                            2052
  #define JAPI_SETVGAP                            2053
  #define JAPI_SETINSETS                          2054
  #define JAPI_SETALIGN                           2055
  #define JAPI_HIDE                               2056
  #define JAPI_DISPOSE                            2057
  #define JAPI_CURSOR                             2058
  #define JAPI_SETVALUE                           2059
  #define JAPI_SETUNITINC                         2060
  #define JAPI_SETBLOCKINC                        2061
  #define JAPI_SETMIN                             2062
  #define JAPI_SETMAX                             2063
  #define JAPI_SETVISIBLE                         2064
  #define JAPI_SHOWPOPUP                          2065
  #define JAPI_SETFONT                            2066
  #define JAPI_SETFONTNAME                        2067
  #define JAPI_SETFONTSIZE                        2068
  #define JAPI_SETFONTSTYLE                       2069
  #define JAPI_QUIT                               2070
  #define JAPI_KILL                               2071
  #define JAPI_SETSIZE                            2072
  #define JAPI_SHOW                               2073
  #define JAPI_SETSTATE                           2074
  #define JAPI_BORDERPOS                          2075
  #define JAPI_SETPOS                             2076
  #define JAPI_DISABLE                            2077
  #define JAPI_ENABLE                             2078
  #define JAPI_SETFOCUS                           2079
  #define JAPI_SETSHORTCUT                        2080
  #define JAPI_DEBUG                              2081
  #define JAPI_ADDITEM                            2082
  #define JAPI_SELECT                             2083
  #define JAPI_DESELECT                           2084
  #define JAPI_MULTIPLEMODE                       2085
  #define JAPI_INSERT                             2086
  #define JAPI_REMOVE                             2087
  #define JAPI_REMOVEALL                          2088
  #define JAPI_SELECTALL                          2089
  #define JAPI_REPLACETEXT                        2090
  #define JAPI_DELETE                             2091
  #define JAPI_SETCURPOS                          2092
  #define JAPI_INSERTTEXT                         2093
  #define JAPI_SETTEXT                            2094
  #define JAPI_EDITABLE                           2095
  #define JAPI_PRINT                              2096
  #define JAPI_PLAYSOUNDFILE                      2097
  #define JAPI_SOUND                              2098
  #define JAPI_PLAY                               2099
  #define JAPI_ADD                                2100
  #define JAPI_RELEASE                            2101
  #define JAPI_RELEASEALL                         2102
  #define JAPI_FILLFLOWLAYOUT                     2103
  #define JAPI_SETRESIZABLE                       2104
  #define JAPI_SETICON                            2105
  #define JAPI_SETROWS                            2106
  #define JAPI_SETCOLUMNS                         2107
  #define JAPI_SETIMAGE                           2108
  #define JAPI_SETRADIOGROUP                      2109
  #define JAPI_REMOVEITEM                         2110
  #define JAPI_APPENDTEXT                         2111
  #define JAPI_BEEP                               2112
  #define JAPI_SETDANGER                          2113
  #define JAPI_SETSPLITPANELEFT                   2114
  #define JAPI_SETSPLITPANERIGHT                  2115
  #define JAPI_ADDTAB                             2116
  #define JAPI_ADDTABWITHICON                     2117
  #define JAPI_ADDNODE                            2118
  #define JAPI_ENABLEDOUBLECLICK                  2119
  #define JAPI_DISABLEDOUBLECLICK                 2120
  #define JAPI_ADDROW                             2121
  #define JAPI_CLEARTABLE                         2122
  #define JAPI_SETCOLUMNWIDTHS                    2123
  #define JAPI_INITIALIZE                         2124
  #define JAPI_TOFRONT                            2125


  /*   JAPI_QUESTIONS  */
  #define JAPI_QUESTIONS                          3072
  #define JAPI_GETKEYCHAR                         3073
  #define JAPI_GETKEYCODE                         3074
  #define JAPI_HASFOCUS                           3075
  #define JAPI_GETMOUSEPOS                        3076
  #define JAPI_GETMOUSEX                          3077
  #define JAPI_GETMOUSEY                          3078
  #define JAPI_GETMOUSEBUTTON                     3079
  #define JAPI_GETSTATE                           3080
  #define JAPI_GETSELECT                          3081
  #define JAPI_ISSELECT                           3082
  #define JAPI_GETTEXT                            3083
  #define JAPI_GETLENGTH                          3084
  #define JAPI_GETSELSTART                        3085
  #define JAPI_GETSELEND                          3086
  #define JAPI_GETSELTEXT                         3087
  #define JAPI_GETCURPOS                          3088
  #define JAPI_GETWIDTH                           3089
  #define JAPI_GETHEIGHT                          3090
  #define JAPI_GETPOS                             3091
  #define JAPI_GETXPOS                            3092
  #define JAPI_GETYPOS                            3093
  #define JAPI_GETVALUE                           3094
  #define JAPI_VIEWHEIGHT                         3095
  #define JAPI_VIEWWIDTH                          3096
  #define JAPI_SYNC                               3097
  #define JAPI_STRINGWIDTH                        3098
  #define JAPI_FONTHEIGHT                         3099
  #define JAPI_FONTASCENT                         3100
  #define JAPI_GETITEM                            3101
  #define JAPI_GETITEMCOUNT                       3102
  #define JAPI_GETINWIDTH                         3103
  #define JAPI_GETINHEIGHT                        3104
  #define JAPI_GETINSETS                          3105
  #define JAPI_ISRESIZABLE                        3106
  #define JAPI_GETSCREENWIDTH                     3107
  #define JAPI_GETSCREENHEIGHT                    3108
  #define JAPI_GETPARENTID                        3109
  #define JAPI_GETROWS                            3110
  #define JAPI_GETCOLUMNS                         3111
  #define JAPI_GETLAYOUTID                        3112
  #define JAPI_ISPARENT                           3113
  #define JAPI_ISVISIBLE                          3114
  #define JAPI_GETDANGER                          3115



  /*   JAPI_CONSTRUCTORS  */
  #define JAPI_CONSTRUCTORS                       4096
  #define JAPI_FRAME                              4097
  #define JAPI_CANVAS                             4098
  #define JAPI_BUTTON                             4099
  #define JAPI_MENUBAR                            4100
  #define JAPI_MENU                               4101
  #define JAPI_HELPMENU                           4102
  #define JAPI_MENUITEM                           4103
  #define JAPI_CHECKMENUITEM                      4104
  #define JAPI_SEPARATOR                          4105
  #define JAPI_PANEL                              4106
  #define JAPI_LABEL                              4107
  #define JAPI_CHECKBOX                           4108
  #define JAPI_RADIOGROUP                         4109
  #define JAPI_RADIOBUTTON                        4110
  #define JAPI_LIST                               4111
  #define JAPI_CHOICE                             4112
  #define JAPI_TEXTAREA                           4113
  #define JAPI_TEXTFIELD                          4114
  #define JAPI_FILEDIALOG                         4115
  #define JAPI_DIALOG                             4116
  #define JAPI_WINDOW                             4117
  #define JAPI_POPMENU                            4118
  #define JAPI_SCROLLPANE                         4119
  #define JAPI_VSCROLL                            4120
  #define JAPI_HSCROLL                            4121
  #define JAPI_MESSAGEBOX                         4122
  #define JAPI_ALERTBOX                           4123
  #define JAPI_CHOICEBOX2                         4124
  #define JAPI_CHOICEBOX3                         4125
  #define JAPI_GRAPHICBUTTON                      4126
  #define JAPI_GRAPHICLABEL                       4127
  #define JAPI_BORDERPANEL                        4128
  #define JAPI_RULER                              4129
  #define JAPI_PRINTER                            4130
  #define JAPI_IMAGE                              4131
  #define JAPI_PROGRESSBAR                        4132
  #define JAPI_LED                                4133
  #define JAPI_SEVENSEGMENT                       4134
  #define JAPI_METER                              4135
  #define JAPI_SPLITPANE                          4136
  #define JAPI_FORMATTEDTEXTFIELD                 4137
  #define JAPI_TABBEDPANE                         4138
  #define JAPI_NODE                               4139
  #define JAPI_TREE                               4140
  #define JAPI_INTERNALFRAME                      4141
  #define JAPI_DESKTOPPANE                        4142
  #define JAPI_TABLE                              4143
  #define JAPI_TITLEDCOLORPANEL                   4144



  /*   JAPI_LISTENERS  */
  #define JAPI_LISTENERS                          5120
  #define JAPI_KEYLISTENER                        5121
  #define JAPI_FOCUSLISTENER                      5122
  #define JAPI_MOUSELISTENER                      5123
  #define JAPI_COMPONENTLISTENER                  5124
  #define JAPI_WINDOWLISTENER                     5125



  /*   JAPI_LAYOUTMANAGER  */
  #define JAPI_LAYOUTMANAGER                      6144
  #define JAPI_FLOWLAYOUT                         6145
  #define JAPI_GRIDLAYOUT                         6146
  #define JAPI_BORDERLAYOUT                       6147
  #define JAPI_CARDLAYOUT                         6148
  #define JAPI_FIXLAYOUT                          6149
  #define JAPI_NOLAYOUT                           6150



  extern  int   japi_start (  );
  extern  int   japi_connect ( char*  );
  extern  int   japi_splitpane ( int , int , int  );
  extern  void  japi_setsplitpaneleft ( int , int  );
  extern  void  japi_setsplitpaneright ( int , int  );
  extern  int   japi_desktoppane ( int  );
  extern  void  japi_setport ( int  );
  extern  void  japi_setdebug ( int  );
  extern  int   japi_frame ( char*  );
  extern  int   japi_button ( int , char*  );
  extern  int   japi_graphicbutton ( int , char*  );
  extern  int   japi_checkbox ( int , char*  );
  extern  int   japi_label ( int , char*  );
  extern  int   japi_graphiclabel ( int , char*  );
  extern  int   japi_canvas ( int , int , int  );
  extern  int   japi_panel ( int  );
  extern  int   j_titledcolorpanel( int , char* , int , int , int , int , int  );
  extern  int   j_titlednamedcolorpanel( int , char* , int , int , int  );
  extern  int   japi_tabbedpane ( int  );
  extern  int   japi_addtab ( int , char*  );
  extern  int   japi_addtabwithicon ( int , char* , char*  );
  extern  int   japi_node ( char*  );
  extern  void  japi_addnode ( int , int  );
  extern  int   japi_tree ( int , int  );
  extern  void  japi_enabledoubleclick ( int  );
  extern  void  japi_disabledoubleclick ( int  );
  extern  int   japi_internalframe( int , char* , int , int , int , int  );
  extern  int   japi_table( int , char*  );
  extern  void  japi_addrow( int , char*  );
  extern  void  japi_cleartable( int  );
  extern  void  japi_setcolumnwidths( int , char*  );
  extern  int   japi_borderpanel ( int , int  );
  extern  int   japi_radiogroup ( int  );
  extern  int   japi_radiobutton ( int , char*  );
  extern  int   japi_list ( int , int  );
  extern  int   japi_choice ( int  );
  extern  int   japi_dialog ( int , char*  );
  extern  int   japi_window ( int  );
  extern  int   japi_popupmenu ( int , char*  );
  extern  int   japi_scrollpane ( int  );
  extern  int   japi_hscrollbar ( int  );
  extern  int   japi_vscrollbar ( int  );
  extern  int   japi_line ( int , int , int , int  );
  extern  int   japi_printer ( int  );
  extern  int   japi_image ( int , int  );
  extern  char* japi_filedialog ( int , char* , char* , char*  );
  extern  char* japi_fileselect ( int , char* , char* , char*  );
  extern  int   japi_messagebox ( int , char* , char*  );
  extern  int   japi_alertbox ( int , char* , char* , char*  );
  extern  int   japi_choicebox2 ( int , char* , char* , char* , char*  );
  extern  int   japi_choicebox3 ( int , char* , char* , char* , char* , char*  );
  extern  int   japi_progressbar ( int , int  );
  extern  int   japi_led ( int , int , int  );
  extern  int   japi_sevensegment ( int , int  );
  extern  int   japi_meter ( int , char*  );
  extern  void  japi_additem ( int , char*  );
  extern  int   japi_textfield ( int , int  );
  extern  int   japi_formattedtextfield ( int ,  char* , char* , int  );
  extern  int   japi_textarea ( int , int , int  );
  extern  int   japi_menubar ( int  );
  extern  int   japi_menu ( int , char*  );
  extern  int   japi_helpmenu ( int , char*  );
  extern  int   japi_menuitem ( int , char*  );
  extern  int   japi_checkmenuitem ( int , char*  );
  extern  void  japi_pack ( int  );
  extern  void  japi_print ( int  );
  extern  void  japi_playsoundfile ( char*  );
  extern  void  japi_play ( int  );
  extern  int   japi_sound ( char*  );
  extern  void  japi_setfont ( int , int , int , int  );
  extern  void  japi_setfontname ( int , int  );
  extern  void  japi_setfontsize ( int , int  );
  extern  void  japi_setfontstyle ( int , int  );
  extern  void  japi_separator ( int  );
  extern  void  japi_disable ( int  );
  extern  void  japi_enable ( int  );
  extern  int   japi_getstate ( int  );
  extern  int   japi_getrows ( int  );
  extern  int   japi_getcolumns ( int  );
  extern  int   japi_getselect ( int  );
  extern  int   japi_isselect ( int , int  );
  extern  int   japi_isvisible ( int  );
  extern  int   japi_isparent ( int , int  );
  extern  int   japi_isresizable ( int  );
  extern  void  japi_select ( int , int  );
  extern  void  japi_deselect ( int , int  );
  extern  void  japi_multiplemode ( int , int  );
  extern  void  japi_insert ( int , int , char*  );
  extern  void  japi_remove ( int , int  );
  extern  void  japi_removeitem ( int , char*  );
  extern  void  japi_removeall ( int  );
  extern  void  japi_setstate ( int , int  );
  extern  void  japi_setrows ( int , int  );
  extern  void  japi_setcolumns ( int , int  );
  extern  void  japi_seticon ( int , int  );
  extern  void  japi_setimage ( int , int  );
  extern  void  japi_setvalue ( int , int  );
  extern  void  japi_setradiogroup ( int , int  );
  extern  void  japi_setunitinc ( int , int  );
  extern  void  japi_setblockinc ( int , int  );
  extern  void  japi_setmin ( int , int  );
  extern  void  japi_setmax ( int , int  );
  extern  void  japi_setdanger ( int , int  );
  extern  void  japi_setslidesize ( int , int  );
  extern  void  japi_setcursor ( int , int  );
  extern  void  japi_setresizable ( int , int  );
  extern  int   japi_getlength ( int  );
  extern  int   japi_getvalue ( int  );
  extern  int   japi_getdanger ( int  );
  extern  int   japi_getscreenheight (  );
  extern  int   japi_getscreenwidth (  );
  extern  int   japi_getheight ( int  );
  extern  int   japi_getwidth ( int  );
  extern  int   japi_getinsets ( int , int  );
  extern  int   japi_getlayoutid ( int  );
  extern  int   japi_getinheight ( int  );
  extern  int   japi_getinwidth ( int  );
  extern  char* japi_gettext ( int , char*  );
  extern  char* japi_getitem ( int , int , char*  );
  extern  int   japi_getitemcount ( int  );
  extern  void  japi_delete ( int , int , int  );
  extern  void  japi_replacetext ( int , char* , int , int  );
  extern  void  japi_appendtext ( int , char*  );
  extern  void  japi_inserttext ( int , char* , int  );
  extern  void  japi_settext ( int , char*  );
  extern  void  japi_initialize ( int  );
  extern  void  japi_selectall ( int  );
  extern  void  japi_selecttext ( int , int , int  );
  extern  int   japi_getselstart ( int  );
  extern  int   japi_getselend ( int  );
  extern  char* japi_getseltext ( int , char*  );
  extern  int   japi_getcurpos ( int  );
  extern  void  japi_setcurpos ( int , int  );
  extern  void  japi_setechochar ( int , char  );
  extern  void  japi_seteditable ( int , int  );
  extern  void  japi_setshortcut ( int , char  );
  extern  void  japi_quit (  );
  extern  void  japi_kill (  );
  extern  void  japi_setsize ( int , int , int  );
  extern  int   japi_getaction (  );
  extern  int   japi_nextaction (  );
  extern  void  japi_show ( int  );
  extern  void  japi_tofront ( int  );
  extern  void  japi_showpopup ( int , int , int  );
  extern  void  japi_add ( int , int  );
  extern  void  japi_release ( int  );
  extern  void  japi_releaseall ( int  );
  extern  void  japi_hide ( int  );
  extern  void  japi_dispose ( int  );
  extern  void  japi_setpos ( int , int , int  );
  extern  int   japi_getviewportheight ( int  );
  extern  int   japi_getviewportwidth ( int  );
  extern  int   japi_getxpos ( int  );
  extern  int   japi_getypos ( int  );
  extern  void  japi_getpos ( int , int* , int*  );
  extern  int   japi_getparentid ( int  );
  extern  void  japi_setfocus ( int  );
  extern  int   japi_hasfocus ( int  );
  extern  int   japi_getstringwidth ( int , char*  );
  extern  int   japi_getfontheight ( int  );
  extern  int   japi_getfontascent ( int  );
  extern  int   japi_keylistener ( int  );
  extern  int   japi_getkeycode ( int  );
  extern  int   japi_getkeychar ( int  );
  extern  int   japi_mouselistener ( int , int  );
  extern  int   japi_getmousex ( int  );
  extern  int   japi_getmousey ( int  );
  extern  void  japi_getmousepos ( int , int* , int*  );
  extern  int   japi_getmousebutton ( int  );
  extern  int   japi_focuslistener ( int  );
  extern  int   japi_componentlistener ( int , int  );
  extern  int   japi_windowlistener ( int , int  );
  extern  void  japi_setflowlayout ( int , int  );
  extern  void  japi_setborderlayout ( int  );
  extern  void  japi_setgridlayout ( int , int , int  );
  extern  void  japi_setfixlayout ( int  );
  extern  void  japi_setnolayout ( int  );
  extern  void  japi_setborderpos ( int , int  );
  extern  void  japi_sethgap ( int , int  );
  extern  void  japi_setvgap ( int , int  );
  extern  void  japi_setinsets ( int , int , int , int , int  );
  extern  void  japi_setalign ( int , int  );
  extern  void  japi_setflowfill ( int , int  );
  extern  void  japi_translate ( int , int , int  );
  extern  void  japi_cliprect ( int , int , int , int , int  );
  extern  void  japi_drawrect ( int , int , int , int , int  );
  extern  void  japi_fillrect ( int , int , int , int , int  );
  extern  void  japi_drawroundrect ( int , int , int , int , int , int , int  );
  extern  void  japi_fillroundrect ( int , int , int , int , int , int , int  );
  extern  void  japi_drawoval ( int , int , int , int , int  );
  extern  void  japi_filloval ( int , int , int , int , int  );
  extern  void  japi_drawcircle ( int , int , int , int  );
  extern  void  japi_fillcircle ( int , int , int , int  );
  extern  void  japi_drawarc ( int , int , int , int , int , int , int  );
  extern  void  japi_fillarc ( int , int , int , int , int , int , int  );
  extern  void  japi_drawline ( int , int , int , int , int  );
  extern  void  japi_drawpolyline ( int , int , int* , int*  );
  extern  void  japi_drawpolygon ( int , int , int* , int*  );
  extern  void  japi_fillpolygon ( int , int , int* , int*  );
  extern  void  japi_drawpixel ( int , int , int  );
  extern  void  japi_drawstring ( int , int , int , char*  );
  extern  void  japi_setxor ( int , int  );
  extern  int   japi_getimage ( int  );
  extern  void  japi_getimagesource ( int , int , int , int , int , int* , int* , int*  );
  extern  void  japi_drawimagesource ( int , int , int , int , int , int* , int* , int*  );
  extern  int   japi_getscaledimage ( int , int , int , int , int , int , int  );
  extern  void  japi_drawimage ( int , int , int , int  );
  extern  void  japi_drawscaledimage ( int , int , int , int , int , int , int , int , int , int  );
  extern  void  japi_setcolor ( int , int , int , int  );
  extern  void  japi_setcolorbg ( int , int , int , int  );
  extern  void  japi_setnamedcolor ( int , int  );
  extern  void  japi_setnamedcolorbg ( int , int  );
  extern  void  japi_settreetextselnamedcolor ( int , int  );
  extern  void  japi_settreebgselnamedcolor ( int , int  );
  extern  void  japi_settreeborderselnamedcolor ( int , int  );
  extern  void  japi_settreetextnonselnamedcolor ( int , int  );
  extern  void  japi_settreebgnonselnamedcolor ( int , int  );
  extern  void  japi_settreetextselcolor ( int , int , int , int  );
  extern  void  japi_settreebgselcolor ( int , int , int , int  );
  extern  void  japi_settreeborderselcolor ( int , int , int , int  );
  extern  void  japi_settreetextnonselcolor ( int , int , int , int  );
  extern  void  japi_settreebgnonselcolor ( int , int , int , int  );
  extern  void  japi_setgridnamedcolor ( int , int  );
  extern  void  japi_setheadernamedcolor ( int , int  );
  extern  void  japi_setheadernamedcolorbg ( int , int  );
  extern  void  japi_setgridcolor ( int , int , int , int  );
  extern  void  japi_setheadercolor ( int , int , int , int  );
  extern  void  japi_setheadercolorbg ( int , int , int , int  );
  extern  int   japi_loadimage ( char*  );
  extern  int   japi_saveimage ( int , char* , int  );
  extern  void  japi_sync (  );
  extern  void  japi_beep (  );
  extern  int   japi_random (  );
  extern  void  japi_sleep ( int  );


#endif
