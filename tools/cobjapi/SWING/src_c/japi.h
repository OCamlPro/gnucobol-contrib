/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  japi.h is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  japi.h is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with japi.h.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      japi.h
*>
*> Purpose:      Include file
*>
*> Author:       Dr. Merten Joost
*>
*> Date-Written: 2003.02.26
*>
*> Tectonics:    ---
*>
*> Usage:        Use in fileselect.c, japilib.c
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
*>            - j_formattedtextfield added.
*>------------------------------------------------------------------------------
*> 2020.05.21 Laszlo Erdos: 
*>            - j_tabbedpane, j_addtab.
*>------------------------------------------------------------------------------
*> 2020.05.30 Laszlo Erdos: 
*>            - j_addtabwithicon.
*>------------------------------------------------------------------------------
*> 2020.10.03 Laszlo Erdos: 
*>            - j_node, j_addnode, j_tree
*>            - j_enabledoubleclick, j_disabledoubleclick
*>            - j_settreetextselnamedcolor
*>            - j_settreebgselnamedcolor
*>            - j_settreeborderselnamedcolor
*>            - j_settreetextnonselnamedcolor
*>            - j_settreebgnonselnamedcolor
*>            - j_settreetextselcolor
*>            - j_settreebgselcolor
*>            - j_settreeborderselcolor
*>            - j_settreetextnonselcolor
*>            - j_settreebgnonselcolor
*>------------------------------------------------------------------------------
*> 2020.12.22 Laszlo Erdos: 
*>            - j_internalframe, j_desktoppane
*>------------------------------------------------------------------------------
*> 2020.12.30 Laszlo Erdos: 
*>            - j_table, j_addrow, j_cleartable, j_setcolumnwidths
*>            - j_setgridnamedcolor
*>            - j_setheadernamedcolor
*>            - j_setheadernamedcolorbg
*>            - j_setgridcolor
*>            - j_setheadercolor
*>            - j_setheadercolorbg
*>------------------------------------------------------------------------------
*> 2021.03.21 Laszlo Erdos: 
*>            - j_titledcolorpanel
*>            - j_titlednamedcolorpanel
*>------------------------------------------------------------------------------
*> 2021.05.02 Laszlo Erdos: 
*>            - j_initialize
*>------------------------------------------------------------------------------
*> 2021.12.10 Laszlo Erdos: 
*>            - j_tofront
*>******************************************************************************
*/

