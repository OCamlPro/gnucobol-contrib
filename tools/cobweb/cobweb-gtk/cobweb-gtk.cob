GNU    >>SOURCE FORMAT IS FIXED
Cobol *>
      *>****L* cobweb/cobweb-gtk [0.2]
      *> Author:
      *>   Brian Tiffin
      *> Colophon:
      *>   Part of the GNU Cobol free software project
      *>   Copyright (C) 2014, Brian Tiffin
      *>   Date      20130308
      *>   Modified  20141003
      *>   License   GNU General Public License, GPL, 3.0 or greater
      *>   Documentation licensed GNU FDL, version 2.1 or greater
      *>   HTML Documentation thanks to ROBODoc --cobol
      *> Purpose:
      *> GNU Cobol functional bindings to GTK+
      *> Main module includes paperwork output and self test
      *> Synopsis:
      *> |dotfile cobweb-gtk.dot
      *> |html <br />
      *> Functions include
      *> |exec cobcrun cobweb-gtk >cobweb-gtk.repository
      *> |html <pre>
      *> |copy cobweb-gtk.repository
      *> |html </pre>
      *> |exec rm cobweb-gtk.repository
      *> Tectonics:
      *>   cobc -v -b -g -debug cobweb-gtk.cob voidcall_gtk.c
      *>        `pkg-config --libs gtk+-3.0` -lvte2_90 -lyelp
      *>   robodoc --cobol --src ./ --doc cobwebgtk --multidoc --rc robocob.rc --css cobodoc.css
      *>   cobc -E -Ddocpass cobweb-gtk.cob
      *>   make singlehtml  # once Sphinx set up to read cobweb-gtk.i
      *> Example:
      *>  COPY cobweb-gtk-preamble.
      *>  procedure division.
      *>  move TOP-LEVEL to window-type
      *>  move 640 to width-hint
      *>  move 480 to height-hint
      *>  move new-window("window title", window-type,
      *>      width-hint, height-hint)
      *>    to gtk-window-data
      *>  move gtk-go(gtk-window) to extraneous
      *>  goback.
      *> Screenshot:
      *> image:cobweb-gtk1.png
      *> Source:
       REPLACE ==FIELDSIZE== BY ==80==
               ==AREASIZE==  BY ==32768==
               ==FILESIZE==  BY ==1045876==.

id     identification division.
       program-id. cobweb-gtk.

       environment division.
       configuration section.
       repository.
           function new-builder
           function new-window 
           function new-scrolled-window 
           function new-box
           function new-button-box
           function new-frame
           function new-menu-bar
           function new-menu
           function new-menu-item 
           function new-statusbar
           function new-image
           function new-label
           function new-entry
           function new-textview
           function new-button
           function new-check-button
           function new-radio-button
           function new-link-button
           function new-color-button
           function new-file-chooser-button
           function new-separator
           function new-spinner
           function new-yelp
           function new-vte
           function rundown-signals
           function signal-attach
           function builder-signal-attach
           function builder-get-object
           function textview-set-text
           function statusbar-push
           function statusbar-pop
           function file-contents
           function gtk-go
           function all intrinsic.

data   data division.
       working-storage section.

      *> include the bank of anonymous widgets      
       COPY cobweb-gtk-widgets.

       01 HORIZONTAL           usage binary-long value 0.
       01 VERTICAL             usage binary-long value 1.

       01 ETCHED-UP            usage binary-long value 3.

       01 FILE-CHOOSER-OPEN    usage binary-long value 0.
       01 FILE-CHOOSER-SELECT-FOLDER usage binary-long value 3.

       01 newline              pic x value x"0a".
       01 extraneous           usage binary-long.

       01 gtk-expand           usage binary-long             external.
       01 gtk-fill             usage binary-long             external.
       01 gtk-padding          usage binary-long             external.

       01 gtk-builder-data                                   external.
          05 gtk-builder       usage pointer.
          05 gtk-builtwindow   usage pointer.
          05 filler            usage binary-long.
       01 builder-connect      usage binary-long value 0.
 
       01 GTK-WINDOW-TOPLEVEL  usage binary-long value 0.
       01 gtk-window-data                                    external.
          05 gtk-window        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 width-hint           usage binary-long value 800.
       01 height-hint          usage binary-long value 256.

       01 gtk-box-data.
          05 gtk-box           usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 orientation          usage binary-long.
       01 spacing              usage binary-long value 0.
       01 homogeneous          usage binary-long value 0.

       01 gtk-button-box-data.
          05 gtk-button-box    usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 style                usage binary-long value 0.

       01 gtk-scrolled-window-data                      external.
          05 gtk-scrolled-window   usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-frame-data.
          05 gtk-frame         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-label-data.
          05 gtk-label         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-entry-data.
          05 gtk-entry         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
       01 entry-chars          usage binary-long value 8.
       01 margin-start         usage binary-long value 8.
       01 margin-end           usage binary-long value 8.

       01 gtk-button-data                     external.
          05 gtk-button        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-check-button-data                external.
          05 gtk-check-button  usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-link-button-data.
          05 gtk-link-button   usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-color-button-data.
          05 gtk-color-button  usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-image-data.
          05 gtk-image         usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-statusbar-data.
          05 gtk-statusbar     usage pointer.
          05 filler            usage pointer.
          05 statusbar-context usage binary-long.

       01 gtk-spinner-data.
          05 gtk-spinner       usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-separator-data.    
          05 gtk-separator     usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 gtk-vte-data.
          05 gtk-vte           usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 vte-cols             usage binary-c-long value 24.
       01 vte-rows             usage binary-c-long value 11.

       01 gtk-yelp-data.
          05 gtk-yelp          usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.

       01 file-length          usage binary-long.
       01 error-code           usage binary-long.

       01 cli                  pic x(16).
          88 testing           values "test", "testing", "check".

