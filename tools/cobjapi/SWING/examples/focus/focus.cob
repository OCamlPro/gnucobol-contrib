*>******************************************************************************
*>  focus.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  focus.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with focus.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>   ****************************************************************************************************************
*>   ******************************************  Author: Giancarlo Canini  ******************************************
*>   ****************************************************************************************************************
*>   *****************************************  Date Written: 12/05/20023  ******************************************
*>   ****************************************************************************************************************
*>
*>   Tectonics on Windows10: cobc -x -free -lws2_32 -o focus.exe focus.cob cobjapi.o japilib.o imageio.o fileselect.o
*>   Tectonics on Linux (Debian 10): cobc -x -free -o focus focus.cob cobjapi.o japilib.o imageio.o fileselect.o
*>
*>   ****************************************************************************************************************
*>   ****************************************************************************************************************

*>   The program FOCUS uses only 3 fields: ID, Name, and Budget, and consists of 4 main menu: 
*>   1)  Data entry into a sequential file with mask formatting control, numeric input control, 
*>       and check for any duplication of an existing ID; 
*>   2)  Change data by searching for the ID, disabling the ID field to avoid changing it; 
*>   3)  Display data in a (coloured) table with the possibility of displaying a single record or update (possibly) 
*>       new data in the table with a double click; 
*>   4)  Choice Menu to Delete a record or the File called 'filedata.dat' 
*>  
*>   Functions used:
*>
*>   j-start()
*>   j-quit()
*>   j-getscreenwidth()
*>   j-getscreenheight()
*>   j-frame()
*>   j-setsize()
*>   j-setpos()
*>   j-setnamedcolorbg()
*>   j-setnamedcolor()
*>   j-menubar()
*>   j-menu()
*>   j-menuitem()
*>   j-setfontsize()
*>   j-label()
*>   j-graphiclabel()
*>   j-button()
*>   j-panel()
*>   j-graphicbutton()
*>   j-formattedtextfield()
*>   j-setfontstyle()
*>   j-alertbox()
*>   j-choicebox2()
*>   j-setstate()
*>   j-getstate()
*>   j-messagebox()
*>   j-table()
*>   j-getselect()
*>   j-cleartable()
*>   j-addrow()
*>   j-setcolumnwidths()
*>   j-setgridcolor()
*>   j-checkbox()
*>   j-settext()
*>   j-setcursor()
*>   j-show()
*>   j-pack()
*>   j-nextaction()
*>   j-gettext()
*>   j-sleep()
*>   j-dispose()
*>   j-disable()
*>   j-enable()
*>
*>   ****************************************************************************************************************
*>   ****************************************************************************************************************


*> **************************************************** <*
*> >>>>>>>>>>>>>> IDENTIFICATION DIVISION <<<<<<<<<<<<< <*
*> **************************************************** <* 
 
 identification division.
 program-id. focus.
          

*> **************************************************** <*
*> >>>>>>>>>>>>>>>> ENVIRONMENT DIVISION <<<<<<<<<<<<<< <*
*> **************************************************** <* 
 
 environment division.
 configuration section.
 repository.
     function all intrinsic
     copy "CobjapiFunctions.cpy".

 input-output section.
     file-control.
         select filedata assign to disk  "filedata.dat"
         organization is sequential.
 

*> **************************************************** <*
*> >>>>>>>>>>>>>>>>>>> DATA DIVISION <<<<<<<<<<<<<<<<<< <*
*> **************************************************** <*

 data division.
 file section.
 fd  filedata.
 01  filerecord.
     02  id-field                    pic x(20).
     02  uno                         pic x(25).
     02  due                         pic 9(16)v9(3).

 working-storage section.
 copy "CobjapiConstants.cpy".        

*>   Objects       
 01  ws-label                        binary-long.
 01  ws-frame                        binary-long.
 01  ws-frame-input                  binary-long.
 01  ws-frame-modify                 binary-long.
 01  ws-frame-view                   binary-long.
 01  ws-frame-choose                 binary-long.
 01  ws-obj                          binary-long.
 01  ws-obj-insert                   binary-long.
 01  ws-obj-modify                   binary-long.
 01  ws-obj-view                     binary-long.
 01  ws-obj-choose                   binary-long.
 01  ws-obj-quit                     binary-long.
 01  ws-menubar                      binary-long.
 01  ws-file                         binary-long.
 01  ws-quit                         binary-long.
 01  ws-button-insert                binary-long.
 01  ws-button-modify                binary-long.
 01  ws-button-search                binary-long.
 01  ws-button-view                  binary-long.
 01  ws-button-choose                binary-long.
 01  ws-button-quit                  binary-long.
 01  ws-button-save                  binary-long.
 01  ws-panel                        binary-long.
 01  ws-table                        binary-long.
 01  ws-item                         binary-long.
 01  ws-textfield-0                  binary-long.
 01  ws-textfield-1                  binary-long.
 01  ws-textfield-2                  binary-long.
 01  ws-textfield-0-modify           binary-long.
 01  ws-delete-file                  binary-long.
 01  ws-delete-record                binary-long.

