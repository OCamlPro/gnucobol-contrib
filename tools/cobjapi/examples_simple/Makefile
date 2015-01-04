COBC = cobc
COBCFLAGS = -x -free
# static link
COBJAPI = ../src_cobol/cobjapi.o
CJAPI = ../src_c/japilib.o \
		../src_c/imageio.o \
		../src_c/fileselect.o

all : alert.exe borderlayout.exe borderpanel.exe button.exe canvas.exe \
      checkbox.exe choice.exe colors.exe colors1.exe componentlistener.exe \
	  cursor.exe daemon.exe dialog.exe dialogmodal.exe filedialog.exe \
	  flowlayout.exe flowsimple.exe focuslistener.exe font.exe frame.exe \
	  graphic.exe graphicbutton.exe graphiclabel.exe gridlayout.exe \
	  image.exe insets.exe keylistener.exe label.exe lines.exe list.exe \
	  listmultiple.exe menu.exe mousebuttons.exe mouselistener.exe \
	  panel.exe popupmenu.exe print.exe radiobutton.exe rubberband.exe \
	  scaledimage.exe scrollbar.exe scrollpane.exe simple.exe \
      simplemenu.exe textfield.exe vumeter.exe window.exe \
      windowlistener.exe	  

# compile
alert.exe : alert.cob
	$(COBC) $(COBCFLAGS) alert.cob             $(COBJAPI) $(CJAPI)
                                               
borderlayout.exe : borderlayout.cob            
	$(COBC) $(COBCFLAGS) borderlayout.cob      $(COBJAPI) $(CJAPI)
                                               
borderpanel.exe : borderpanel.cob              
	$(COBC) $(COBCFLAGS) borderpanel.cob       $(COBJAPI) $(CJAPI)
                                               
button.exe : button.cob                        
	$(COBC) $(COBCFLAGS) button.cob            $(COBJAPI) $(CJAPI)
                                               
canvas.exe : canvas.cob                        
	$(COBC) $(COBCFLAGS) canvas.cob            $(COBJAPI) $(CJAPI)
                                               
checkbox.exe : checkbox.cob                    
	$(COBC) $(COBCFLAGS) checkbox.cob          $(COBJAPI) $(CJAPI)
                                               
choice.exe : choice.cob                        
	$(COBC) $(COBCFLAGS) choice.cob            $(COBJAPI) $(CJAPI)
	                                           
colors.exe : colors.cob                        
	$(COBC) $(COBCFLAGS) colors.cob            $(COBJAPI) $(CJAPI)
	                                           
colors1.exe : colors1.cob                      
	$(COBC) $(COBCFLAGS) colors1.cob           $(COBJAPI) $(CJAPI)
                                               
componentlistener.exe : componentlistener.cob
	$(COBC) $(COBCFLAGS) componentlistener.cob $(COBJAPI) $(CJAPI)

cursor.exe : cursor.cob                        
	$(COBC) $(COBCFLAGS) cursor.cob            $(COBJAPI) $(CJAPI)
	
daemon.exe : daemon.cob                        
	$(COBC) $(COBCFLAGS) daemon.cob            $(COBJAPI) $(CJAPI)

dialog.exe : dialog.cob                        
	$(COBC) $(COBCFLAGS) dialog.cob            $(COBJAPI) $(CJAPI)

dialogmodal.exe : dialogmodal.cob                        
	$(COBC) $(COBCFLAGS) dialogmodal.cob       $(COBJAPI) $(CJAPI)
	
filedialog.exe : filedialog.cob
	$(COBC) $(COBCFLAGS) filedialog.cob        $(COBJAPI) $(CJAPI)

flowlayout.exe : flowlayout.cob
	$(COBC) $(COBCFLAGS) flowlayout.cob        $(COBJAPI) $(CJAPI)

flowsimple.exe : flowsimple.cob
	$(COBC) $(COBCFLAGS) flowsimple.cob        $(COBJAPI) $(CJAPI)
	
focuslistener.exe : focuslistener.cob
	$(COBC) $(COBCFLAGS) focuslistener.cob     $(COBJAPI) $(CJAPI)
	
font.exe : font.cob
	$(COBC) $(COBCFLAGS) font.cob              $(COBJAPI) $(CJAPI)
	
frame.exe : frame.cob
	$(COBC) $(COBCFLAGS) frame.cob             $(COBJAPI) $(CJAPI)