code   procedure division.
       display
           "      *> cobweb-gtk UDF repository"
       end-display
       display
           "       repository."                                newline
           "           function new-builder"                   newline
           "           function new-window"                    newline
           "           function new-scrolled-window"           newline
           "           function new-box"                       newline
           "           function new-button-box"                newline
           "           function new-frame"                     newline
           "           function new-menu-bar"                  newline
           "           function new-menu"                      newline
           "           function new-menu-item"                 newline
           "           function new-statusbar"                 newline
           "           function new-image"                     newline
           "           function new-label"                     newline
           "           function new-entry"                     newline
           "           function new-button"                    newline
           "           function new-check-button"              newline
           "           function new-radio-buton"               newline
           "           function new-link-buton"                newline
           "           function new-color-buton"               newline
           "           function new-file-chooser-button"       newline
           "           function new-separator"                 newline
           "           function new-spinner"                   newline
           "           function new-yelp"                      newline
           "           function new-vte"                       newline
           "           function new-textview"                  newline
           "           function rundown-signals"               newline
           "           function signal-attach"                 newline
           "           function builder-signal-attach"         newline
           "           function builder-get-object"            newline
           "           function show-widget"                   newline
           "           function hide-widget"                   newline
           "           function set-sensitive-widget"          newline
           "           function entry-get-text"                newline
           "           function entry-set-text"                newline
           "           function textview-get-text"             newline
           "           function textview-set-text"             newline
           "           function statusbar-push"                newline
           "           function statusbar-pop"                 newline
           "           function file-contents"                 newline
           "           function gtk-go"                        newline
           "           function all intrinsic."
       end-display

      *> cobcrun cobweb-gtk testing   - triggers the library self tests
       accept cli from command-line end-accept

       if testing then
          *> quick file read test
           display
               trim(file-contents("README", file-length, error-code))
           end-display
           display error-code ", " file-length end-display

          *>
          *> test basic windowing using the anonymous widget pile
          *>
           move 32 to total-widgets
 
           move 4 to spacing
           move 2 to gtk-padding
           move 0 to gtk-expand
           move 0 to gtk-fill

           move new-window("cobweb-gtk", GTK-WINDOW-TOPLEVEL,
                width-hint, height-hint)
             to widget-record(1)

           move 0 to homogeneous
           move new-box(widget(1), VERTICAL, spacing, homogeneous)
             to widget-record(7)

           move new-menu-bar(widget(7))
             to widget-record(17)
           move new-menu(widget(17), "_File")
             to widget-record(18)
           move new-menu-item(widget(18), "_Open",
                "cobweb-gtk-button-clicked")
             to widget-record(19)
           move new-menu-item(widget(18), "Quit",
                "cobweb-close")
             to widget-record(20)

           move new-menu(widget(17), "_Help")
             to widget-record(21)
           move new-menu-item(widget(21), "_About",
                "help-about-cobweb")
             to widget-record(22)

           move 1 to homogeneous
           move new-box(widget(7), HORIZONTAL, spacing, homogeneous)
             to widget-record(2)

           move new-frame(widget(2), "GTK+ frame", ETCHED-UP)
             to widget-record(3)
           move new-scrolled-window(widget(3), NULL, NULL)
             to widget-record(4)

           move new-separator(widget(2), VERTICAL) to widget-record(12)

           move new-image(widget(2), "blue66.png") to widget-record(5)

           move new-link-button(widget(2),
               "http://sourceforge.net/p/open-cobol/discussion",
               "GnuCOBOL")
             to widget-record(13) 

           move 1 to gtk-expand gtk-fill           
           move new-scrolled-window(widget(2), NULL, NULL)
             to widget-record(15)
           move new-yelp(widget(15), "cobodoc/index.html")
             to widget-record(16)

           move 0 to gtk-expand gtk-fill           
           move new-file-chooser-button(widget(2),
               "Test file chooser",
               FILE-CHOOSER-OPEN,
               "./cobweb-gtk.cob")
             to widget-record(14) 

          *> vbox for radio buttons
           move new-box(widget(2), VERTICAL, spacing, homogeneous)
             to widget-record(8)

          *> There is a sliding pointer dance here.
          *>   The first radio button sets a group, then following
          *>   radio buttons are linked together
           set extra-pointer(9) to NULL
           move new-radio-button(widget(8), extra-pointer(9),
               "First Radio", "cobweb-gtk-button-clicked")
             to widget-record(9)
           move new-radio-button(widget(8), extra-pointer(9),
               "Radio Two", "cobweb-gtk-button-clicked")
             to widget-record(10)
           move new-radio-button(widget(8), extra-pointer(10),
               "Third Radio", "cobweb-gtk-button-clicked")
             to widget-record(11)

           move new-statusbar(widget(7)) to widget-record(6)

           *> push and pop need the extra-int, pass the whole record
           move statusbar-push(widget-record(6), "Status Message")
             to extraneous
           move statusbar-push(widget-record(6), "Hidden Message")
             to extraneous
           move statusbar-pop(widget-record(6)) to extraneous

          *> hand over control to GTK+ main loop
           move gtk-go(widget(1)) to extraneous

          *> Control can pass back and forth to COBOL subprograms,
          *>  by event, but control flow stops above, until the
          *>  window is torn down and the event loop exits
           display
               "GNU Cobol: first GTK eventloop terminated normally"
               upon syserr
           end-display

          *>
          *> test basic windowing with named widget records
          *>
           move 8 to spacing
           move 0 to homogeneous

           move new-window("cobweb-gtk", GTK-WINDOW-TOPLEVEL,
                width-hint, height-hint)
             to gtk-window-data
           move new-box(gtk-window, HORIZONTAL, spacing, homogeneous)
             to gtk-box-data

           move new-frame(gtk-box, "GTK+ frame", ETCHED-UP)
             to gtk-frame-data
           move new-scrolled-window(gtk-frame, NULL, NULL)
             to gtk-scrolled-window-data

           move new-image(gtk-box, "blue66.png")
             to gtk-image-data
           move new-label(gtk-box, "Label")
             to gtk-label-data

           move new-entry(gtk-box, entry-chars,
               "cobweb-gtk-entry-activated")
             to gtk-entry-data

      *>     move new-button-box(gtk-box, HORIZONTAL, style)
      *>       to gtk-button-box-data
           move new-button(gtk-box, "Button",
               "cobweb-gtk-button-clicked")
             to gtk-button-data
           move new-check-button(gtk-box, "Check", 0
               "cobweb-gtk-check-button-clicked")
             to gtk-check-button-data

           move new-vte(gtk-scrolled-window, "/bin/sh",
               vte-cols, vte-rows)
             to gtk-vte-data

           move new-separator(gtk-box, VERTICAL)
             to gtk-separator-data

           move new-spinner(gtk-box)
             to gtk-spinner-data

           move new-color-button(gtk-box, NULL)
             to gtk-color-button-data

          *> start up another gtk main loop    
           move gtk-go(gtk-window) to extraneous
    
           display
               "GNU Cobol: second GTK eventloop terminated normally"
               upon syserr
           end-display

          *>          
          *> Demonstrate GTKBuilder automation
          *> In this case, using the sample included in the GTK+ Builder
          *>   tutorial by Micah Carrick 
          *>
           move new-builder("cobweb-sample.xml", builder-connect)
             to gtk-builder-data
    
          *> attach handlers
           move builder-signal-attach(
               gtk-builder, "about_menu_item", "activate",
                   "help-about-gtk")
             to extraneous
           move builder-signal-attach(
               gtk-builder, "save_menu_item", "activate",
                   "see-textview-gtk")
             to extraneous
    
          *> set some initial text
           move textview-set-text(
               builder-get-object(gtk-builder, "text_view"),
               "Display this text" & x"0a" & "by clicking File/Save")
             to extraneous
    
            move gtk-go(gtk-builtwindow) to extraneous
           
            display
                "GNU Cobol: builder GTK eventloop terminated normally"
                upon syserr
            end-display
       end-if

done   goback.
       end program cobweb-gtk.
      *>****

      *> ********************************************************
      *> Default callback event handlers 
      *> ********************************************************
       
      *>****S* cobweb/cobweb-delete-event [0.2]
      *> Purpose:
      *>   application layer default GTK rundown handler
      *>   Returns false, allowing window close
      *> Source:
id     identification division.
       program-id. cobweb-delete-event.

       data division.
       working-storage section.
       01 working-flag         usage binary-long value 0.

       linkage section.
       01 gtk-widget           usage pointer.
       01 gdk-event            usage pointer.
       01 gtk-data             usage pointer.
       01 the-flag             usage binary-long.

       procedure division using
           gtk-widget
           gdk-event
           gtk-data
         returning the-flag.

      *> return false, allow the destroy signal              
       set address of the-flag to address of working-flag

done   goback.
       end program cobweb-delete-event.
      *>****


      *>****S* cobweb/cobweb-gtk-button-clicked [0.2]
      *> Purpose:
      *>   default button click handler
      *>   in this case, self-test, hide/unhide the check-button
      *> Input:
      *>   gtk-widget pointer
      *>   gtk-data pointer
      *> Source:
id     identification division.
       program-id. cobweb-gtk-button-clicked.

       data division.
       working-storage section.
       01 gtk-check-button-data                external.
          05 gtk-check-button   usage pointer.
       01 hide-state           usage binary-long.
       COPY cobweb-gtk-widgets.
       
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

       procedure division using
           by value gtk-widget
           gtk-data.

       display
           "clicked " gtk-widget " with " gtk-data
           " and " hide-state
           " and " widget(1)
           upon syserr
       end-display


      *> self test, hide and unhide the check-button on click
       if gtk-check-button is not equal null then
           if hide-state is zero then
               move 1 to hide-state
               call "gtk_widget_hide" using
                   by value gtk-check-button
                   returning omitted
               end-call
           else
               move 0 to hide-state
               call "gtk_widget_show" using
                   by value gtk-check-button
                   returning omitted
               end-call
           end-if
       end-if

done   goback.
       end program cobweb-gtk-button-clicked.
      *>****


      *>****S* cobweb/cobweb-gtk-check-button-clicked [0.2]
      *> Purpose:
      *>   default check-button click handler
      *>   in this case, self-test, enable/disable the button
      *> Input:
      *>   gtk-widget pointer
      *>   gtk-data pointer
      *> Source:
id     identification division.
       program-id. cobweb-gtk-check-button-clicked.

       data division.
       working-storage section.
       01 gtk-button-data                     external.
          05 gtk-button        usage pointer.
       01 gtk-sensitivity      usage binary-long value 0.
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

       procedure division using
           by value gtk-widget
           gtk-data.

       display
           "clicked (check)" gtk-widget " with " gtk-data upon syserr
       end-display

      *> self test, enable the test button on true, grey out on uncheck
      *> when check is on, the button can hide this check-button completely
       call "gtk_toggle_button_get_active" using
           by value gtk-widget
           returning gtk-sensitivity
       end-call
       call "gtk_widget_set_sensitive" using
           by value gtk-button
           by value gtk-sensitivity
       end-call