*>   Fonts
 01  ws-fontstyle                    binary-long.
 01  ws-courier                      binary-long.
 01  ws-bold                         binary-long.
 01  ws-fontsize                     binary-long.

*>   Coordinates and Sizes
 01  ws-columns                      binary-long.
 01  ws-width                        binary-long.
 01  ws-height                       binary-long.
 01  ws-width-label                  binary-long.
 01  ws-height-label                 binary-long.
 01  ws-width-button                 binary-long.
 01  ws-height-button                binary-long.
 01  ws-xpos                         binary-long.
 01  ws-ypos                         binary-long.

*>   File Info
 01  fileinfo.
     02  filesizeinbytes             pic 9(18) comp.
     02  yyyymmdd                    pic 9(8) comp. 
     02  hhmmss00                    pic 9(8) comp.

*>   Return Variables
 01  ws-ret                          binary-long.
 01  ws-alert                        binary-long.
 01  ws-try                          binary-long.
 
*>   Controls 
 01  controllo-modify                pic 9 value 0.
 01  fine                            pic x value "n".
 01  trovato                         pic 9 value 0.
 01  delete-record                   pic 9 value 0.
 01  delete-string                   pic x(65).

*>   Counts characters of Identification Field
 01  counter                         pic 9(2) value 0.

*>   Mask Data Type (alfanumeric, numeric, ecc...) and Look ("_")
 01  ws-mask-str                     pic x(30).
 01  ws-place-holder-char            pic x(1).

*>   Mask Variables
 01  identificativo-acquisito        pic x(256).
 01  testo-acquisito                 pic x(256).
 01  numero-acquisito                pic x(256).

*>   Data to Save 
 01  identificativo                  pic x(20). 
 01  nome                            pic x(25).  
 01  importo                         pic 9(16)v9(3).
 01  importo-view                    pic z,zzz,zzz,zzz,zzz,zz9.999.
 01  importo-float                   pic x(30).                   
 
*>   Milliseconds to wait (Info Message)
 01  ws-msec                         binary-long.

*>   Table structure
 01  i                               pic 9(4).

 01  ws-column-names.
     02 filler   value "Identification".
     02 filler   value "|".
     02 filler   value "Name".
     02 filler   value "|".
     02 filler   value "Budget".

 01  ws-column-widths.
     02 filler   value "220".
     02 filler   value "|".
     02 filler   value "320".
     02 filler   value "|".
     02 filler   value "250".

 01  ws-rows.
     02  element occurs 1000 times.  
         03  ws-row                  pic x(65).



*> **************************************************** <*
*> >>>>>>>>>>>>>>>> PROCEDURE DIVISION <<<<<<<<<<<<<<<< <*
*> **************************************************** <*
 
 procedure division.

*>   Start CobJapi    
     move j-start() to ws-ret

     if ws-ret = zeroes
     then
        display "Can't connect to server! (JAPI.jar)"
        stop run
     end-if

     perform create-gui-elements

*>   Perform until Exit Perform
     perform forever
         move j-nextaction() to ws-obj
  
         if  ws-obj = ws-frame or
             ws-obj = ws-quit or 
             ws-obj = ws-button-quit
             move j-choicebox2(ws-frame, "Quit", "Do you want to exit the Program?", " Yes ", " No ") to ws-ret

             if  ws-ret = 1
                 exit perform 
             end-if

         end-if         

         if  ws-obj = ws-button-insert
             perform data-input     
         end-if

         if  ws-obj = ws-button-modify
             perform data-modify       
         end-if  

         if  ws-obj = ws-button-view
             perform data-view       
         end-if

         if  ws-obj = ws-button-choose
             perform data-choose      
         end-if 
              
     end-perform

*>   Quit CobJApi and Stop Run  
     move j-quit() to ws-ret 

     stop run
     .


*> ******************************************************************* <*
*> >>>>>>>>>>>>>>>>>> Create GUI Elements Procedure <<<<<<<<<<<<<<<<<< <*
*> ******************************************************************* <*

 create-gui-elements.
     move j-getscreenwidth() to ws-width
     move j-getscreenheight() to ws-height
     
