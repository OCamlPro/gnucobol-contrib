GNU    >>SOURCE FORMAT IS FIXED
Cobol *>
      *>****P* cobweb/cobweb-gui [demo]
      *> Name:
      *>   cobweb-gui, a cobweb GTK usage example 
      *> Author: 
      *>   Brian Tiffin
      *> Colophon:
      *>   A cobweb-gtk example
      *>   Date: 20130308, 20140826
      *>   Copyright (c) 2014, Brian Tiffin
      *>   License: GPL 3.0 (or greater)
      *> Purpose:
      *>   demonstration of GNU Cobol functional GTK
      *> Screenshot:
      *> image:cobweb-gui.png
      *> Synopsis:
      *> |dotfile cobweb-gui.dot
      *> Tectonics:
      *>   cobc -m -g -debug cobweb-gtk.cob voidcall.c `pkg-config --libs gtk+-3.0`
      *>   LD_RUN_PATH=. cobc -x -g -debug cobweb-gui.cob cobweb-gtk.so
      *><* =====================
      *><* cobweb-gui usage guide
      *><* =====================
      *><* .. sidebar:: Table of Contents
      *><*
      *><*     .. contents:: :local:
      *><*
      *><* :Author:    Brian Tiffin
      *><* :Date:      30-Aug-2014
      *><* :Rights:    Copyright (c) 2008, Brian Tiffin.
      *><*             GNU FDL License.
      *><* :Purpose:   Extract usage document lines from COBOL sources.
      *><*             Using GNU Cobol 2.0.
      *><* :Tectonics: make
      *><* :Docgen:    $ ./ocdoc cobweb-gui.cob ocdoc.rst cobweb-gui.html skin.css
      *><*
      *><* ------------
      *><* Command line
      *><* ------------
      *><* *cobweb-gui* runs two basic tests.  GTKBuilder, and GTKWindow
      *><*
      *><* -----------
      *><* Source code
      *><* -----------
      *><* `Download cobweb-gui.cob
      *><+ <https://sourceforge.net/p/open-cobol/contrib/HEAD/tree/trunk/tools/cobweb/cobweb-gtk/>`_
      *><* `See cobwebgtk API
      *><+ <http://peoplecards.ca/cobweb/cobweb-gtk/index.html>`_
      *><*
      *><! This is not extracted. Reminder of how to include source
      *><! .. include:: ocdoc.cob
      *><!    :literal:
      *>  SOURCE
id     identification division.
       program-id. cobweb-gui.
       environment division.
       configuration section.
udf    repository.
           function new-builder
           function new-window 
           function new-box
           function new-label
           function new-entry
           function new-textview
           function new-button
           function new-image
           function new-spinner
           function new-vte
           function signal-attach
           function builder-signal-attach
           function builder-get-object
           function entry-get-text
           function entry-set-text
           function textview-get-text
           function textview-set-text
           function gtk-go
           function all intrinsic.

io     input-output section.
       file-control.
           select optional sample-data
           assign to "cobweb-gui-sample-data.txt"
           organization is sequential
           status is sample-data-status
           .

data   data division.
       file section.
       fd sample-data.
          01 some-80-characters    pic x(80).

       working-storage section.
       01 sample-data-status       pic 99.

       01 TOPLEVEL             usage binary-long value 0.
       01 HORIZONTAL           usage binary-long value 0.
       01 VERTICAL             usage binary-long value 1.

       01 newline              pic x value x"0a".
       01 extraneous           pic x(8).

       01 gtk-builder-data                         external.
          05 gtk-builder       usage pointer.
          05 gtk-builtwindow   usage pointer.
          05 filler            usage binary-long.
       01 builder-connect      usage binary-long value 0.

       01 gtk-window-data.
          05 gtk-window        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 width-hint           usage binary-long value 640.
       01 height-hint          usage binary-long value 480.

       01 gtk-container-data.
          05 gtk-container     usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 orientation          usage binary-long.
       01 spacing              usage binary-long value 8.
       01 homogeneous          usage binary-long value 0.

       01 gtk-box-data.
          05 gtk-box           usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-label-data.
          05 gtk-label         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-entry-data                              external.
          05 gtk-entry         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 entry-chars          usage binary-long value 10.

       01 gtk-button-data.
          05 gtk-button        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-button-box-data.
          05 gtk-button-box    usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-image-data.
          05 gtk-image         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-spinner-data.
          05 gtk-spinner       usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-vte-data.
          05 gtk-vte           usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 vte-cols             usage binary-c-long value 80.
       01 vte-rows             usage binary-c-long value 24.
       
       01 gtk-verticalbox-data.
          05 gtk-verticalbox   usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-sample-entry-data.
          05 gtk-sample-entry  usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 venue                pic x(8).
          88 broadway              values "broadway", "BROADWAY".