done   goback.
       end program cobweb-gtk-check-button-clicked.
      *>****
      
       
      *>****S* cobweb/cobweb-gtk-entry-activated [0.2]
      *> Purpose:
      *>   default text entry activate handler
      *> Source:
id     identification division.
       program-id. cobweb-gtk-entry-activated.

       data division.
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

       procedure division using
           by value gtk-widget
           gtk-data.   

       display
           "activated " gtk-widget " with " gtk-data upon syserr
       end-display

done   goback.
       end program cobweb-gtk-entry-activated.
      *>****


      *> ********************************************************
      *> widget functions
      *> ********************************************************
       
      *>****F* cobweb/new-builder [0.2]
      *> Purpose:
      *> Use GTKBuilder to create an entire window and widget set
      *> Input:
      *>   XML layout filename pic x any
      *>   boolean, auto-connect signals or not
      *> Output:
      *>   gtk-builder-record with
      *>   gtk-builder and gtk-window
      *> Source:
id     identification division.
       function-id. new-builder. 

       environment division.
       configuration section.
       repository.
           function rundown-signals
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.
       01 xmlload-status             usage binary-long.

       linkage section.
link   01 builder-xmlfile            pic x any length.
       01 builder-connect            usage binary-long.
       01 gtk-builder-data.
          05 gtk-builder             usage pointer.
          05 gtk-builtwindow         usage pointer.
       
code   procedure division using
           builder-xmlfile
           builder-connect
         returning gtk-builder-data.

       call "gtk_builder_new" returning gtk-builder end-call

       call "gtk_builder_add_from_file" using
           by value gtk-builder
           by content concatenate(trim(builder-xmlfile), x"00")
           by value 0
           returning xmlload-status
       end-call

       call "gtk_builder_get_object" using
           by value gtk-builder
           by content z"window"
           returning gtk-builtwindow
       end-call

      *>
      *> If event handlers are in COBOL, the automatic signal connect
      *>   won't work properly for any void signatures
      *> Always attach the run down signals, just because.
      *>
       if builder-connect not equal 0 then
           call "gtk_builder_connect_signals" using
               by value gtk-builder
               by value 0
               returning omitted
           end-call
       else
          move rundown-signals(gtk-builtwindow) to extraneous
       end-if

done   goback.
       end function new-builder.
      *>****

      *>****F* cobweb/new-window
      *> Purpose:
      *> Define a new top level window.
      *> Input:
      *>   window-title pic x any
      *>   window-type
      *>   width hint
      *>   height hint
      *> Output:
      *>   gtk-window-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/window.png
      *> Source:
id     identification division.
       function-id. new-window. 

       environment division.
       configuration section.
       repository.
           function rundown-signals
           function all intrinsic.

       data division.
data   working-storage section.
       01 GTK-WINDOW-TOPLEVEL        usage binary-long value 0.
       01 extraneous                 usage binary-long.
       01 inner-border               usage binary-long value 6.

       linkage section.
link   01 window-title               pic x any length.
       01 window-type                usage binary-short.
       01 width-hint                 usage binary-long.
       01 height-hint                usage binary-long.
       01 gtk-window-data.
          05 gtk-window              usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.
 
code   procedure division using
           window-title
           window-type
           width-hint
           height-hint
         returning gtk-window-data.

      *> Start up the GIMP/Gnome Tool Kit
       call "gtk_init" using
           by value 0                          *> argc int
           by value 0                          *> argv pointer to pointer
           returning omitted                   *> void return, requires cobc 2010+
           on exception
               display
                   "gtk_init link error, see pkg-config --libs gtk+-3.0"
                   upon syserr
               end-display
bail           stop run returning 1
       end-call

      *> Create a new window, returning handle as pointer
       call "gtk_window_new" using 
           by value window-type                *> it's a zero or a 1 popup
           returning gtk-window                *> and remember the handle
       end-call

      *> More fencing, skimped on after this early test
       if gtk-window equal null then
           display
               "GTK service error; gtk_window_new NULL"
               upon syserr
           end-display
bail       stop run returning 1
       end-if

      *> Hint for window sizing
       call "gtk_window_set_default_size" using
           by value gtk-window                 *> by value is used to get the C address
           by value width-hint
           by value height-hint
           returning omitted                   *> another void
       end-call

      *> And some inner margin space
       call "gtk_container_set_border_width" using
           by value gtk-window
           by value inner-border
           returning omitted
       end-call

      *> Put in the title
       call "gtk_window_set_title" using
           by value gtk-window                 *> pass the C handle
           by content concatenate(trim(window-title), x"00")
           returning omitted
       end-call

      *> Connect rundown signals.
       move rundown-signals(gtk-window) to extraneous

done   goback.
       end function new-window.
      *>****
          

      *>****F* cobweb/new-box
      *> Purpose:
      *> Define a new container
      *> Input:
      *>   gtk-window/widget pointer
      *>   orientation 0 across, 1 up down
      *>   spacing between contained items
      *>   do all the widgets try and keep the same size
      *> Output:
      *>   gtk-box-record, first field pointer
      *> Source:
id     identification division.
       function-id. new-box. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-expand                 usage binary-long       external.
       01 gtk-fill                   usage binary-long       external.
       01 gtk-padding                usage binary-long       external.

       01 is-toplevel                usage binary-long.

link   linkage section.
       01 gtk-widget                 usage pointer.
       01 orientation                usage binary-long.
       01 spacing                    usage binary-long.
       01 homogeneous                usage binary-long.
       01 gtk-box-data.
          05 gtk-box                 usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-widget                         *> can be a window, once
           orientation
           spacing
           homogeneous
         returning gtk-box-data.

      *> Define a container. Boxey, but nice.
       call "gtk_box_new" using
           by value orientation
           by value spacing                    *> pixels between widgets
           returning gtk-box
       end-call

       call "gtk_box_set_homogeneous" using
           by value gtk-box
           by value homogeneous                *> TRUE for equal size
           returning omitted
       end-call

      *> Add the box to the window/widget
       call "gtk_widget_is_toplevel" using
           by value gtk-widget
           returning is-toplevel
       end-call
       if is-toplevel equal 0 then
           call "gtk_box_pack_start" using
               by value gtk-widget
               by value gtk-box
               by value gtk-expand
               by value gtk-fill
               by value gtk-padding
               returning omitted
           end-call
       else
           call "gtk_container_add" using
               by value gtk-widget
               by value gtk-box
               returning omitted
           end-call
       end-if

done   goback.
       end function new-box.
      *>****
          

      *>****F* cobweb/new-button-box
      *> Purpose:
      *> Define a new button box
      *> Input:
      *>   gtk-window/widget pointer
      *>   orientation; 0 across, 1 up down
      *>   style; spread, edge, start, end, center, expand 
      *> Output:
      *>   gtk-button-box-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/button.png
      *> Source:
id     identification division.
       function-id. new-button-box. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-expand                 usage binary-long       external.
       01 gtk-fill                   usage binary-long       external.
       01 gtk-padding                usage binary-long       external.

       01 is-toplevel                usage binary-long.
       01 spacing                    usage binary-long value 1.

link   linkage section.
       01 gtk-widget                 usage pointer.
       01 orientation                usage binary-long.
       01 style                      usage binary-long.
       01 gtk-button-box-data.
          05 gtk-button-box          usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-widget
           orientation
           style  
         returning gtk-button-box-data.

      *> Define a new button box
       call "gtk_button_box_new" using
           by value orientation
           returning gtk-button-box
       end-call

      *> Set the layout style
       call "gtk_button_box_set_layout" using
           by value gtk-button-box
           by value style
           returning omitted
       end-call
       call "gtk_box_set_spacing" using
           by value gtk-button-box
           by value spacing
           returning omitted
       end-call

      *> Add the button box to the window/widget
       call "gtk_widget_is_toplevel" using
           by value gtk-widget
           returning is-toplevel
       end-call
       if is-toplevel equal 0 then
           call "gtk_box_pack_start" using
               by value gtk-widget
               by value gtk-button-box
               by value gtk-expand
               by value gtk-fill
               by value gtk-padding
               returning omitted
           end-call
       else
           call "gtk_container_add" using
               by value gtk-widget
               by value gtk-button-box
               returning omitted
           end-call
       end-if