*>   Create Main Ws-Frame Elements
*>   Create Frame
     move j-frame("Focus") to ws-frame                  
     move j-setsize(ws-frame, ws-width, ws-height) to ws-ret
     move j-setpos(ws-frame, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-frame, j-dark-gray) to ws-ret

*>   Crete Menu
     move j-menubar(ws-frame) to ws-menubar
     move j-setnamedcolorbg(ws-menubar, j-dark-gray) to ws-ret            
     move j-menu(ws-menubar, "File") to ws-file
     move 18 to ws-fontsize
     move j-setfontsize(ws-file, ws-fontsize) to ws-ret
     move j-setnamedcolor(ws-file, j-green) to ws-ret
     move j-menuitem(ws-file, "Quit") to ws-quit
     move 18 to ws-fontsize
     move j-setfontsize(ws-quit, ws-fontsize) to ws-ret
     move j-setnamedcolor(ws-quit, j-green) to ws-ret

*>   Create Background Label     
     move j-label(ws-frame, "GnuCOBOL CobJapi Demo") to ws-label      
     move 52 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 550 to ws-xpos
     move 680 to ws-ypos
     move 800 to ws-width-label
     move 100 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-yellow) to ws-ret

*>   Create Input Data Button
     move j-graphicbutton(ws-frame, "input-data.png") to ws-button-insert
     move 150 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-insert, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-button-insert, j-dark-gray) to ws-ret

*>   Create Input Data Label
     move j-label(ws-frame, "Input data") to ws-label      
     move 18 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 65 to ws-xpos
     move 350 to ws-ypos
     move 300 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-green-yellow) to ws-ret

*>   Create Modify Data Button
     move j-graphicbutton(ws-frame, "modify-data.png") to ws-button-modify
     move 500 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-modify, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-button-modify, j-dark-gray) to ws-ret

*>   Create Modify Data Label
     move j-label(ws-frame, "Modify data") to ws-label      
     move 18 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 418 to ws-xpos
     move 350 to ws-ypos
     move 300 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-red) to ws-ret

*>   Create View Data Button
     move j-graphicbutton(ws-frame, "view-data.png") to ws-button-view
     move 850 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-view, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-button-view, j-dark-gray) to ws-ret

*>   Create View Data Label
     move j-label(ws-frame, "View data") to ws-label      
     move 18 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 770 to ws-xpos
     move 350 to ws-ypos
     move 300 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-white) to ws-ret

*>   Create Choose Button
     move j-graphicbutton(ws-frame, "choose.png") to ws-button-choose
     move 1200 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-choose, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-button-choose, j-dark-gray) to ws-ret

*>   Create Choose Data Label
     move j-label(ws-frame, "Menu") to ws-label      
     move 18 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 1170 to ws-xpos
     move 350 to ws-ypos
     move 300 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-blue-cyan) to ws-ret

*>   Create Quit Button
     move j-graphicbutton(ws-frame, "quit.png") to ws-button-quit
     move 1600 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-quit, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-button-quit, j-dark-gray) to ws-ret

*>   Create Quit Data Label
     move j-label(ws-frame, "Quit") to ws-label      
     move 18 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 1540 to ws-xpos
     move 350 to ws-ypos
     move 300 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-orange) to ws-ret

*>   Create Ws-Frame-Input Elements
*>   Create Frame
     move j-frame("Input Data") to ws-frame-input         
     move 770 to ws-xpos
     move 150 to ws-ypos                    
     move j-setpos(ws-frame-input, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-frame-input, j-dark-gray) to ws-ret

*>   Create Identification Label
     move j-label(ws-frame-input, "Enter your Identification") to ws-label      
     move 14 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 10 to ws-xpos
     move 30 to ws-ypos
     move 190 to ws-width-label
     move 25 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-magenta) to ws-ret

*>   Create Name Label
     move j-label(ws-frame-input, "Enter your Name") to ws-label      
     move 14 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 10 to ws-xpos
     move 90 to ws-ypos
     move 135 to ws-width-label
     move 25 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-white) to ws-ret

*>   Create Budget Label
     move j-label(ws-frame-input, "Enter your Budget") to ws-label      
     move 14 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 10 to ws-xpos
     move 150 to ws-ypos
     move 145 to ws-width-label
     move 25 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-green) to ws-ret

