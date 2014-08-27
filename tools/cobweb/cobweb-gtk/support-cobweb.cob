GNU    >>SOURCE FORMAT IS FIXED
Cobol *> *******************************************************
  cob *> Author:    Brian Tiffin
  web *> Date:      20140201
 call *> Purpose:   Support cobweb callbacks
backs *> Tectonics: cobc -x -C gnucobol-cobweb.cob
      *>            sed -i 's/stdio.h/fcgi_stdio.h/' gnucobol-cobweb.c
      *>            cobc -x gnucobol-cobweb.c -lfcgi buccaneer.so \
      *>                $(pkg-config --libs gtk+-2.0) voidcalls.c \
      *>                support-cobweb.cob
      *>   Move gnucobol-cobweb to the cgi-bin directory
      *>   supporting libraries in the COB_LIBRARY_PATH
      *>   browse http://localhost/cgi-bin/gnucobol-cobweb
      *> ********************************************************
      *> Callbacks
id     identification division.
       program-id. supporting-callbacks.
data   data division.
       working-storage section.
       01 gtk-button-label      usage pointer.
       01 the-button-label      pic x(11) based.
       01 the-button-copy       pic x(11).

       01 gtk-info-label        is external usage pointer.

      *>
      *> the periodic data, this EXTERNAL definition has to match
      *>  the definition in cobweb-periodic.cob (exactly)
      *>
       01 elements is external.
          05 element occurs 118 times indexed by elem.
             10 sym            pic xxx.
             10 cg             pic 99.
             10 rp             pic 99.
             10 color          pic x(24).
             10 info           pic x(64).
       01 element-data-status  pic 9999.

       01 zinfo.
          05 information       pic x(32).
          05 filler            pic x value x"00".

       01 gtk-calendar-data.
          05 gtk-calendar-year  usage binary-long sync.
          05 gtk-calendar-month usage binary-long sync.
          05 gtk-calendar-day   usage binary-long sync.
       01 gtk-calendar-display.
          05 the-year           pic 9999.
          05 filler             pic x value "/".
          05 the-month          pic 99.
          05 filler             pic x value "/".
          05 the-day            pic 99.
link   linkage section.
       01 gtk-widget usage pointer.

code   procedure division.
       entry 'calendarclick' using
           by value gtk-widget
       call "gtk_calendar_get_date" using
           by value gtk-widget
           by reference gtk-calendar-year
           by reference gtk-calendar-month
           by reference gtk-calendar-day
       end-call
       move gtk-calendar-year to the-year
       compute the-month = gtk-calendar-month + 1 end-compute
       move gtk-calendar-day to the-day
       display
           "Somebody clicked " gtk-calendar-display upon syserr
       end-display
done   goback.

      *> ********************************************************

code   entry 'buttonclick' using by value gtk-widget

       call "gtk_button_get_label" using
           by value gtk-widget
           returning gtk-button-label
       end-call
       set address of the-button-label to gtk-button-label
       move the-button-label(7:3) to the-button-copy

    >>Ddisplay
    >>D    "Somebody clicked " the-button-label upon syserr
    >>Dend-display

       set elem to 1
       search element
           at end display "element lookup fail" upon syserr
                  display elem "--" the-button-copy
           when sym(elem) equal the-button-copy
               display info(elem) end-display
               move info(elem) to information
               call "gtk_label_set_text" using
                   by value gtk-info-label
                   by content function concatenate(
                                function trim(info(elem)), x"00")
               end-call
               call "gtk_widget_show" using
                   by value gtk-info-label
                   returning omitted
               end-call
       end-search

done   goback.

       end program supporting-callbacks.