done   goback.
       end function new-button-box.
      *>****
          

      *>****F* cobweb/new-frame
      *> Purpose:
      *> Define a new framed container
      *> Input:
      *>   gtk-container pointer
      *>   frame-label pic x any
      *> Output:
      *>   gtk-frame-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/frame.png
      *> Source:
id     identification division.
       function-id. new-frame. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-container              usage pointer.
       01 the-label                  pic x any length.
       01 shadow-type                usage binary-long.
       01 gtk-frame-data.
          05 gtk-frame               usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           the-label
           shadow-type
         returning gtk-frame-data.

      *> Define a new frame
       call "gtk_frame_new" using
           by content concatenate(trim(the-label), x"00")
           returning gtk-frame
       end-call

       if gtk-frame not equal null then
          *> set the shadowing
           call "gtk_frame_set_shadow_type" using
               by value gtk-frame
               by value shadow-type
               returning omitted
           end-call

          *> Add the frame to the window
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-frame
               returning omitted
           end-call
       end-if

done   goback.
       end function new-frame.
      *>****

          
      *>****F* cobweb/new-menu-bar
      *> Purpose:
      *> Define a new menu bar
      *> Input:
      *>   gtk-container pointer
      *> Output:
      *>   gtk-menu-bar-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/menubar.png
      *> Source:
id     identification division.
       function-id. new-menu-bar. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 expanding                  usage binary-long.
       01 filling                    usage binary-long.
       01 pad                        usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 gtk-menu-bar-data.
          05 gtk-menu-bar            usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
         returning gtk-menu-bar-data.

      *> Define a new menu bar
       call "gtk_menu_bar_new"
           returning gtk-menu-bar
       end-call

       move 0 to expanding filling
       move 3 to pad
       if gtk-menu-bar not equal null then
          *> Add the frame to the window
           call "gtk_box_pack_start" using
               by value gtk-container
               by value gtk-menu-bar
               by value expanding
               by value filling
               by value pad
               returning omitted
           end-call
       end-if

done   goback.
       end function new-menu-bar.
      *>****


      *>****F* cobweb/new-menu
      *> Purpose:
      *> Define a new menu
      *> Input:
      *>   gtk-container pointer
      *>   top-level-label pic x any
      *> Output:
      *>   gtk-menu-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/menubar.png
      *> Source:
id     identification division.
       function-id. new-menu. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 main-item                  usage pointer.
       
link   linkage section.
       01 gtk-menu-bar               usage pointer.
       01 menu-label                 pic x any length.
       01 gtk-menu-data.
          05 gtk-menu                usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-menu-bar
           menu-label  
         returning gtk-menu-data.

      *> Define a new menu
       call "gtk_menu_new"
           returning gtk-menu
       end-call

      *> Create the submenu association
       call "gtk_menu_item_new_with_mnemonic" using
           by content concatenate(trim(menu-label), x"00")
           returning main-item
       end-call

       if main-item not equal null then
           call "gtk_menu_item_set_submenu" using
               by value main-item
               by value gtk-menu
           end-call
       end-if

       if gtk-menu not equal null then
          *> Add the menu to the menu-bar
           call "gtk_menu_shell_append" using
               by value gtk-menu-bar
               by value main-item
               returning omitted
           end-call
       end-if

done   goback.
       end function new-menu.
      *>****


      *>****F* cobweb/new-menu-item
      *> Purpose:
      *> Define a new menu-item
      *> Input:
      *>   gtk-menu pointer
      *>   item-label pic x any, underscore before letter for Alt-key
      *>   callback-name pic x any, attached to "activate"
      *> Output:
      *>   gtk-menu-item-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/menubar.png
      *> Source:
id     identification division.
       function-id. new-menu-item. 

       environment division.
       configuration section.
       repository.
           function signal-attach
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-menu                   usage pointer.
       01 mnemonic                   pic x any length.
       01 entry-callback             pic x any length.
       01 gtk-menu-item-data.
          05 gtk-menu-item           usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-menu
           mnemonic
           entry-callback  
         returning gtk-menu-item-data.

      *> Define a new menu item
       call "gtk_menu_item_new_with_mnemonic" using
           by content concatenate(trim(mnemonic), x"00")
           returning gtk-menu-item
       end-call

       if gtk-menu-item not equal null then
          *> Add the item to the menu
           call "gtk_menu_shell_append" using
               by value gtk-menu
               by value gtk-menu-item
               returning omitted
           end-call

          *> Connect a signal to "activate".
           move signal-attach(gtk-menu-item, "activate", entry-callback)
             to extraneous
       end-if

done   goback.
       end function new-menu-item.
      *>****


      *>****F* cobweb/new-statusbar
      *> Purpose:
      *> Define a new status bar
      *> Input:
      *>   gtk-window/widget pointer to container
      *> Output:
      *>   gtk-statusbar-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/statusbar.png
      *> Source:
id     identification division.
       function-id. new-statusbar.

       environment division.
       configuration section.
       repository.
           function statusbar-push
           function statusbar-pop
           function all intrinsic.

data   data division.
       working-storage section.
       01 context-id                 usage binary-long.

link   linkage section.
       01 gtk-widget                 usage pointer.
       01 gtk-statusbar-data.
          05 gtk-statusbar           usage pointer.
          05 filler                  usage pointer.
          05 statusbar-context       usage binary-long.

code   procedure division using
           gtk-widget
         returning gtk-statusbar-data.

      *> Define a new statusbar, generate a default context
       call "gtk_statusbar_new" returning gtk-statusbar end-call

       call "gtk_statusbar_get_context_id" using
           by value gtk-statusbar
           by content z"cobweb-statusbar"
           returning context-id
       end-call
       move context-id to statusbar-context

      *> Add the statusbar to the container
       call "gtk_container_add" using
           by value gtk-widget
           by value gtk-statusbar
           returning omitted
       end-call

done   goback.
       end function new-statusbar.
      *>****


      *>****F* cobweb/new-scrolled-window
      *> Purpose:
      *> Define a new scrolled-window
      *> Input:
      *>   gtk-container pointer
      *>   horizontal-adjust pointer
      *>   vertical-adjust pointer
      *> Output:
      *>   gtk-scrolled-window-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/scrolledwindow.png
      *> Source:
id     identification division.
       function-id. new-scrolled-window. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 width-hint                 usage binary-long value 240.
       01 height-hint                usage binary-long value 320.
     
link   linkage section.
       01 gtk-container              usage pointer.
       01 horizontal-adjustment      usage pointer.
       01 vertical-adjustment        usage pointer.
       01 gtk-scrolled-window-data.
          05 gtk-scrolled-window     usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           horizontal-adjustment
           vertical-adjustment
         returning gtk-scrolled-window-data.

      *> Define a scrolled-window
       call "gtk_scrolled_window_new" using
           by reference null null
           returning gtk-scrolled-window
       end-call

       call "gtk_scrolled_window_set_min_content_height" using
           by value gtk-scrolled-window
           by value width-hint
           returning omitted
       end-call

       call "gtk_scrolled_window_set_min_content_height" using
           by value gtk-scrolled-window
           by value height-hint
           returning omitted
       end-call

      *> Add the frame to the window
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-scrolled-window
           returning omitted
       end-call

done   goback.
       end function new-scrolled-window.
      *>****
      

      *>****F* cobweb/new-label
      *> Purpose:
      *> Define a label
      *> Input:
      *>   gtk-container pointer
      *>   label-text pic x any
      *> Output:
      *>   gtk-label-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/label.png
      *> Source:
id     identification division.
       function-id. new-label.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-container              usage pointer.
       01 label-text                 pic x any length.
       01 gtk-label-data.
          05 gtk-label               usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           label-text
         returning gtk-label-data.

      *> Add a label
       call "gtk_label_new" using
           by content concatenate(trim(label-text), x"00")
           returning gtk-label
       end-call

      *> Add the label to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-label
           returning omitted
       end-call

done   goback.
       end function new-label.
      *>****
          

      *>****F* cobweb/new-entry
      *> Purpose:
      *> Define a new single line text entry
      *> Input:
      *>   gtk-container pointer
      *>   entry-size integer
      *>   entry-callback
      *> Output:
      *>   gtk-entry-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/entry.png
      *> Source:
id     identification division.
       function-id. new-entry.

       environment division.
       configuration section.
       repository.
           function signal-attach
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-expand                 usage binary-long       external.
       01 gtk-fill                   usage binary-long       external.
       01 gtk-padding                usage binary-long       external.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 entry-chars                usage binary-long.
       01 entry-callback             pic x any length.
       01 gtk-entry-data.
          05 gtk-entry               usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           entry-chars
           entry-callback
         returning gtk-entry-data.

      *> Add a single line text entry
       call "gtk_entry_new" returning gtk-entry end-call

      *> set some properties
       call "gtk_entry_set_width_chars" using
           by value gtk-entry
           by value entry-chars
           returning omitted
       end-call

      *> Add the entry to the container
       call "gtk_box_pack_start" using
           by value gtk-container
           by value gtk-entry
           by value gtk-expand
           by value gtk-fill
           by value gtk-padding
           returning omitted
       end-call

      *> Connect a signal to "activate".
       move signal-attach(gtk-entry, "activate", entry-callback)
         to extraneous

done   goback.
       end function new-entry.
      *>****
          

      *>****F* cobweb/new-textview
      *> Purpose:
      *> Define a multi-line text entry
      *> Input:
      *>   gtk-container pointer
      *>   entry-callback pic x any
      *> Output:
      *>   gtk-textview-record, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/multiline-text.png
      *> Source:
id     identification division.
       function-id. new-textview.

       environment division.
       configuration section.
       repository.
           function signal-attach
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 entry-callback             pic x any length.
       01 gtk-textview-data.
          05 gtk-textview            usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           entry-callback
         returning gtk-textview-data.

      *> Add a multiline text entry
       call "gtk_textview_new" returning gtk-textview end-call

      *> Add the entry to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-textview
           returning omitted
       end-call

      *> Connect activate signal, wrapped in voidcall
       move signal-attach(gtk-textview, "activate", entry-callback)
         to extraneous

done   goback.
       end function new-textview.
      *>****
          

      *>****F* cobweb/new-button
      *> Purpose:
      *> Define a new button.
      *> Input:
      *>   gtk-container
      *>   button-label pic x any
      *>   button-callback pic x any
      *> Output:
      *>   gtk-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/button.png
      *> Source:
id     identification division.
       function-id. new-button.

       environment division.
       configuration section.
       repository.
           function signal-attach 
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 button-label               pic x any length.
       01 button-callback            pic x any length.
       01 gtk-button-data.
          05 gtk-button              usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           button-label
           button-callback
         returning gtk-button-data.

      *> Add a labelled button
       call "gtk_button_new_with_label" using
           by content concatenate(trim(button-label), x"00")
           returning gtk-button
       end-call

      *> Add the button to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-button
           returning omitted
       end-call

      *> Connect handler to clicked
       move signal-attach(gtk-button, "clicked", button-callback)
         to extraneous

done   goback.
       end function new-button.
      *>****
          

      *>****F* cobweb/new-check-button
      *> Purpose:
      *> Define a new check-button.
      *> Input:
      *>   gtk-container
      *>    button-label pic x any
      *>    button-value usage binary-long
      *>    button-callback pic x any
      *> Output:
      *>   gtk-check-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/check-button.png
      *> Source:
id     identification division.
       function-id. new-check-button.

       environment division.
       configuration section.
       repository.
           function signal-attach 
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 button-label               pic x any length.
       01 button-value               usage binary-long.
       01 button-callback            pic x any length.
       01 gtk-check-button-data.
          05 gtk-check-button        usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           button-label
           button-value
           button-callback
         returning gtk-check-button-data.

      *> Add a labelled button
       call "gtk_check_button_new_with_label" using
           by content concatenate(trim(button-label), x"00")
           returning gtk-check-button
       end-call

      *> Set initial value
       call "gtk_toggle_button_set_active" using
           by value gtk-check-button
           by value button-value
           returning omitted
       end-call

      *> Add the button to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-check-button
           returning omitted
       end-call

      *> Connect handler to clicked
       move signal-attach(gtk-check-button, "clicked", button-callback)
         to extraneous

done   goback.
       end function new-check-button.
      *>****
       
       
      *>****F* cobweb/new-radio-button
      *> Purpose:
      *> Define a new radio, group and or button.
      *> The first radio button will create a group
      *>   following buttons are linked to previous in the group
      *>   Link first to null, second to the returned extra-pointer
      *>     third to the return of the second, and so on.
      *> Input:
      *>   gtk-container
      *>   gtk-button-group, NULL for new group
      *>   button-label pic x any
      *>   button-callback pic x any
      *> Output:
      *>   gtk-radio-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/radio-group.png
      *> Source:
id     identification division.
       function-id. new-radio-button.

       environment division.
       configuration section.
       repository.
           function signal-attach 
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 gtk-radio-group            usage pointer.
       01 button-label               pic x any length.
       01 button-callback            pic x any length.
       01 gtk-radio-button-data.
          05 gtk-radio-button        usage pointer.
          05 extra-pointer           usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           gtk-radio-group
           button-label
           button-callback
         returning gtk-radio-button-data.

      *> This might be a new group
       call "gtk_radio_button_new_with_label" using
           by value gtk-radio-group
           by content concatenate(trim(button-label TRAILING), x"00")
           returning gtk-radio-button
       end-call

      *> return the group as part of the record
       call "gtk_radio_button_get_group" using
           by value gtk-radio-button
           returning extra-pointer
       end-call
           
      *> Add the button to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-radio-button
           returning omitted
       end-call

      *> Connect handler to clicked
       move signal-attach(gtk-radio-button, "clicked", button-callback)
         to extraneous

done   goback.
       end function new-radio-button.
      *>****
       
       
      *>****F* cobweb/new-link-button
      *> Purpose:
      *> Define a new url link button. Launch browser on click.
      *> Input:
      *>   gtk-container
      *>   button-uri      pic x any
      *>   button-label    pic x any
      *> Output:
      *>   gtk-link-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/link-button.png
      *> Source:
id     identification division.
       function-id. new-link-button.

       environment division.
       configuration section.
       repository.
           function signal-attach 
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 button-uri                 pic x any length.
       01 button-label               pic x any length.
       01 gtk-link-button-data.
          05 gtk-link-button         usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           button-uri     
           button-label
         returning gtk-link-button-data.

      *> define a new link button
       call "gtk_link_button_new_with_label" using
           by content concatenate(trim(button-uri TRAILING), x"00")
           by content concatenate(trim(button-label TRAILING), x"00")
           returning gtk-link-button
       end-call

       if gtk-link-button not equal null then
          *> Add the button to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-link-button
               returning omitted
           end-call
       end-if

done   goback.
       end function new-link-button.
      *>****
          

      *>****F* cobweb/new-color-button
      *> Purpose:
      *> Define a new color select button. Displays dialog on click.
      *> Input:
      *>   gtk-container
      *>   OPTIONAL gdk-color
      *> Output:
      *>   gtk-color-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/color-button.png
      *> Source:
id     identification division.
       function-id. new-color-button.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 default-color              usage pointer.
       01 gtk-color-button-data.
          05 gtk-color-button        usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           optional default-color
         returning gtk-color-button-data.

       if default-color omitted then
           call "gtk_color_button_new"
               returning gtk-color-button
           end-call
       else
           call "gtk_color_button_new_with_color" using
               by value default-color
               returning gtk-color-button
           end-call
       end-if   

       if gtk-color-button not equal null then
          *> Add the button to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-color-button
               returning omitted
           end-call
       end-if

done   goback.
       end function new-color-button.
      *>****
          

      *>****F* cobweb/new-file-chooser-button
      *> Purpose:
      *> Define a new file selector button. Displays dialog on click.
      *> Input:
      *>   gtk-container
      *>   title pic x any
      *>   mode-value, one of Open, Save, Select folder, Create folder
      *>   default-filespec pic x ant
      *> Output:
      *>   gtk-file-chooser-button-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/file-button.png
      *> Source:
id     identification division.
       function-id. new-file-chooser-button.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 title                      pic x any length.
       01 chooser-mode               usage binary-long.
       01 default-filename           pic x any length.
       01 gtk-file-chooser-button-data.
          05 gtk-file-chooser-button usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           title
           chooser-mode
           default-filename
         returning gtk-file-chooser-button-data.

       call "gtk_file_chooser_button_new" using
           by content concatenate(trim(title), x"00")
           by value chooser-mode
           returning gtk-file-chooser-button
       end-call

       if gtk-file-chooser-button not equal null then
          *> set default name
           call "gtk_file_chooser_set_filename" using
               by value gtk-file-chooser-button
               by content concatenate(trim(default-filename), x"00")
           end-call

          *> Add the button to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-file-chooser-button
               returning omitted
           end-call
       end-if