*>   Create Identification Mask      
     move "********************" to ws-mask-str         
     move "_" to ws-place-holder-char
     move 30 to ws-columns
     move j-formattedtextfield(ws-frame-input, ws-mask-str, ws-place-holder-char, ws-columns) to ws-textfield-0
     move j-setnamedcolorbg(ws-textfield-0, j-black) to ws-ret
     move j-setnamedcolor(ws-textfield-0, j-magenta) to ws-ret
     move j-setfontstyle(ws-textfield-0, j-courier, j-bold, ws-fontstyle) to ws-ret                              
         
*>   Create Name Mask
     move "*************************" to ws-mask-str         
     move "_" to ws-place-holder-char
     move 30 to ws-columns
     move j-formattedtextfield(ws-frame-input, ws-mask-str, ws-place-holder-char, ws-columns) to ws-textfield-1
     move j-setnamedcolorbg(ws-textfield-1, j-black) to ws-ret
     move j-setnamedcolor(ws-textfield-1, j-white) to ws-ret
     move j-setfontstyle(ws-textfield-1, j-courier, j-bold, ws-fontstyle) to ws-ret
     
*>   Create Budget Mask
     move "#.###.###.###.###.###,###" to ws-mask-str         
     move "_" to ws-place-holder-char
     move 30 to ws-columns
     move j-formattedtextfield(ws-frame-input, ws-mask-str, ws-place-holder-char, ws-columns) to ws-textfield-2
     move j-setnamedcolorbg(ws-textfield-2, j-black) to ws-ret
     move j-setnamedcolor(ws-textfield-2, j-green) to ws-ret
     move j-setfontstyle(ws-textfield-2, j-courier, j-bold, ws-fontstyle) to ws-ret

*>   Create Save Button
     move j-button(ws-frame-input, "Save") to ws-button-save
     move 80 to ws-width-button
     move 40 to ws-height-button
     move j-setsize(ws-button-save, ws-width-button, ws-height-button) to ws-ret
     move 150 to ws-xpos
     move 230 to ws-ypos
     move j-setpos(ws-button-save, ws-xpos, ws-ypos) to ws-ret

*>   Create Ws-Frame-Modify Elements
*>   Create Frame
     move j-frame("Modify Data") to ws-frame-modify         
     move 770 to ws-xpos
     move 150 to ws-ypos                    
     move j-setpos(ws-frame-modify, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-frame-modify, j-dark-gray) to ws-ret

*>   Create Identification Label
     move j-label(ws-frame-modify, "Search by your Identification") to ws-label      
     move 14 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 10 to ws-xpos
     move 30 to ws-ypos
     move 230 to ws-width-label
     move 25 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-magenta) to ws-ret
     
*>   Create Search Button
     move j-button(ws-frame-modify, "Search for ID") to ws-button-search
     move 150 to ws-width-button
     move 40 to ws-height-button
     move j-setsize(ws-button-search, ws-width-button, ws-height-button) to ws-ret
     move 120 to ws-xpos
     move 240 to ws-ypos
     move j-setpos(ws-button-search, ws-xpos, ws-ypos) to ws-ret

*>   Create Identification Modify Mask      
     move "********************" to ws-mask-str         
     move "_" to ws-place-holder-char
     move 30 to ws-columns
     move j-formattedtextfield(ws-frame-modify, ws-mask-str, ws-place-holder-char, ws-columns) to ws-textfield-0-modify
     move j-setnamedcolorbg(ws-textfield-0-modify, j-black) to ws-ret
     move j-setnamedcolor(ws-textfield-0-modify, j-red) to ws-ret
     move j-setfontstyle(ws-textfield-0-modify, j-courier, j-bold, ws-fontstyle) to ws-ret

*>   Create Ws-Frame-View Elements
*>   Create Frame
     move j-frame("View Data - Double click on the Table to View or (possibly) Update new data") to ws-frame-view         
     move 550 to ws-xpos
     move 100 to ws-ypos                    
     move j-setpos(ws-frame-view, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-frame-view, j-dark-gray) to ws-ret

*>   Create and Set Position Panel         
     move j-panel(ws-frame-view) to ws-panel
     move 1 to ws-xpos
     move 1 to ws-ypos
     move j-setpos(ws-panel, ws-xpos, ws-ypos) to ws-ret
     move 800 to ws-width
     move 600 to ws-height
     move j-setsize(ws-panel, ws-width, ws-height) to ws-ret

*>   Create Table
     move j-table(ws-panel, ws-column-names) to ws-table
     move j-setcolumnwidths(ws-table, ws-column-widths) to ws-ret
     move j-setgridcolor(ws-table, j-white, j-green, j-blue) to ws-ret
     move j-setgridnamedcolor(ws-table, j-blue) to ws-ret
     move j-setnamedcolorbg(ws-table, j-black) to ws-ret
     move j-setnamedcolor(ws-table, j-yellow) to ws-ret