code   procedure division.

       >>SOURCE FORMAT IS FREE
    
      *> read some data for a text entry pre-fill
       open input sample-data
       if sample-data-status less than 10 then
           read sample-data end-read
       end-if
       close sample-data

      *> Main window and top level container
       move new-window("cobweb-gui", TOPLEVEL, width-hint, height-hint) to gtk-window-data
       move new-box(gtk-window, VERTICAL, spacing, homogeneous) to gtk-container-data
       
      *> First box, across
       move new-box(gtk-container, HORIZONTAL, spacing, homogeneous) to gtk-box-data
       move new-image(gtk-box, "blue66.png") to gtk-image-data
       move new-label(gtk-box, "And?") to gtk-label-data
       move new-entry(gtk-box, entry-chars, "cobweb-entry-activated") to gtk-entry-data
       move new-box(gtk-box, VERTICAL, spacing, homogeneous) to gtk-button-box-data
       move new-button(gtk-button-box, "expedite", "cobweb-button-clicked") to gtk-button-data
       move new-button(gtk-button-box, "process", "cobweb-button-clicked") to gtk-button-data

      *> Other box, down
       move new-box(gtk-container, VERTICAL, spacing, homogeneous) to gtk-verticalbox-data
       move new-label(gtk-verticalbox, "sample data") to gtk-label-data
       move 80 to entry-chars
       move new-entry(gtk-verticalbox, entry-chars, "cobweb-entry-activated") to gtk-sample-entry-data 
       move new-vte(gtk-verticalbox, "/home/btiffin/lang/cobol/cobweb/gtk/colours-tui", vte-cols, vte-rows) to gtk-vte-data

      *> prefill the and box with a note
       move entry-set-text(gtk-entry, "type here") to extraneous

      *> prefill the sample entry with the data read from the sample file
       move entry-set-text(gtk-sample-entry, some-80-characters) to extraneous

      *> GTK+ event loop now takes over       
       move gtk-go(gtk-window) to extraneous

       display
           "GNU Cobol: first GTK main eventloop terminated normally"
           upon syserr
       end-display

      *> ********************************************************
      *> And then a gtk-builder test
       move new-builder("cobweb-sample.xml", builder-connect)
         to gtk-builder-data

      *> attach handlers
       move builder-signal-attach(
           gtk-builder, "about_menu_item", "activate", "help-about")
         to extraneous
       move builder-signal-attach(
           gtk-builder, "save_menu_item", "activate", "see-textview")
         to extraneous

       move textview-set-text(builder-get-object(
           gtk-builder, "text_view") some-80-characters)
         to extraneous
           
      *> GTK+ event loop takes over, again       
      *> move gtk-go(gtk-builtwindow) to extraneous

       display
           "GNU Cobol: builder GTK main eventloop terminated normally"
           upon syserr
       end-display

      *> paying homage (to an insider joke on LinkedIn)
       accept venue from environment "GDK_BACKEND" end-accept
       if broadway then
           display "Ken sends his regards" upon syserr end-display
       end-if

       >>SOURCE FORMAT IS FIXED

done   goback.
       end program cobweb-gui.
      *>****

      *> ********************************************************
      *> Callback event handlers 
      *> ********************************************************
       
       REPLACE ==FIELDSIZE== BY ==80==.

      *>****S* cobweb/cobweb-gui-button-clicked [demo]
      *> Purpose:
      *>   application layer button "clicked" events
      *> SOURCE
id     identification division.
       program-id. cobweb-button-clicked.

       environment division.
       configuration section.
       repository.
           function entry-get-text
           function all intrinsic.

       data division.
       working-storage section.
       01 gtk-entry-data                                     external.
          05 gtk-entry         usage pointer. 
       01 the-text-entry       pic x(FIELDSIZE).

       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

       procedure division using by value gtk-widget gtk-data.

      *> get the text entry widget data, from the button callback
       move entry-get-text(gtk-entry) to the-text-entry        
       display trim(the-text-entry) " (via button)" end-display

done   goback.
       end program cobweb-button-clicked.
      *>****
      
      *>****S* cobweb/cobweb-gui-entry-activated [demo]
      *> Purpose:
      *>   application layer text entry "activate" events
      *> SOURCE
id     identification division.
       program-id. cobweb-entry-activated.

       environment division.
       configuration section.
       repository.
           function entry-get-text
           function all intrinsic.

       data division.
       working-storage section.
       01 the-text-entry       pic x(FIELDSIZE).
     
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

       procedure division using by value gtk-widget gtk-data.

      *> access the external, sample data text entry.
       move entry-get-text(gtk-widget) to the-text-entry        
       display the-text-entry end-display
           
done   goback.
       end program cobweb-entry-activated.
      *>****

      *> ********************************************************
      *> demo/test functions
      *> ********************************************************
       
      *>****T* cobweb/help-about [demo]
      *> Purpose:
      *>   Display an application Help/About dialog box
      *> SOURCE
id     identification division.
       program-id. help-about.

data   data division.
       working-storage section.
       01 gtk-window-data                external.
          05 gtk-window        usage pointer.

       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division using by value gtk-widget gtk-data.   

       call "gtk_show_about_dialog" using
           by value gtk-window
           by content
               z"version", z"0.1",
               z"comments", z"GNU Cobol functional GTK+"
               z"copyright", z"Copyright (c) 2014, Brian Tiffin"
               z"website",
                   z"http://www.peoplecards.ca/cobweb/cobweb-gtk/",
               z"program-name", z"cobweb-gui",
               z"logo-icon-name", z"gtk-dialog-info",
           by reference null
       end-call
 
done   goback.
       end program help-about.
      *>****
          

      *>****T* cobweb/see-textview [demo]
      *> SOURCE
id     identification division.
       program-id. see-textview.

       environment division.
       configuration section.
       repository.
           function textview-get-text
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-builder-data                              external.
          05 gtk-builder       usage pointer.
          05 gtk-builtwindow   usage pointer.
       01 gtk-textview         usage pointer.

       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division using by value gtk-widget gtk-data.   

       call "gtk_builder_get_object" using
           by value gtk-builder
           by content concatenate(trim("text_view"), x"00")
           returning gtk-textview
       end-call
       display trim(textview-get-text(gtk-textview)) end-display
 
done   goback.
       end program see-textview.
      *>****