done   goback.
       end function new-file-chooser-button.
      *>****
          

      *>****F* cobweb/new-separator
      *> Purpose:
      *> Define a new thin line separator, horizonal, vertical
      *> Input:
      *>   gtk-container
      *>   orientation
      *> Output:
      *>   gtk-separator
      *>   image:https://developer.gnome.org/gtk3/stable/separator.png
      *> Source:
id     identification division.
       function-id. new-separator.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-container              usage pointer.
       01 orientation                usage pointer.
       01 gtk-separator-data.   
          05 gtk-separator           usage pointer.
          05 filler                  usage pointer.
          05 filler                  usage binary-long.

code   procedure division using
           gtk-container
           orientation      
         returning gtk-separator-data.

      *> That's it, thay's all.
       call "gtk_separator_new" using
           by value orientation
           returning gtk-separator
       end-call

       if gtk-separator not equal null then
      
          *> Add the divider line to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-separator
               returning omitted
           end-call

done   goback.
       end function new-separator.
      *>****
          

      *>****F* cobweb/new-image
      *> Purpose:
      *> Define a new image.  Various graphic formats supported
      *> Input:
      *>   gtk-container pointer reference 
      *>   graphics file name
      *> Output:
      *>   gtk-image-record reference, first field is pointer
      *>   image:https://developer.gnome.org/gtk3/stable/image.png
      *> Source:
id     identification division.
       function-id. new-image.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 image-filename             pic x any length.
       01 gtk-image-data. 
          05 gtk-image               usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           image-filename
         returning gtk-image-data.

      *> Create an image from file
       call "gtk_image_new_from_file" using
           by content concatenate(trim(image-filename), x"00")
           returning gtk-image
       end-call

      *> Add the image to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-image
           returning omitted
       end-call

done   goback.
       end function new-image.
      *>****
          

      *>****F* cobweb/new-spinner
      *> Purpose:
      *>   Define a new spinner, set it spinning 
      *> Input:
      *>   gtk-container pointer reference
      *> Output:
      *>   gtk-spinner-record reference, first field pointer
      *>   image:https://developer.gnome.org/gtk3/stable/spinner.png
      *> Source:
id     identification division.
       function-id. new-spinner.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

link   linkage section.
       01 gtk-container              usage pointer.
       01 gtk-spinner-data. 
          05 gtk-spinner             usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
         returning gtk-spinner-data.

      *> Create an image from file
       call "gtk_spinner_new"
           returning gtk-spinner
       end-call

      *> Add the image to the container
       call "gtk_container_add" using
           by value gtk-container
           by value gtk-spinner
           returning omitted
       end-call

       *> start spinning
       call "gtk_spinner_start" using
           by value gtk-spinner
           returning omitted
       end-call

done   goback.
       end function new-spinner.
      *>****
          

      *>****F* cobweb/new-yelp
      *> Purpose:
      *> Define a new GNOME help viewer
      *> Input:
      *>   URI pic x any
      *> Output:
      *>   A new yelp widget, with URI preloaded
      *> Source:
id     identification division.
       function-id. new-yelp.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

       01 gtk-expand                 usage binary-long       external.
       01 gtk-fill                   usage binary-long       external.
       01 gtk-padding                usage binary-long       external.

link   linkage section.
       01 gtk-container              usage pointer.
       01 help-url                   pic x any length.
       01 gtk-yelp-data. 
          05 gtk-yelp                usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           help-url
         returning gtk-yelp-data.

      *> Create a Yelp Viewer
       call "yelp_view_new"
           returning gtk-yelp
       end-call

       if gtk-yelp not equal null then
           call "yelp_view_load" using
               by value gtk-yelp
               by content concatenate(trim(help-url), x"00")
               returning omitted
           end-call

          *> Add the yelp view to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-yelp
               returning omitted
           end-call
       end-if

done   goback.
       end function new-yelp.
      *>****

          
      *>****F* cobweb/new-vte
      *> Purpose:
      *> Define a new virtual terminal
      *> Input:
      *>   command to run, columns, rows
      *> Output:
      *>   Given, colours-tui, a compiled GnuCOBOL
      *>   SCREEN SECTION program in an 80x24 vte
      *>   image:cobweb-gui11.png
      *> Source:
id     identification division.
       function-id. new-vte.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

       01 expanding                  usage binary-long value 1.
       01 filling                    usage binary-long value 1.
       01 pad                        usage binary-long value 4.

link   linkage section.
       01 gtk-container              usage pointer.
       01 vte-command                pic x any length.
       01 vte-cols                   usage binary-c-long.
       01 vte-rows                   usage binary-c-long.
       01 gtk-vte-data. 
          05 gtk-vte                 usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           vte-command
           vte-cols
           vte-rows
         returning gtk-vte-data.

      *> Create a virtual terminal
       call "vte_terminal_new"
           returning gtk-vte
       end-call

       if gtk-vte not equal null then
           call "vte_terminal_set_size" using
               by value gtk-vte vte-cols vte-rows
               returning omitted
           end-call
           
          *> Start session with command, in current working dir
           call "vte_terminal_fork_command" using
               by value gtk-vte
               by content concatenate(trim(vte-command), x"00")
               by reference null null z"."
               by value 0 0 0
               returning omitted
           end-call
    
          *> Add the vte to the container
           call "gtk_container_add" using
               by value gtk-container
               by value gtk-vte
               returning omitted
           end-call
       end-if

done   goback.
       end function new-vte.
      *>****


      *>****F* cobweb/new-databox
      *> Purpose:
      *> Define a new databox
      *> Input:
      *>   
      *> Output:
      *>   Given, colours-tui, a compiled GnuCOBOL
      *>   SCREEN SECTION program in an 80x24 vte
      *>   image:cobweb-gui11.png
      *> Source:
id     identification division.
       function-id. new-databox.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous                 usage binary-long.

       01 expanding                  usage binary-long value 1.
       01 filling                    usage binary-long value 1.
       01 pad                        usage binary-long value 4.

link   linkage section.
       01 gtk-container              usage pointer.
       01 vte-command                pic x any length.
       01 vte-cols                   usage binary-c-long.
       01 vte-rows                   usage binary-c-long.
       01 gtk-vte-data. 
          05 gtk-vte                 usage pointer.
          05 filler                  usage pointer.
          05 filler                  binary-long.

code   procedure division using
           gtk-container
           vte-command
           vte-cols
           vte-rows
         returning gtk-vte-data.

      *> Create a virtual terminal
       call "vte_terminal_new"
           returning gtk-vte
       end-call

       if gtk-vte not equal null then
           call "vte_terminal_set_size" using
               by value gtk-vte vte-cols vte-rows
               returning omitted
           end-call
           
          *> Start session with command, in current working dir
           call "vte_terminal_fork_command" using
               by value gtk-vte
               by content concatenate(trim(vte-command), x"00")
               by reference null null z"."
               by value 0 0 0
               returning omitted
           end-call
    
          *> Add the vte to the container
          *> call "gtk_container_add" using
          *>     by value gtk-container
          *>     by value gtk-vte
          *>     returning omitted
          *> end-call

           call "gtk_box_pack_start" using
               by value gtk-container
               by value gtk-vte
               by value expanding
               by value filling
               by value pad
               returning omitted
           end-call
           
       end-if

done   goback.
       end function new-databox.
      *>****


      *> ********************************************************
      *> helper functions
      *> ********************************************************
       
      *>****F* cobweb/signal-attach
      *> Purpose:
      *> Attach a callback handler, wrapped in a void return
      *> Input:
      *>   gtk-widget pointer
      *>   the-event-name pic x any
      *>   the-handler-name pic x any
      *> Source:
id     identification division.
       function-id. signal-attach. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 cobweb-callback            usage program-pointer.
       01 gtk-void-callback          usage program-pointer.
       01 gtk-hand-id                usage pointer.

link   linkage section.
       01 gtk-widget                 usage pointer.
       01 the-trigger                pic x any length.
       01 callback-byname            pic x any length.
       01 extraneous                 usage binary-long.

code   procedure division using
           gtk-widget
           the-trigger
           callback-byname
         returning extraneous.

      *> Connect signal to action, wrapped in voidcall
       set cobweb-callback to entry callback-byname
       set gtk-void-callback to entry "voidcall"

       call "g_signal_connect_data" using
           by value gtk-widget
           by content concatenate(trim(the-trigger), x"00")
           by value gtk-void-callback   *> function call back pointer
           by value cobweb-callback     *> pointer to COBOL proc
           by value 0
           by value 0
           returning gtk-hand-id        *> not null on success
       end-call

       if gtk-hand-id equal null then
           display
               "error: cobweb-gtk, g_signal_connect "
               '"' the-trigger '"'
               " failed"
               upon syserr
           end-display
       end-if

