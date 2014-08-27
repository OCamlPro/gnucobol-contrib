GNU    >>SOURCE FORMAT IS FIXED
Cobol *> *******************************************************
cob   *> Author:    Brian Tiffin
  web *> Date:      20130308, 20140712
      *> Purpose:   A cobweb extension, periodic table
atomic*> License:   GPL 3.0 or greater
chart *> Tectonics:
      *>  cobc -x -g -debug cobweb-periodic.cob support-cobweb.cob
      *>    voidcall.c `pkg-config --libs gtk+-3.0`
      *> ********************************************************
       identification division.
       program-id. cobweb-periodic.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select element-data
           assign to "elements.txt"
           organization is line sequential
           status is element-data-status 
           .

       data division.
       file section.
       fd element-data.
          01 element-record.
             05 element-id     pic 999.
             05 filler         pic x.
             05 element-short  pic xxx.
             05 filler         pic x.
             05 element-period pic 99.
             05 filler         pic x.
             05 element-group  pic 99.
             05 filler         pic x.
             05 element-color  pic x(24).
             05 filler         pic x.
             05 element-info   pic x(64).
 
       working-storage section.
      *>
      *> the periodic table of the elements, shared with a callback
      *>   updates here need to be synched with support-cobweb.cob
      *>
       01 elements is external.
          05 element occurs 118 times indexed by elem.
             10 sym            pic xxx.
             10 cg             pic 99.
             10 rp             pic 99.
             10 color          pic x(24).
             10 info           pic x(64).
       01 element-data-status  pic 9999.

      *> cheat C out of chasing a null byte
       01 button-zname.
          05 button-number           pic zzzz9.
          05 filler                  pic x value x"0a".
          05 button-name             pic xxx.
          05 filler                  pic x value x"00".

       01 venue                      pic x(8).
          88 broadway                    values "broadway", "BROADWAY".

       01 gtk-window                 usage pointer.
       01 gtk-settings               usage pointer.
       01 gtk-box                    usage pointer.
       01 gtk-label                  usage pointer.
       01 gtk-spacer                 usage pointer.
       01 gtk-grid                   usage pointer.
       01 gtk-button                 usage pointer.
       01 gtk-quit-callback          usage program-pointer.
       01 gtk-quit-handler-id        usage pointer.
       01 gtk-void-callback          usage program-pointer.
       01 cob-button-callback        usage program-pointer.

       01 gdk-color                  pic x(32).

       01 gtk-info-label             is external usage pointer.

       01 p usage index.
       01 g usage index.

       01 GTK-WINDOW-TOPLEVEL        constant as 0.

       01 GTK-ORIENTATION-HORIZONTAL constant as 0.
       01 GTK-ORIENTATION-VERTICAL   constant as 1.

       01 banner-msg           pic x(27)
                                 value z"GNU Cobol periodic buttons".

      *> destined to be a callable, not a main, linkage in the future
       linkage section.
       01 gtk-widget                 usage pointer.
       01 gtk-data                   usage pointer.
       
      *> ********************************************************

