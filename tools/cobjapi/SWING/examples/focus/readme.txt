****************************************************************************************************************
******************************************  Author: Giancarlo Canini  ******************************************
****************************************************************************************************************
*****************************************  Date Written: 12/05/20023  ******************************************
****************************************************************************************************************

Tectonics on Windows10: cobc -x -free -lws2_32 -o focus.exe focus.cob cobjapi.o japilib.o imageio.o fileselect.o
Tectonics on Linux (Debian 10): cobc -x -free -o focus focus.cob cobjapi.o japilib.o imageio.o fileselect.o

****************************************************************************************************************
****************************************************************************************************************

The program FOCUS uses only 3 fields: ID, Name, and Budget, and consists of 4 main menu: 
1)  Data entry into a sequential file with mask formatting control, numeric input control, 
    and check for any duplication of an existing ID; 
2)  Change data by searching for the ID, disabling the ID field to avoid changing it; 
3)  Display data in a (coloured) table with the possibility of displaying a single record or update (possibly) 
    new data in the table with a double click, and sort data by ID, by Name or by Budget (with optimize Data);
4)  Choice Menu to Delete a Record or the File called 'filedata.dat' 

Functions used:

j-start()
j-quit()
j-getscreenwidth()
j-getscreenheight()
j-frame()
j-setsize()
j-setpos()
j-setnamedcolorbg()
j-setnamedcolor()
j-menubar()
j-menu()
j-menuitem()
j-setfontsize()
j-label()
j-graphiclabel()
j-button()
j-panel()
j-graphicbutton()
j-formattedtextfield()
j-setfontstyle()
j-alertbox()
j-choicebox2()
j-setstate()
j-getstate()
j-messagebox()
j-table()
j-getselect()
j-cleartable()
j-addrow()
j-setcolumnwidths()
j-setgridcolor()
j-checkbox()
j-settext()
j-setcursor()
j-show()
j-pack()
j-nextaction()
j-gettext()
j-sleep()
j-dispose()
j-disable()
j-enable()