done   goback.
       end function signal-attach.
      *>****
          

      *>****F* cobweb/builder-signal-attach
      *> Purpose:
      *> Attach a builder callback handler, by XML object name
      *> Input:
      *> builder, object name, event, callback
      *> Source:
id     identification division.
       function-id. builder-signal-attach. 

       environment division.
       configuration section.
       repository.
           function signal-attach
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-widget                 usage pointer.

link   linkage section.
       01 gtk-builder                usage pointer.
       01 builder-name               pic x any length.
       01 builder-event              pic x any length.
       01 callback-byname            pic x any length.
       01 extraneous                 usage binary-long.

code   procedure division using
           gtk-builder
           builder-name
           builder-event
           callback-byname
         returning extraneous.

      *> look up the object name
       call "gtk_builder_get_object" using
           by value gtk-builder
           by content concatenate(trim(builder-name), x"00")
           returning gtk-widget
       end-call
       if gtk-widget not equal null then
          move signal-attach(gtk-widget, builder-event, callback-byname)
            to extraneous
       end-if

done   goback.
       end function builder-signal-attach.
      *>****
          

      *>****F* cobweb/rundown-signals
      *> Purpose:
      *> Attach default GTK+ rundown handlers
      *> Input:
      *>   gtk-window pointer
      *> Source:
id     identification division.
       function-id. rundown-signals. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-callback               usage program-pointer.
       01 gtk-quit-id                usage pointer.

link   linkage section.
       01 gtk-window                 usage pointer.
       01 extraneous                 usage binary-long.

code   procedure division using gtk-window returning extraneous.

      *> Connect rundown signals to window.
       set gtk-callback to entry "gtk_main_quit"
       call "g_signal_connect_data" using
           by value gtk-window
           by reference z"destroy"     *> with inline Z string
           by value gtk-callback       *> function call back pointer
           by value 0                  *> pointer to data
           by value 0                  *> closure notify to manage data
           by value 0                  *> connect before or after flag
           returning gtk-quit-id       *> not used
       end-call

       set gtk-callback to entry "cobweb-delete-event"
       call "g_signal_connect_data" using
           by value gtk-window
           by reference z"delete_event"
           by value gtk-callback  
           by value 0                  
           by value 0                  
           by value 0                  
           returning gtk-quit-id
       end-call

done   goback.
       end function rundown-signals.
      *>****
          

      *>****F* cobweb/gtk-go
      *> Purpose:
      *> Start the GTK+ event loop, only returns after rundown
      *> Input:
      *>   gtk-window pointer (starting with widget_show_all)
      *> Source:
id     identification division.
       function-id. gtk-go. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-window           usage pointer.
       01 extraneous           usage binary-long.

code   procedure division using gtk-window returning extraneous.
      *> ready to display
       call "gtk_widget_show_all" using
           by value gtk-window
           returning omitted
       end-call

      *> Enter the GTK event loop
       call "gtk_main" returning omitted end-call

done   goback.
       end function gtk-go.
      *>****
          

      *>****F* cobweb/show-widget
      *> Purpose:
      *> Inform GTK to render the widget
      *> Input:
      *>   gtk-widget pointer
      *> Source:
id     identification division.
       function-id. show-widget. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-widget           usage pointer.
       01 extraneous           usage binary-long.

code   procedure division using gtk-widget returning extraneous.

       call "gtk_widget_show" using
               by value gtk-widget
           returning omitted
       end-call

done   goback.
       end function show-widget.
      *>****
       
      *>****F* cobweb/hide-widget
      *> Purpose:
      *> Inform GTK to mark the widget invisible
      *> Input:
      *>   gtk-widget pointer
      *> Source:
id     identification division.
       function-id. hide-widget. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-widget           usage pointer.
       01 extraneous           usage binary-long.

code   procedure division using gtk-widget returning extraneous.

       call "gtk_widget_hide" using
               by value gtk-widget
           returning omitted
       end-call

done   goback.
       end function hide-widget.
      *>****
          

      *>****F* cobweb/set-sensitive-widget
      *> Purpose:
      *> set the widget interactive state
      *> Input:
      *>   gtk-widget pointer
      *> Source:
id     identification division.
       function-id. set-sensitive-widget. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-widget           usage pointer.
       01 onoff                usage binary-long.
       01 extraneous           usage binary-long.

code   procedure division using gtk-widget returning extraneous.

       call "gtk_widget_set_sensitive" using
               by value gtk-widget
               by value onoff
           returning omitted
       end-call

done   goback.
       end function set-sensitive-widget.
      *>****

       
      *>****F* cobweb/entry-get-text
      *> Purpose:
      *> Get the text from an entry widget
      *> Source:
id     identification division.
       function-id. entry-get-text. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-text-entry       usage pointer.
       01 gtk-text-buffer      pic x(FIELDSIZE) based.

link   linkage section.
       01 gtk-entry            usage pointer.
       01 the-text-entry       pic x(FIELDSIZE).

code   procedure division using gtk-entry
           returning the-text-entry.

       call "gtk_entry_get_text" using
               by value gtk-entry
           returning gtk-text-entry
       end-call
       if gtk-text-entry not equal null then
           set address of gtk-text-buffer to gtk-text-entry
           initialize the-text-entry
           string
               gtk-text-buffer delimited by x"00" into the-text-entry
           end-string
       end-if

done   goback.
       end function entry-get-text.
      *>****
          

      *>****F* cobweb/entry-set-text
      *> Purpose:
      *> Set the text of an entry widget
      *> Source:
id     identification division.
       function-id. entry-set-text. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-entry            usage pointer.
       01 the-text-entry       pic x any length.
       01 extraneous           usage binary-long.

code   procedure division using
           gtk-entry
           the-text-entry
         returning extraneous.

       call "gtk_entry_set_text" using
               by value gtk-entry
               by content function concatenate(
                   function trim(the-text-entry), x"00")
           returning omitted
       end-call

done   goback.
       end function entry-set-text.
      *>****
          

      *>****F* cobweb/textview-get-text
      *> Purpose:
      *> Get the text from a multiline text view
      *> Source:
id     identification division.
       function-id. textview-get-text. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-textbuffer       usage pointer.
       01 text-pointer         usage pointer.
       01 text-buffer          pic x(AREASIZE) based.
       01 gtk-start            pic x(64).
       01 gtk-end              pic x(64).
       01 hidden-chars         usage binary-long value 0.

link   linkage section.
       01 gtk-textview         usage pointer.
       01 the-text-area        pic x(AREASIZE).

code   procedure division using gtk-textview
           returning the-text-area.

      *> retrieve the textbuffer of the textview
       call "gtk_text_view_get_buffer" using
           by value gtk-textview
           returning gtk-textbuffer
       end-call

      *> get all the text, from start to end
       if gtk-textbuffer not equal null then
           call "gtk_text_buffer_get_start_iter" using
               by value gtk-textbuffer
               by reference gtk-start
               returning omitted
           end-call
           call "gtk_text_buffer_get_end_iter" using
               by value gtk-textbuffer
               by reference gtk-end
               returning omitted
           end-call
           call "gtk_text_buffer_get_text" using
               by value gtk-textbuffer
               by reference  gtk-start gtk-end
               by value hidden-chars
               returning text-pointer
           end-call
           if text-pointer not equal null then
               set address of text-buffer to text-pointer
               initialize the-text-area
               string
                   text-buffer delimited by x"00" into the-text-area
               end-string
           end-if
       end-if

done   goback.
       end function textview-get-text.
      *>****
          

      *>****F* cobweb/textview-set-text
      *> Purpose:
      *> Set the text of a multiline text view
      *> Source:
id     identification division.
       function-id. textview-set-text. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 gtk-textbuffer       usage pointer.
       01 the-text-area-len    usage binary-long.

link   linkage section.
       01 gtk-textview         usage pointer.
       01 the-text-area        pic x any length.
       01 extraneous           usage binary-long.