graphic.exe : graphic.cob
	$(COBC) $(COBCFLAGS) graphic.cob           $(COBJAPI) $(CJAPI)

graphicbutton.exe : graphicbutton.cob
	$(COBC) $(COBCFLAGS) graphicbutton.cob     $(COBJAPI) $(CJAPI)
	
graphiclabel.exe : graphiclabel.cob
	$(COBC) $(COBCFLAGS) graphiclabel.cob      $(COBJAPI) $(CJAPI)

gridlayout.exe : gridlayout.cob
	$(COBC) $(COBCFLAGS) gridlayout.cob        $(COBJAPI) $(CJAPI)
	
image.exe : image.cob
	$(COBC) $(COBCFLAGS) image.cob             $(COBJAPI) $(CJAPI)
	
insets.exe : insets.cob
	$(COBC) $(COBCFLAGS) insets.cob            $(COBJAPI) $(CJAPI)

keylistener.exe : keylistener.cob
	$(COBC) $(COBCFLAGS) keylistener.cob       $(COBJAPI) $(CJAPI)

label.exe : label.cob
	$(COBC) $(COBCFLAGS) label.cob             $(COBJAPI) $(CJAPI)

lines.exe : lines.cob
	$(COBC) $(COBCFLAGS) lines.cob             $(COBJAPI) $(CJAPI)

list.exe : list.cob
	$(COBC) $(COBCFLAGS) list.cob              $(COBJAPI) $(CJAPI)
	
listmultiple.exe : listmultiple.cob
	$(COBC) $(COBCFLAGS) listmultiple.cob      $(COBJAPI) $(CJAPI)
	
menu.exe : menu.cob
	$(COBC) $(COBCFLAGS) menu.cob              $(COBJAPI) $(CJAPI)

mousebuttons.exe : mousebuttons.cob
	$(COBC) $(COBCFLAGS) mousebuttons.cob      $(COBJAPI) $(CJAPI)

mouselistener.exe : mouselistener.cob
	$(COBC) $(COBCFLAGS) mouselistener.cob     $(COBJAPI) $(CJAPI)

panel.exe : panel.cob
	$(COBC) $(COBCFLAGS) panel.cob             $(COBJAPI) $(CJAPI)

popupmenu.exe : popupmenu.cob
	$(COBC) $(COBCFLAGS) popupmenu.cob         $(COBJAPI) $(CJAPI)

print.exe : print.cob
	$(COBC) $(COBCFLAGS) print.cob             $(COBJAPI) $(CJAPI)

radiobutton.exe : radiobutton.cob
	$(COBC) $(COBCFLAGS) radiobutton.cob       $(COBJAPI) $(CJAPI)

rubberband.exe : rubberband.cob
	$(COBC) $(COBCFLAGS) rubberband.cob        $(COBJAPI) $(CJAPI)
 
scaledimage.exe : scaledimage.cob
	$(COBC) $(COBCFLAGS) scaledimage.cob       $(COBJAPI) $(CJAPI)

scrollbar.exe : scrollbar.cob
	$(COBC) $(COBCFLAGS) scrollbar.cob         $(COBJAPI) $(CJAPI)

scrollpane.exe : scrollpane.cob
	$(COBC) $(COBCFLAGS) scrollpane.cob        $(COBJAPI) $(CJAPI)
	
simple.exe : simple.cob                       
	$(COBC) $(COBCFLAGS) simple.cob            $(COBJAPI) $(CJAPI)

simplemenu.exe : simplemenu.cob                       
	$(COBC) $(COBCFLAGS) simplemenu.cob        $(COBJAPI) $(CJAPI)

textfield.exe : textfield.cob                       
	$(COBC) $(COBCFLAGS) textfield.cob         $(COBJAPI) $(CJAPI)

vumeter.exe : vumeter.cob                       
	$(COBC) $(COBCFLAGS) vumeter.cob           $(COBJAPI) $(CJAPI)

window.exe : window.cob                       
	$(COBC) $(COBCFLAGS) window.cob            $(COBJAPI) $(CJAPI)

windowlistener.exe : windowlistener.cob                       
	$(COBC) $(COBCFLAGS) windowlistener.cob    $(COBJAPI) $(CJAPI)
	
# clean
clean :
	rm *.exe
	