*>   Create Ws-Frame-Choose-Delete Elements
*>   Create Frame
     move j-frame("Choose: Delete File or Delete Record") to ws-frame-choose         
     move 830 to ws-xpos
     move 250 to ws-ypos                    
     move j-setpos(ws-frame-choose, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolorbg(ws-frame-choose, j-dark-gray) to ws-ret

*>   Create Delete Label
     move j-label(ws-frame-choose, "Delete Menu") to ws-label      
     move 16 to ws-fontsize
     move j-setfontsize(ws-label, ws-fontsize) to ws-ret
     move 25 to ws-xpos
     move 10 to ws-ypos
     move 120 to ws-width-label
     move 30 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-label, j-white) to ws-ret

*>   Create Delete File Checkbox
     move j-checkbox(ws-frame-choose, "Delete FILE !!!") to ws-delete-file
     move 40 to ws-xpos
     move 80 to ws-ypos
     move j-setpos(ws-delete-file, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-delete-file, j-white) to ws-ret
     move j-setnamedcolorbg(ws-delete-file, j-red) to ws-ret
     
*>   Create Delete Record Checkbox
     move j-checkbox(ws-frame-choose, "Delete Record") to ws-delete-record
     move 40 to ws-xpos
     move 120 to ws-ypos
     move j-setpos(ws-delete-record, ws-xpos, ws-ypos) to ws-ret
     move j-setnamedcolor(ws-delete-record, j-white) to ws-ret
     move j-setnamedcolorbg(ws-delete-record, j-orange) to ws-ret

*>   Create Delete File Label
     move j-graphiclabel(ws-frame-choose, "delete-file.png") to ws-label      
     move 10 to ws-xpos
     move 80 to ws-ypos
     move 20 to ws-width-label
     move 20 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret

*>   Create Delete Record Label
     move j-graphiclabel(ws-frame-choose, "delete-record.png") to ws-label      
     move 10 to ws-xpos
     move 120 to ws-ypos
     move 20 to ws-width-label
     move 20 to ws-height-label
     move j-setsize(ws-label, ws-width-label, ws-height-label) to ws-ret 
     move j-setpos(ws-label, ws-xpos, ws-ypos) to ws-ret

*>   Create Others GUI Elements
*>   Set Position Identification Field
     move 10 to ws-xpos
     move 55 to ws-ypos
     move j-setpos(ws-textfield-0, ws-xpos, ws-ypos) to ws-ret

*>   Set Position Modify Identification Field
     move 10 to ws-xpos
     move 55 to ws-ypos
     move j-setpos(ws-textfield-0-modify, ws-xpos, ws-ypos) to ws-ret
     
*>   Set Position Name Field
     move 10 to ws-xpos
     move 115 to ws-ypos
     move j-setpos(ws-textfield-1, ws-xpos, ws-ypos) to ws-ret
     
*>   Set Position Budget Field
     move 10 to ws-xpos
     move 175 to ws-ypos
     move j-setpos(ws-textfield-2, ws-xpos, ws-ypos) to ws-ret
          
*>   General setting
*>   Initialize input fields
     move j-settext(ws-textfield-0, "_") to ws-ret
     move j-settext(ws-textfield-1, "_") to ws-ret
     move j-settext(ws-textfield-2, "0.000.000.000.000.000,000") to ws-ret

*>   Set the j-hand cursor look above the button
     move j-setcursor(ws-button-insert, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-modify, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-view, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-choose, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-quit, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-save, j-hand-cursor) to ws-ret
     move j-setcursor(ws-button-search, j-hand-cursor) to ws-ret
     move j-setcursor(ws-delete-file, j-hand-cursor) to ws-ret
     move j-setcursor(ws-delete-record, j-hand-cursor) to ws-ret
     move j-setcursor(ws-table, j-crosshair-cursor) to ws-ret

*>   Set the j-text cursor look above the text fields
     move j-setcursor(ws-textfield-0, j-text-cursor) to ws-ret
     move j-setcursor(ws-textfield-1, j-text-cursor) to ws-ret
     move j-setcursor(ws-textfield-2, j-text-cursor) to ws-ret

*>   Show Ws-Frame
     move j-show(ws-frame) to ws-ret
     move j-pack(ws-frame) to ws-ret.