code   procedure division using
           gtk-textview
           the-text-area 
         returning extraneous.

      *> retrieve the textbuffer of the textview
       call "gtk_text_view_get_buffer" using
           by value gtk-textview
           returning gtk-textbuffer
       end-call

      *> set the buffer text
       move length(trim(the-text-area)) to the-text-area-len
       if gtk-textbuffer not equal null then
           call "gtk_text_buffer_set_text" using
               by value gtk-textbuffer
               by reference the-text-area
               by value the-text-area-len
               returning omitted
           end-call
       end-if
  
done   goback.
       end function textview-set-text.
      *>****
          

      *>****F* cobweb/builder-get-object
      *> Purpose:
      *> Get a builder object by id name
      *> Source:
id     identification division.
       function-id. builder-get-object. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
link   linkage section.
       01 gtk-builder          usage pointer.
       01 builder-idname       pic x any length.
       01 gtk-widget-data.
          05 gtk-widget        usage pointer.
          05 filler            usage pointer.
          05 filler            binary-long.

code   procedure division using
           gtk-builder
           builder-idname
         returning gtk-widget-data.

       call "gtk_builder_get_object" using
           by value gtk-builder
           by content concatenate(trim(builder-idname), x"00")
           returning gtk-widget
       end-call

done   goback.
       end function builder-get-object.
      *>****
          

      *>****F* cobweb/statusbar-push
      *> Purpose:
      *> Add a message to the status stack, by context
      *> Source:
id     identification division.
       function-id. statusbar-push. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.

link   linkage section.
       01 gtk-statusbar-data.
          05 gtk-statusbar     usage pointer.
          05 filler            usage pointer.
          05 statusbar-context usage binary-long.
       01 text-message         pic x any length.
       01 message-id           usage binary-long.

code   procedure division using
           gtk-statusbar-data
           text-message
         returning message-id.

       
       call "gtk_statusbar_push" using
           by value gtk-statusbar
           by value statusbar-context
           by content concatenate(trim(text-message), x"00")
           returning message-id
       end-call

done   goback.
       end function statusbar-push.
      *>****
          

      *>****F* cobweb/statusbar-pop
      *> Purpose:
      *> Pop a message off the status stack, by context
      *> Source:
id     identification division.
       function-id. statusbar-pop. 

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.

link   linkage section.
       01 gtk-statusbar-data.
          05 gtk-statusbar     usage pointer.
          05 filler            usage pointer.
          05 statusbar-context usage binary-long.
       01 extraneous           usage binary-long.

code   procedure division using gtk-statusbar-data returning extraneous.

       call "gtk_statusbar_pop" using
           by value gtk-statusbar
           by value statusbar-context
           returning omitted
       end-call

done   goback.
       end function statusbar-pop.
      *>****
          
      *>****F* cobweb/file-contents
      *> Purpose:
      *> Return file contents as a string
      *> Inputs:
      *>    file name pic x any
      *>    optional file-length slot (integer, write)
      *>    optional error-code slot  (integer, write)
      *> Output:
      *>    file contents
      *> Warning:
      *>    There is a one megabyte limit on file size.
      *>    It has been pointed out that reading a whole
      *>    file with unknown size is not an overly smart
      *>    thing to do.
      *> Source:
id     identification division.
       function-id. file-contents.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

data   data division.
       working-storage section.
       01 buffer-pointer       usage pointer.
       01 file-length          usage binary-long.
       01 error-pointer        usage pointer.
       01 status-code          usage binary-long based.
       01 buffer-index         usage index.
       01 buffer-element       pic x based.

link   linkage section.
       01 filename             pic x any length.
       01 actual-length        usage binary-long.
       01 error-code           usage binary-long.
       01 file-buffer          pic x(FILESIZE).

code   procedure division using
           filename
           optional actual-length 
           optional error-code
         returning file-buffer.

      *> call glib file utility
       call "g_file_get_contents" using
           by content concatenate(trim(filename), x"00")
           by reference buffer-pointer
           by reference file-length
           by reference error-pointer
       end-call

      *> linkage section dataspace will likely be random
       initialize file-buffer

      *> if the caller wants the length
       if not actual-length omitted then
           move file-length to actual-length
       end-if

      *> if there is an error, and the call wants a code
       if return-code equal zero then
           if not error-code omitted then
               if error-pointer not equal null then
                  *> the code is 4 bytes into the GError struct
                   set error-pointer up by 4
                   set address of status-code to error-pointer
                   move status-code to error-code
               else
                   move 1 to error-code
               end-if
           end-if
       else
          *> fill the return field
           if buffer-pointer not equal null then
               set buffer-index to 1
               set address of buffer-element to buffer-pointer
               perform until buffer-index greater than file-length
                          or buffer-index greater than FILESIZE
                          or buffer-element equal x"00"
                   move buffer-element to file-buffer(buffer-index:1)
                   set buffer-index up by 1
                   set address of buffer-element up by 1
               end-perform
           end-if
       end-if

      *> g_file_get_contents allocated a buffer    
       call "g_free" using
           by value buffer-pointer
           returning omitted
       end-call

done   goback.
       end function file-contents.
      *>****
          

      *> ********************************************************
      *> demo/test functions
      *> ********************************************************
       
      *>****T* cobweb/help-about-cobweb [selftest]
      *> Purpose:
      *>   Display an Help/About dialog box from menu select
      *> Source:
id     identification division.
       program-id. help-about-cobweb.

data   data division.
       working-storage section.
       01 gtk-window-data                external.
          05 gtk-window        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
 
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division
           using
               gtk-widget
               gtk-data.   

       call "gtk_show_about_dialog" using
           by value gtk-window
           by content
               z"version", z"0.2",
               z"comments", z"cobweb-gtk menu self-test"
               z"copyright", z"Copyright (C) 2014, Brian Tiffin",
               z"website", "http://http://sourceforge.net/" &
                          z"projects/open-cobol/",
               z"program-name", z"cobweb-gtk",
               z"logo-icon-name", z"gtk-info",
           by reference null
       end-call
 
done   goback.
       end program help-about-cobweb.
      *>****


      *>****T* cobweb/cobweb-close [selftest]
      *> Purpose:
      *>   hide test-head window and exit event loop
      *>   on menu File/Quit 
      *> Source:
id     identification division.
       program-id. cobweb-close.

env    environment division.
       configuration section.
repo   repository.
           function hide-widget
           function all intrinsic.

data   data division.
       working-storage section.
       01 extraneous           usage binary-long.

      *> need access to main window, widget(1)
       COPY cobweb-gtk-widgets.

       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division
           using
               gtk-widget
               gtk-data.   

      *> All this indirection to hide the main window, on menu Quit
       move hide-widget(widget(1)) to extraneous
       call "gtk_main_quit" returning omitted end-call
 
done   goback.
       end program cobweb-close.
      *>****


      *>****T* cobweb/help-about-gtk [selftest]
      *> Purpose:
      *>   Display an application Help/About dialog box
      *> Source:
id     identification division.
       program-id. help-about-gtk.

data   data division.
       working-storage section.
       01 gtk-window-data                external.
          05 gtk-window        usage pointer.
          05 filler            usage pointer.
          05 filler            usage binary-long.
 
       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division using
           by value gtk-widget
           gtk-data.   

       call "gtk_show_about_dialog" using
           by value gtk-window
           by content
               z"version", z"0.1",
               z"comments", z"GTK+ and Glade3 GUI Programming Tutorial"
               z"copyright", z"Copyright 2007 Micah Carrick"
               z"website", z"http://www.micahcarrick.com",
               z"program-name", z"GTK+ Text Editor",
               z"logo-icon-name", z"gtk-edit",
           by reference null
       end-call
 
done   goback.
       end program help-about-gtk.
      *>****
          

      *>****T* cobweb/see-textview-gtk [demo]
      *> Purpose:
      *>   Self test, connected to File/Save, displays text in editor
      *> Source:
id     identification division.
       program-id. see-textview-gtk.

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
          05 filler            usage binary-long.
       01 gtk-textview         usage pointer.

       linkage section.
       01 gtk-widget           usage pointer.
       01 gtk-data             usage pointer.

code   procedure division using
           by value gtk-widget
           gtk-data.   

      *> find the GTKBuilder sample XML name for the textview
       call "gtk_builder_get_object" using
           by value gtk-builder
           by content z"text_view"
           returning gtk-textview
       end-call
       
      *> if that worked, show the current text data
       if gtk-textview not equal null then
           display trim(textview-get-text(gtk-textview)) end-display
       end-if
 
done   goback.
       end program see-textview-gtk.
      *>****