gui   *> ********************************************************
       procedure division.

      *> populate the element data
       open input element-data
       if element-data-status not equal zero then
           display
               "Sorry, no elements.txt data" upon syserr
           end-display
           stop run returning 1
       end-if

      *> pull in the element data, fill a table
       perform varying elem from 1 by 1 until elem > 118
           read element-data at end exit perform end-read
           if element-data-status not equal 0 then exit perform end-if
           move element-short to sym(elem)
           move element-group to cg(elem)
           move element-period to rp(elem)
           move element-color to color(elem)
           move element-info to info(elem)
       end-perform
       close element-data

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
               stop run returning 1
       end-call

      *> Create a new window, returning handle as pointer
       call "gtk_window_new" using 
           by value GTK-WINDOW-TOPLEVEL        *> it's a zero or a 1 popup
           returning gtk-window                *> and remember the handle
       end-call

      *> More fencing, skimped on after this first test
       if gtk-window equal null then
           display
               "GTK service error; gtk_window_new NULL"
               upon syserr
           end-display
           stop run returning 1
       end-if

      *> Hint to not let the sample window be too small
       call "gtk_window_set_default_size" using
           by value gtk-window                 *> by value is used to get the C address
           by value 270                        *> a rectangle, wider than tall
           by value 90 
           returning omitted                   *> another void
       end-call

      *> Put in the title, it'll be truncated in a size request window
       call "gtk_window_set_title" using
           by value gtk-window                 *> pass the C handle
           by reference banner-msg
           returning omitted
       end-call

      *> Connect death signals.
       set gtk-quit-callback to entry "gtk_main_quit"
       call "g_signal_connect_data" using
           by value gtk-window
           by reference z"destroy"             *> with inline Z string
           by value gtk-quit-callback          *> function call back pointer
           by value 0                          *> pointer to data
           by value 0                          *> closure notify to manage data
           by value 0                          *> connect before or after flag
           returning gtk-quit-handler-id       *> not used in this sample
       end-call
       call "g_signal_connect_data" using
           by value gtk-window
           by reference z"delete_event"        *> with inline Z string
           by value gtk-quit-callback          *> function call back pointer
           by value 0                          *> pointer to data
           by value 0                          *> closure notify to manage data
           by value 0                          *> connect before or after flag
           returning gtk-quit-handler-id       *> not used in this sample
       end-call

      *> Define a container. Boxey, but nice.  Layout top to bottom.
       call "gtk_box_new" using
           by value GTK-ORIENTATION-VERTICAL
           by value 8                          *> pixels between widgets
           returning gtk-box
       end-call

      *> Add the label
       call "gtk_label_new" using
           by reference banner-msg
           returning gtk-label
       end-call

      *> Add the label to the box
       call "gtk_container_add" using
           by value gtk-box
           by value gtk-label
           returning omitted
       end-call

      *> Instead of fiddling with each button, make a grid
       call "gtk_grid_new" returning gtk-grid end-call

       *> row and column for the chart is in the elements data
       *>  g is element group, p is period
       perform varying elem from 1 by 1 until elem > 118
           move cg(elem) to g
           move rp(elem) to p
           
          *> name the button
           move sym(elem) to button-name
           move elem to button-number

          *> Add a button
           call "gtk_button_new_with_label" using
               by reference button-zname
               returning gtk-button
           end-call

          *> BOO! no background color mod with the default GNOME
          *>  theme, Adwaita, due to the theme wanting to apply
          *>  gradients...  Rassafrassa, Styling... for color? 
          
          *> possible workaround, turn off the Adwaita theme
           call "gtk_settings_get_default"
               returning gtk-settings
           end-call
           call "g_object_set" using
               by value gtk-settings
               by content z"gtk-theme-name"
               by value 0
               by value 0
               returning omitted
           end-call
           
           call "gdk_rgba_parse" using
               by reference gdk-color
               by content concatenate(trim(color(elem)), x"00")
           end-call
           call "gtk_widget_override_background_color" using
               by value gtk-button
               by value 0
               by reference gdk-color
               returning omitted
           end-call

           call "gtk_grid_attach" using
               by value gtk-grid
               by value gtk-button
               by value p               *> column, element group
               by value g               *> row, element period
               by value 1               *> cells width
               by value 1               *> cells height
               returning omitted
           end-call

      *> Connect a signal.  GNU Cobol doesn't generate void returns
      *>  so this calls a C function two-liner that calls the
      *>  COBOL entry, but returns void to the runtime stack frame
           set cob-button-callback to entry "buttonclick"
           set gtk-void-callback to entry "voidcall"
           call "g_signal_connect_data" using
               by value gtk-button
               by reference z"clicked"             *> with inline Z string
               by value gtk-void-callback          *> function call back pointer
               by value cob-button-callback        *> pointer to COBOL proc
               by value 0                          *> closure notify to manage data
               by value 0                          *> connect before or after flag
               returning gtk-quit-handler-id       *> not used in this sample
           end-call

       end-perform

      *> Force the empty row 8 
       call "gtk_label_new" using
           by content z"---" 
           returning gtk-spacer
       end-call
       call "gtk_grid_attach" using
           by value gtk-grid
           by value gtk-spacer
           by value 3               *> left-side attached to
           by value 8               *> top-of-cell row, element period
           by value 1               *> cells width
           by value 1               *> cells height
           returning omitted
       end-call

      *> the info box
       call "gtk_label_new" using
           by content "Click an element to see more information," &
                      " including;" & x"0a" &
                      "name, class, normal state," &
                     z" atomic weight and electron orbits"
           returning gtk-info-label
       end-call
       call "gdk_rgba_parse" using
           by reference gdk-color
           by content z"white"
       end-call
       call "gtk_widget_override_background_color" using
           by value gtk-info-label
           by value 0
           by reference gdk-color
           returning omitted
       end-call
       call "gtk_grid_attach" using
           by value gtk-grid
           by value gtk-info-label
           by value 3               *> left-side attached to
           by value 2               *> top-of-cell row, element period
           by value 10              *> cells width
           by value 2               *> cells height
           returning omitted
       end-call


      *> Add the big fat grid to the box
       call "gtk_container_add" using
           by value gtk-box
           by value gtk-grid
           returning omitted
       end-call

      *> Add some control buttons to the box, only the self destruct button in this case
       call "gtk_button_new_with_label" using
           by content z"Exit"
           returning gtk-button
       end-call
       call "gtk_container_add" using
           by value gtk-box
           by value gtk-button
           returning omitted
       end-call
       set gtk-quit-callback to entry "gtk_main_quit"
       call "g_signal_connect_data" using
           by value gtk-button
           by reference z"clicked"             
           by value gtk-quit-callback          
           by value 0                          
           by value 0                          
           by value 0                          
           returning gtk-quit-handler-id       
       end-call
       
      *> Add the box to the window
       call "gtk_container_add" using
           by value gtk-window
           by value gtk-box
           returning omitted
       end-call

      *> ready to display
       call "gtk_widget_show_all" using
           by value gtk-window
           returning omitted
       end-call

      *> Enter the GTK event loop
       call "gtk_main" returning omitted end-call

      *> Control can pass back and forth to COBOL subprograms,
      *>  by event, but control flow stops above, until the
      *>  window is torn down and the event loop exits
       display
           "GNU Cobol: GTK main eventloop terminated normally"
           upon syserr
       end-display
     
       accept venue from environment "GDK_BACKEND" end-accept
       if broadway then
           display "Ken sends his regards" upon syserr end-display
       end-if

done   goback.
COOL   end program cobweb-periodic.