*> ********************************************************************************* <*
*> >>>>>>>>>>>>>>>>>>>>>>>>>> Accept Input Data Procedure <<<<<<<<<<<<<<<<<<<<<<<<<< <*
*> ********************************************************************************* <*

 data-input.
     move j-show(ws-frame-input) to ws-ret
     move j-pack(ws-frame-input) to ws-ret

*>   Perform Until Exit Perform    
     perform forever
         move j-nextaction() to ws-obj-insert

         if  ws-obj-insert = ws-frame-input and controllo-modify = 0
             exit perform
         end-if

         move 1 to ws-try

*>   Get data into identificativo-acquisito, testo-acquisito, and numero-acquisito            
         if  controllo-modify = 0
             move 0 to counter
             move j-gettext(ws-textfield-0, identificativo-acquisito) to ws-ret

             inspect identificativo-acquisito replacing all "_" by " "
             inspect identificativo-acquisito replacing all "à" by spaces
             inspect identificativo-acquisito replacing all "è" by spaces
             inspect identificativo-acquisito replacing all "é" by spaces
             inspect identificativo-acquisito replacing all "ì" by spaces
             inspect identificativo-acquisito replacing all "ò" by spaces
             inspect identificativo-acquisito replacing all "ù" by spaces
             inspect identificativo-acquisito replacing all "°" by spaces
             inspect identificativo-acquisito replacing all "^" by spaces
             inspect identificativo-acquisito replacing all "ç" by spaces
             inspect identificativo-acquisito replacing all "§" by spaces
             inspect identificativo-acquisito replacing all "@" by spaces
             inspect identificativo-acquisito replacing all "#" by spaces
             inspect identificativo-acquisito tallying counter for all " "
         end-if

         move j-gettext(ws-textfield-1, testo-acquisito) to ws-ret 

         inspect testo-acquisito replacing all "_" by " "
         inspect testo-acquisito replacing all "à" by spaces
         inspect testo-acquisito replacing all "è" by spaces
         inspect testo-acquisito replacing all "é" by spaces
         inspect testo-acquisito replacing all "ì" by spaces
         inspect testo-acquisito replacing all "ò" by spaces
         inspect testo-acquisito replacing all "ù" by spaces
         inspect testo-acquisito replacing all "°" by spaces
         inspect testo-acquisito replacing all "^" by spaces
         inspect testo-acquisito replacing all "ç" by spaces
         inspect testo-acquisito replacing all "§" by spaces
         inspect testo-acquisito replacing all "@" by spaces
         inspect testo-acquisito replacing all "#" by spaces
             
         move j-gettext(ws-textfield-2, numero-acquisito) to ws-ret
         
         inspect numero-acquisito replacing all "." by " "
         inspect numero-acquisito replacing all "_" by " "
         inspect numero-acquisito replacing all "," by "."
  
         move trim(identificativo-acquisito) to identificativo
         move trim(testo-acquisito) to nome
         move trim(numero-acquisito) to importo

         if  ws-obj-insert = ws-button-save

*>   If not get data
             if  identificativo is equal to spaces or
                 nome is equal to spaces or
                 importo is equal to zeroes or
                 importo = "0.000.000.000.000.000,000" or
                 counter > 53                                              
                 move j-alertbox(ws-frame-input, "Attention!!!", "The entered data has not been acquired correctly." & x"0a" &
                     "Fill in all input fields or clear input data with BackSpace and try again." & x"0a" &
                     "The Identification field must be at least 3 characters.", "Ok") to ws-alert

*>   If get data
             else

                 move 0 to trovato 

                 call "CBL_CHECK_FILE_EXIST"   
                         using       "filedata.dat", fileinfo
                         returning   return-code 
                 end-call 

                 if  return-code = 35 and controllo-modify = 0
                     open output filedata
                     move identificativo to id-field
                     move nome to uno
                     move importo to due
                     write filerecord
                     close filedata
                 end-if

                 if  return-code = 0 and controllo-modify = 0
                     move "n" to fine
                     open i-o filedata

                     perform until fine is equal to "y"
                         read filedata at end move "y" to fine
                         end-read
                         
                         if  id-field = identificativo and identificativo is not equal to spaces
                             move "y" to fine
                             move 1 to trovato
                             move j-choicebox2(ws-frame-modify, "Attention!!!", "The Identification already exists!" & x"0a" & 
                                 "Do you want to try with another ID?", "Yes", "No") to ws-try
                         end-if

                     end-perform

                     close filedata

                     if  trovato = 0
                         open extend filedata
                         move identificativo to id-field
                         move nome to uno
                         move importo to due
                         write filerecord
                         close filedata
                     end-if

                 end-if

                 if  return-code = 0 and controllo-modify = 1
                     move identificativo to id-field
                     move nome to uno
                     move importo to due
                     rewrite filerecord 
                 end-if
                 
                 if  ws-try = 2
                     exit perform                    
                 end-if
                 
                 if  trovato = 0
                     move j-messagebox(ws-frame, "Info", "Data saved correctly!") to ws-alert
                     move 2000 to ws-msec
                     move j-sleep(ws-msec) to ws-ret
                     move j-dispose(ws-alert) to ws-ret
                     exit perform
                 end-if

             end-if

         end-if

     end-perform