#ifndef JAPI_H

    #define JAPI_H




    /*  APPLICATION_NAME   */



    /*  ERROR   */
    #define J_ERROR                                 -1



    /*  BOOLEAN   */
    #define J_TRUE                                  1
    #define J_FALSE                                 0



    /*  ALIGNMENT   */
    #define J_LEFT                                  0
    #define J_CENTER                                1
    #define J_RIGHT                                 2
    #define J_TOP                                   3
    #define J_BOTTOM                                4
    #define J_TOPLEFT                               5
    #define J_TOPRIGHT                              6
    #define J_BOTTOMLEFT                            7
    #define J_BOTTOMRIGHT                           8



    /*  CURSOR   */
    #define J_DEFAULT_CURSOR                        0
    #define J_CROSSHAIR_CURSOR                      1
    #define J_TEXT_CURSOR                           2
    #define J_WAIT_CURSOR                           3
    #define J_SW_RESIZE_CURSOR                      4
    #define J_SE_RESIZE_CURSOR                      5
    #define J_NW_RESIZE_CURSOR                      6
    #define J_NE_RESIZE_CURSOR                      7
    #define J_N_RESIZE_CURSOR                       8
    #define J_S_RESIZE_CURSOR                       9
    #define J_W_RESIZE_CURSOR                       10
    #define J_E_RESIZE_CURSOR                       11
    #define J_HAND_CURSOR                           12
    #define J_MOVE_CURSOR                           13



    /*  ORIENTATION   */
    #define J_HORIZONTAL                            0
    #define J_VERTICAL                              1



    /*  FONTS   */
    #define J_PLAIN                                 0
    #define J_BOLD                                  1
    #define J_ITALIC                                2
    #define J_COURIER                               1
    #define J_HELVETIA                              2
    #define J_TIMES                                 3
    #define J_DIALOGIN                              4
    #define J_DIALOGOUT                             5



    /*  COLORS   */
    #define J_BLACK                                 0
    #define J_WHITE                                 1
    #define J_RED                                   2
    #define J_GREEN                                 3
    #define J_BLUE                                  4
    #define J_CYAN                                  5
    #define J_MAGENTA                               6
    #define J_YELLOW                                7
    #define J_ORANGE                                8
    #define J_GREEN_YELLOW                          9
    #define J_GREEN_CYAN                            10
    #define J_BLUE_CYAN                             11
    #define J_BLUE_MAGENTA                          12
    #define J_RED_MAGENTA                           13
    #define J_DARK_GRAY                             14
    #define J_LIGHT_GRAY                            15
    #define J_GRAY                                  16



    /*  BORDERSTYLE   */
    #define J_NONE                                  0
    #define J_LINEDOWN                              1
    #define J_LINEUP                                2
    #define J_AREADOWN                              3
    #define J_AREAUP                                4



    /*  MOUSELISTENER   */
    #define J_MOVED                                 0
    #define J_DRAGGED                               1
    #define J_PRESSED                               2
    #define J_RELEASED                              3
    #define J_ENTERERD                              4
    #define J_EXITED                                5
    #define J_DOUBLECLICK                           6



    /*  COMPONENTLISTENER   */



    /*  J_MOVED   */
    #define J_RESIZED                               1
    #define J_HIDDEN                                2
    #define J_SHOWN                                 3



    /*  WINDOWLISTENER   */
    #define J_ACTIVATED                             0
    #define J_DEACTIVATED                           1
    #define J_OPENED                                2
    #define J_CLOSED                                3
    #define J_ICONIFIED                             4
    #define J_DEICONIFIED                           5
    #define J_CLOSING                               6



    /*  IMAGEFILEFORMAT   */
    #define J_GIF                                   0
    #define J_JPG                                   1
    #define J_PPM                                   2
    #define J_BMP                                   3



    /*  LEDFORMAT   */
    #define J_ROUND                                 0
    #define J_RECT                                  1



    /*  RANDOMMAX   */
    #define J_RANDMAX                               2147483647




    extern  int   j_start ( void  );
    extern  int   j_connect ( char*  );
    extern  int   j_splitpane ( int , int , int  );
    extern  void  j_setsplitpaneleft ( int , int  );
    extern  void  j_setsplitpaneright ( int , int  );
    extern  int   j_desktoppane ( int  );
    extern  void  j_setport ( int  );
    extern  void  j_setdebug ( int  );
    extern  int   j_frame ( char*  );
    extern  int   j_button ( int , char*  );
    extern  int   j_graphicbutton ( int , char*  );
    extern  int   j_checkbox ( int , char*  );
    extern  int   j_label ( int , char*  );
    extern  int   j_graphiclabel ( int , char*  );
    extern  int   j_canvas ( int , int , int  );
    extern  int   j_panel ( int  );
    extern  int   j_titledcolorpanel( int , char* , int , int , int , int , int  );
    extern  int   j_titlednamedcolorpanel( int , char* , int , int , int  );
    extern  int   j_tabbedpane ( int  );
    extern  int   j_addtab ( int , char*  );
    extern  int   j_addtabwithicon ( int , char* , char*  );
    extern  int   j_node ( char*  );
    extern  void  j_addnode ( int , int  );
    extern  int   j_tree ( int , int  );
    extern  void  j_enabledoubleclick ( int  );
    extern  void  j_disabledoubleclick ( int  );
    extern  int   j_internalframe( int , char* , int , int , int , int  );
    extern  int   j_table( int , char*  );
    extern  void  j_addrow( int , char*  );
    extern  void  j_cleartable( int  );
    extern  void  j_setcolumnwidths( int , char*  );
    extern  int   j_borderpanel ( int , int  );
    extern  int   j_radiogroup ( int  );
    extern  int   j_radiobutton ( int , char*  );
    extern  int   j_list ( int , int  );
    extern  int   j_choice ( int  );
    extern  int   j_dialog ( int , char*  );
    extern  int   j_window ( int  );
    extern  int   j_popupmenu ( int , char*  );
    extern  int   j_scrollpane ( int  );
    extern  int   j_hscrollbar ( int  );
    extern  int   j_vscrollbar ( int  );
    extern  int   j_line ( int , int , int , int  );
    extern  int   j_printer ( int  );
    extern  int   j_image ( int , int  );
    extern  char* j_filedialog ( int , char* , char* , char*  );
    extern  char* j_fileselect ( int , char* , char* , char*  );
    extern  int   j_messagebox ( int , char* , char*  );
    extern  int   j_alertbox ( int , char* , char* , char*  );
    extern  int   j_choicebox2 ( int , char* , char* , char* , char*  );
    extern  int   j_choicebox3 ( int , char* , char* , char* , char* , char*  );
    extern  int   j_progressbar ( int , int  );
    extern  int   j_led ( int , int , int  );
    extern  int   j_sevensegment ( int , int  );
    extern  int   j_meter ( int , char*  );
    extern  void  j_additem ( int , char*  );
    extern  int   j_textfield ( int , int  );
    extern  int   j_formattedtextfield ( int , char* , char* , int  );
    extern  int   j_textarea ( int , int , int  );
    extern  int   j_menubar ( int  );
    extern  int   j_menu ( int , char*  );
    extern  int   j_helpmenu ( int , char*  );
    extern  int   j_menuitem ( int , char*  );
    extern  int   j_checkmenuitem ( int , char*  );
    extern  void  j_pack ( int  );
    extern  void  j_print ( int  );
    extern  void  j_playsoundfile ( char*  );
    extern  void  j_play ( int  );
    extern  int   j_sound ( char*  );
    extern  void  j_setfont ( int , int , int , int  );
    extern  void  j_setfontname ( int , int  );
    extern  void  j_setfontsize ( int , int  );
    extern  void  j_setfontstyle ( int , int  );
    extern  void  j_separator ( int  );
    extern  void  j_disable ( int  );
    extern  void  j_enable ( int  );
    extern  int   j_getstate ( int  );
    extern  int   j_getrows ( int  );
    extern  int   j_getcolumns ( int  );
    extern  int   j_getselect ( int  );
    extern  int   j_isselect ( int , int  );
    extern  int   j_isvisible ( int  );
    extern  int   j_isparent ( int , int  );
    extern  int   j_isresizable ( int  );
    extern  void  j_select ( int , int  );
    extern  void  j_deselect ( int , int  );
    extern  void  j_multiplemode ( int , int  );
    extern  void  j_insert ( int , int , char*  );
    extern  void  j_remove ( int , int  );
    extern  void  j_removeitem ( int , char*  );
    extern  void  j_removeall ( int  );
    extern  void  j_setstate ( int , int  );
    extern  void  j_setrows ( int , int  );
    extern  void  j_setcolumns ( int , int  );
    extern  void  j_seticon ( int , int  );
    extern  void  j_setimage ( int , int  );
    extern  void  j_setvalue ( int , int  );
    extern  void  j_setradiogroup ( int , int  );
    extern  void  j_setunitinc ( int , int  );
    extern  void  j_setblockinc ( int , int  );
    extern  void  j_setmin ( int , int  );
    extern  void  j_setmax ( int , int  );
    extern  void  j_setdanger ( int , int  );
    extern  void  j_setslidesize ( int , int  );
    extern  void  j_setcursor ( int , int  );
    extern  void  j_setresizable ( int , int  );
    extern  int   j_getlength ( int  );
    extern  int   j_getvalue ( int  );
    extern  int   j_getdanger ( int  );
    extern  int   j_getscreenheight ( void  );
    extern  int   j_getscreenwidth ( void  );
    extern  int   j_getheight ( int  );
    extern  int   j_getwidth ( int  );
    extern  int   j_getinsets ( int , int  );
    extern  int   j_getlayoutid ( int  );
    extern  int   j_getinheight ( int  );
    extern  int   j_getinwidth ( int  );
    extern  char* j_gettext ( int , char*  );
    extern  char* j_getitem ( int , int , char*  );
    extern  int   j_getitemcount ( int  );
    extern  void  j_delete ( int , int , int  );
    extern  void  j_replacetext ( int , char* , int , int  );
    extern  void  j_appendtext ( int , char*  );
    extern  void  j_inserttext ( int , char* , int  );
    extern  void  j_settext ( int , char*  );
    extern  void  j_initialize ( int  );
    extern  void  j_selectall ( int  );
    extern  void  j_selecttext ( int , int , int  );
    extern  int   j_getselstart ( int  );
    extern  int   j_getselend ( int  );
    extern  char* j_getseltext ( int , char*  );
    extern  int   j_getcurpos ( int  );
    extern  void  j_setcurpos ( int , int  );
    extern  void  j_setechochar ( int , char  );
    extern  void  j_seteditable ( int , int  );
    extern  void  j_setshortcut ( int , char  );
    extern  void  j_quit ( void  );
    extern  void  j_kill ( void  );
    extern  void  j_setsize ( int , int , int  );
    extern  int   j_getaction ( void  );
    extern  int   j_nextaction ( void  );
    extern  void  j_show ( int  );
    extern  void  j_tofront ( int  );
    extern  void  j_showpopup ( int , int , int  );
    extern  void  j_add ( int , int  );
    extern  void  j_release ( int  );
    extern  void  j_releaseall ( int  );
    extern  void  j_hide ( int  );
    extern  void  j_dispose ( int  );
    extern  void  j_setpos ( int , int , int  );
    extern  int   j_getviewportheight ( int  );
    extern  int   j_getviewportwidth ( int  );
    extern  int   j_getxpos ( int  );
    extern  int   j_getypos ( int  );
    extern  void  j_getpos ( int , int* , int*  );
    extern  int   j_getparentid ( int  );
    extern  void  j_setfocus ( int  );
    extern  int   j_hasfocus ( int  );
    extern  int   j_getstringwidth ( int , char*  );
    extern  int   j_getfontheight ( int  );
    extern  int   j_getfontascent ( int  );
    extern  int   j_keylistener ( int  );
    extern  int   j_getkeycode ( int  );
    extern  int   j_getkeychar ( int  );
    extern  int   j_mouselistener ( int , int  );
    extern  int   j_getmousex ( int  );
    extern  int   j_getmousey ( int  );
    extern  void  j_getmousepos ( int , int* , int*  );
    extern  int   j_getmousebutton ( int  );
    extern  int   j_focuslistener ( int  );
    extern  int   j_componentlistener ( int , int  );
    extern  int   j_windowlistener ( int , int  );
    extern  void  j_setflowlayout ( int , int  );
    extern  void  j_setborderlayout ( int  );
    extern  void  j_setgridlayout ( int , int , int  );
    extern  void  j_setfixlayout ( int  );
    extern  void  j_setnolayout ( int  );
    extern  void  j_setborderpos ( int , int  );
    extern  void  j_sethgap ( int , int  );
    extern  void  j_setvgap ( int , int  );
    extern  void  j_setinsets ( int , int , int , int , int  );
    extern  void  j_setalign ( int , int  );
    extern  void  j_setflowfill ( int , int  );
    extern  void  j_translate ( int , int , int  );
    extern  void  j_cliprect ( int , int , int , int , int  );
    extern  void  j_drawrect ( int , int , int , int , int  );
    extern  void  j_fillrect ( int , int , int , int , int  );
    extern  void  j_drawroundrect ( int , int , int , int , int , int , int  );
    extern  void  j_fillroundrect ( int , int , int , int , int , int , int  );
    extern  void  j_drawoval ( int , int , int , int , int  );
    extern  void  j_filloval ( int , int , int , int , int  );
    extern  void  j_drawcircle ( int , int , int , int  );
    extern  void  j_fillcircle ( int , int , int , int  );
    extern  void  j_drawarc ( int , int , int , int , int , int , int  );
    extern  void  j_fillarc ( int , int , int , int , int , int , int  );
    extern  void  j_drawline ( int , int , int , int , int  );
    extern  void  j_drawpolyline ( int , int , int* , int*  );
    extern  void  j_drawpolygon ( int , int , int* , int*  );
    extern  void  j_fillpolygon ( int , int , int* , int*  );
    extern  void  j_drawpixel ( int , int , int  );
    extern  void  j_drawstring ( int , int , int , char*  );
    extern  void  j_setxor ( int , int  );
    extern  int   j_getimage ( int  );
    extern  void  j_getimagesource ( int , int , int , int , int , int* , int* , int*  );
    extern  void  j_drawimagesource ( int , int , int , int , int , int* , int* , int*  );
    extern  int   j_getscaledimage ( int , int , int , int , int , int , int  );
    extern  void  j_drawimage ( int , int , int , int  );
    extern  void  j_drawscaledimage ( int , int , int , int , int , int , int , int , int , int  );
    extern  void  j_setcolor ( int , int , int , int  );
    extern  void  j_setcolorbg ( int , int , int , int  );
    extern  void  j_setnamedcolor ( int , int  );
    extern  void  j_setnamedcolorbg ( int , int  );
    extern  void  j_settreetextselnamedcolor ( int , int  );
    extern  void  j_settreebgselnamedcolor ( int , int  );
    extern  void  j_settreeborderselnamedcolor ( int , int  );
    extern  void  j_settreetextnonselnamedcolor ( int , int  );
    extern  void  j_settreebgnonselnamedcolor ( int , int  );
    extern  void  j_settreetextselcolor ( int , int , int , int  );
    extern  void  j_settreebgselcolor ( int , int , int , int  );
    extern  void  j_settreeborderselcolor ( int , int , int , int  );
    extern  void  j_settreetextnonselcolor ( int , int , int , int  );
    extern  void  j_settreebgnonselcolor ( int , int , int , int  );
    extern  void  j_setgridnamedcolor ( int , int  );
    extern  void  j_setheadernamedcolor ( int , int  );
    extern  void  j_setheadernamedcolorbg ( int , int  );
    extern  void  j_setgridcolor ( int , int , int , int  );
    extern  void  j_setheadercolor ( int , int , int , int  );
    extern  void  j_setheadercolorbg ( int , int , int , int  );
    extern  int   j_loadimage ( char*  );
    extern  int   j_saveimage ( int , char* , int  );
    extern  void  j_sync ( void  );
    extern  void  j_beep ( void  );
    extern  int   j_random ( void  );
    extern  void  j_sleep ( int  );


#endif /* JAPI_H */