*>   Close Ws-Frame-Input and Initialize Texts
     if  controllo-modify = 0
         move j-settext(ws-textfield-0, "_") to ws-ret
     end-if

     move j-settext(ws-textfield-1, "_") to ws-ret
     move j-settext(ws-textfield-2, "0.000.000.000.000.000,000") to ws-ret

     move j-dispose(ws-frame-input) to ws-ret.


*> ********************************************************************************* <*
*> >>>>>>>>>>>>>>>>>>>>>>>>>>>>> Modify Data Procedure <<<<<<<<<<<<<<<<<<<<<<<<<<<<< <*
*> ********************************************************************************* <*

 data-modify.
     move j-show(ws-frame-modify) to ws-ret
     move j-pack(ws-frame-modify) to ws-ret

     move j-settext(ws-textfield-0-modify, "_") to ws-ret
     move 0 to controllo-modify
     move 0 to counter
     move "n" to fine

*>   Perform Until Exit Perform    
     perform forever
         move j-nextaction() to ws-obj-modify

         if  ws-obj-modify = ws-frame-modify
             move 0 to controllo-modify
             exit perform
         end-if

         if  ws-obj-modify = ws-button-search 

*>   Get data into identificativo-acquisito
             move j-gettext(ws-textfield-0-modify, identificativo-acquisito) to ws-ret
             
             inspect identificativo-acquisito replacing all "_" by " "
             inspect identificativo-acquisito replacing all "à" by spaces
             inspect identificativo-acquisito replacing all "è" by spaces
             inspect identificativo-acquisito replacing all "é" by spaces
             inspect identificativo-acquisito replacing all "ì" by spaces
             inspect identificativo-acquisito replacing all "ò" by spaces
             inspect identificativo-acquisito replacing all "ù" by spaces
             inspect identificativo-acquisito replacing all "°" by spaces
             inspect identificativo-acquisito replacing all "^" by spaces
             inspect identificativo-acquisito replacing all "ç" by spaces
             inspect identificativo-acquisito replacing all "§" by spaces
             inspect identificativo-acquisito replacing all "@" by spaces
             inspect identificativo-acquisito replacing all "#" by spaces
             inspect identificativo-acquisito tallying counter for all " "
 
             move trim(identificativo-acquisito) to identificativo
 
             call "CBL_CHECK_FILE_EXIST"   
                     using       "filedata.dat", fileinfo
                     returning   return-code 
             end-call 
                    
             if  return-code = 35
                 move j-alertbox(ws-frame-modify, "Attention!!!", "The filedata.dat file does not exist." & x"0a" &
                     "Create the file in the Input Data Menu.", "Ok") to ws-alert
                 exit perform

             else
             
                 open i-o filedata

                 perform until fine is equal to "y"
                     read filedata at end move "y" to fine
                     end-read

                     if  id-field = identificativo and identificativo is not equal to spaces
                         move id-field to identificativo
                         move uno to nome
                         move due to importo
                         move "y" to fine
                         move 1 to controllo-modify
                     end-if

                 end-perform

                 move "n" to fine

                 if  controllo-modify = 1 and delete-record = 1
                     move importo to importo-view
                     
                     inspect importo-view replacing all "." by "|"
                     inspect importo-view replacing all "," by "."
                     inspect importo-view replacing all "|" by ","
                     
                     string  "ID: " trim(identificativo) x"0a" 
                             "Name: " trim(nome) x"0a" 
                             "Budget: " trim(importo-view) 
                             into delete-string

                     move j-choicebox2(ws-frame-modify, "Do you want to delete this record?", 
                         delete-string, "Yes", "No") to ws-ret

                         if  ws-ret = 1
                             move spaces to id-field
                             move spaces to uno
                             move zeroes to due
                             rewrite filerecord
                             close filedata
                             move 0 to controllo-modify
                             exit perform
                         end-if

                         if  ws-ret = 2
                             close filedata
                             move 0 to controllo-modify
                             exit perform
                         end-if

                 end-if
 
                 if  controllo-modify = 1
                     move j-settext(ws-textfield-0, identificativo) to ws-ret
                     move j-settext(ws-textfield-1, nome) to ws-ret
                     move j-settext(ws-textfield-2, importo) to ws-ret
                     move j-disable(ws-textfield-0) to ws-ret

                     perform data-input
                     
                     move j-enable(ws-textfield-0) to ws-ret
                     move j-settext(ws-textfield-0, "_") to ws-ret
                     move 0 to controllo-modify
                     close filedata
                     exit perform
                 end-if
                 
                 if  controllo-modify = 0
                     move j-alertbox(ws-frame-modify, "Attention!!!", "Your ID does not exist." & x"0a" &
                     "Input another Identification and try again.", "Ok") to ws-alert
                     close filedata
                 end-if

             end-if

         end-if

     end-perform

*>   Close Ws-Frame-Modify
     move j-dispose(ws-frame-modify) to ws-ret.


*> ********************************************************************************* <*
*> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> View Data Procedure <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< <*
*> ********************************************************************************* <*

 data-view.
     move j-show(ws-frame-view) to ws-ret
     move j-pack(ws-frame-view) to ws-ret

     call "CBL_CHECK_FILE_EXIST"   
         using       "filedata.dat", fileinfo
         returning   return-code 
     end-call

     perform forever   
         move j-nextaction() to ws-obj-view

         if  ws-obj-view = ws-frame-view
             exit perform
         end-if

         if  ws-obj-view = ws-table
             move j-getselect(ws-table) to ws-item
             add 1 to ws-item

             if  ws-item >= 0
                 move j-alertbox(ws-frame-view, "Selected record from filedata.dat", ws-row(ws-item), "Ok") to ws-ret                    
             end-if 

         end-if

         if  return-code = 35
             move j-alertbox(ws-frame-modify, "Attention!!!", "The filedata.dat file does not exist." & x"0a" &
             "Create the file in the Input Data Menu.", "Ok") to ws-alert
             exit perform

         else

             move 1 to i
             move "n" to fine
             open input filedata
             move j-cleartable(ws-table) to ws-ret
             initialize ws-rows

             perform until fine is equal to "y"
                 read filedata at end move "y" to fine
                 end-read
                
                 if  fine <> "y" and id-field is not equal to spaces
                     move id-field to identificativo
                     move uno to nome
                     move due to importo-view
                     move importo-view to importo-float

                     inspect importo-float replacing all "." by "|"
                     inspect importo-float replacing all "," by "."
                     inspect importo-float replacing all "|" by ","

                     string  trim(identificativo), "|", 
                             trim(nome), "|", 
                             trim(importo-float) 
                             into ws-row(i)

                     move j-addrow(ws-table, ws-row(i)) to ws-ret
                     add 1 to i
                 end-if

             end-perform

             close filedata

         end-if

     end-perform
     
     move j-dispose(ws-frame-view) to ws-ret.
     

*> ********************************************************************************* <*
*> >>>>>>>>>>>>>>>>>>>>>>>>>> Choose Data Delete Procedure <<<<<<<<<<<<<<<<<<<<<<<<< <*
*> ********************************************************************************* <*

 data-choose.
     move j-show(ws-frame-choose) to ws-ret
     move j-pack(ws-frame-choose) to ws-ret

     move j-setstate(ws-delete-file, j-false) to ws-ret
     move j-setstate(ws-delete-record, j-false) to ws-ret

     perform forever   
         move j-nextaction() to ws-obj-choose

         if  ws-obj-choose = ws-frame-choose
             exit perform
         end-if

         if  ws-obj-choose = ws-delete-file
             move j-getstate(ws-delete-file) to ws-ret

             if  ws-ret = j-true
                 move j-choicebox2(ws-frame-modify, "Attention!!!", "Do you really want to delete the filedata.dat" & x"0a" &
                 "file with all its data?", "Yes", "No") to ws-ret

                 if  ws-ret = 1
                     call "CBL_DELETE_FILE" using "filedata.dat"
                     end-call
                 end-if

                 exit perform

             end-if

         end-if
 
         if  ws-obj-choose = ws-delete-record
             move j-getstate(ws-delete-record) to ws-ret

             if  ws-ret = j-true
                 move 1 to delete-record

                 perform data-modify

                 move 0 to delete-record
                 exit perform
             end-if

         end-if

     end-perform
     
     move j-dispose(ws-frame-choose) to ws-ret.
