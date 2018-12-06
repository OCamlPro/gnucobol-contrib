      *>-<*
      *> Copyright 2017 Brian Tiffin
      *> Licensed for use under the GNU LGPL 3+
      *> https://www.gnu.org/licenses/lgpl-3.0.en.html
      *> Date:     October 2017
      *> Modified: 2018-12-06/05:28-0500 btiffin
      *>+<*
      *>
      *> cobweb-agar.cob:  libagar user defined functions
      *> Tectonics:
      *>   cobc -m cobweb-agar.cob $(agar-config --libs)
      *>
       >>SOURCE FORMAT IS FIXED

      *> Main entry point is normal int return, calls into void gui
      *> **************************************************************
       identification division.
       program-id. cobweb-agar.

       procedure division.
       call "cobweb-agar-gui" returning omitted

       goback.
       end program cobweb-agar.

      *> For void return on nested callbacks and ENTRY, gui entry point
      *> **************************************************************
       identification division.
       program-id. cobweb-agar-gui.

       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           COPY cobweb-agar-repository.
           function all intrinsic.

       data division.
       working-storage section.
       COPY libagar.

       01 trial-thing.
          :AGAR-OBJECT-CLASS:

       01 rc                           usage binary-long.
       01 extraneous                   usage binary-long.

       01 cli-command                  pic x(16).
          88 helping           values "help",    "--help", "-h".
          88 versioning        values "version", "--version", "-v".
          88 licensing         values "license", "--license", "-l".
          88 repoing           values "repo",    "--repository", "-r".
          88 templating        values "new",     "--skeleton", "-s".
          88 testing           values "test",    "--test", "-t".
          88 filing            values "file",    "--file", "-f".
          88 simpling          values "basic",   "--basic", "-b".
       01 cli-subtext                  pic x(64).
       01 more-help                    pic x(32).

       01 nice-date                    pic xxxx/xx/xxbxx/xx.

       01 agar-ds-record.
          05 agar-ds                   usage pointer.
       01 agar-username.
          05 filler value "Master Programmer".
       01 minus-one                    usage binary-c-long value -1.
       01 newline                      pic x value x"0a".

       01 shared-data                  pic x(40) external.

       01 net-rc                       usage binary-long.
       01 net-buffer                   pic x(32768).
       01 read-actual                  usage binary-c-long.
       01 write-actual                 usage binary-c-long.

      *> network destination
       01 remote-host                  pic x(128).
       01 remote-port                  pic x(6).

      *> HTTP request fields
       01 remote-method                pic x(7).
       01 remote-resource              pic x(2048).
       01 http-version                 pic x(8).
      *> ***************************************************************

      *> fixedplotter work variables
       01 agar-16bits                  usage binary-short.
       01 looper                       usage float-short.
       01 decay                        usage float-short.

      *> Objects and AG_Variable access
       01 agar-user-ops-symbol         usage program-pointer.
       01 agar-user-ops based.
       :AGAR-USER-OPS:

       01 agar-user-pointer            usage pointer.
       01 agar-user based.
       :AGAR-USER:

       01 ag-config-object             usage pointer.
       01 initial-run                  usage binary-long.
       01 show-initial-run             pic 9.
       01 load-path-buffer             pic x(256).
       01 save-path-buffer             pic x(256).
       01 tmp-path-buffer              pic x(256).

      *> Inherited styles
       01 font-family-buffer           pic x(256).

      *> widgets.  These can be in occurs tables
       01 bit-flags                    usage binary-long.
       01 agar-stylesheet              usage pointer.

       01 timer                        usage pointer.
       01 timer-handler                usage program-pointer.

      *> the windows
       01 agar-win-record          occurs 6 times.
          05 agar-win                  usage pointer.
       01 save-window                  usage pointer external.

       01 agar-event-record.
          05 agar-event-widget         usage pointer.

       01 agar-box-record.
          05 agar-box-widget           usage pointer.

       01 agar-label-record        occurs 8 times.
          05 agar-label-widget         usage pointer.

       01 agar-button-record       occurs 6 times.
          05 agar-button-widget        usage pointer.

       01 agar-checkbox-record     occurs 2 times.
          05 agar-checkbox-widget      usage pointer.
       01 checkbox-bits                usage binary-long unsigned.
       01 checkbox-bitmask             usage binary-long unsigned
                                       value h'ffffffff'.

       01 agar-textbox-record      occurs 2 times.
          05 agar-textbox-widget       usage pointer.
       01 work-buffer                  pic x(41)
                       value z"This is the starting data   012345     ".
       01 text-msg.
          05 value "Image from" & x"0a" & "Wikipedia" & x"0a" &
                   "https://en.wikipedia.org/wiki/File:Grace_Murray" &
                   "_Hopper," & x"0a" &
                   "_in_her_office_in_Washington_DC," & x"0a" &
                   "_1978,_%C2%A9Lynn_Gilbert.jpg".


       01 agar-combo-record.
          05 agar-combo-widget         usage pointer.

       01 ag-cpuinfo.
          :AG-CPUINFO:
       01 cpu-ext-formatted            usage pointer.

       01 agar-tlist-record.
          05 agar-tlist-widget         usage pointer.
       01 null-pointer                 usage pointer value null.

       01 agar-console-record.
          05 agar-console-widget       usage pointer.

       01 agar-consolemsg-record.
          05 agar-consolemsg-widget    usage pointer.

       01 agar-dirdlg-record.
          05 agar-dirdlg-widget        usage pointer.

       01 agar-editable-record     occurs 4 times.
          05 agar-editable-widget      usage pointer.
       01 edit-buffer                  pic x(41)
              value "editable buffer".
       01 num-buffer                   pic x(8)
              value "12345678".
       01 pass-buffer                  pic x(24)
              value "secretPassword".

       01 agar-filedlg-record      occurs 2 times.
          05 agar-filedlg-widget       usage pointer.

       01 agar-fixed-record.
          05 agar-fixed-widget         usage pointer.

       01 agar-fontselector-record.
          05 agar-fontselector-widget  usage pointer.

       01 agar-font                    usage pointer.
      *> BWT HERE
       01 agar-font-space              pic x(10240).

       01 agar-graph-record            external.
          05 agar-graph-widget         usage pointer.

       01 user-data                    usage pointer.

       01 agar-graphvertex-record  occurs 5 times.
          05 agar-graphvertex-widget   usage pointer.

       01 agar-graphedge-record    occurs 5 times.
          05 agar-graphedge-widget     usage pointer.

       01 agar-hsvpal-record.
          05 agar-hsvpal-widget        usage pointer.

      *> for testing MPane
       01 agar-hsvpal-record-2.
          05 agar-hsvpal-widget-2      usage pointer.

       01 agar-menu-record.
          05 agar-menu-widget          usage pointer.

       01 agar-menunode-record     occurs 3 times.
          05 agar-menunode-widget      usage pointer.

       01 agar-menuaction-record   occurs 4 times.
          05 agar-menuaction-widget    usage pointer.
       01 some-data                    usage pointer.
       01 site-buffer.
          05 value z"https://sourceforge.net/projects/open-cobol/".

       01 agar-mpane-record.
          05 agar-mpane-widget         usage pointer.

       01 agar-notebook-record.
          05 agar-notebook-widget      usage pointer.

       01 agar-notebook-tab-record occurs 2 times.
          05 agar-notebook-tab-widget  usage pointer.

       01 agar-numerical-record    occurs 2 times.
          05 agar-numerical-widget     usage pointer.
       01 some-integer                 usage binary-long.

       01 agar-pane-record.
          05 agar-pane-widget          usage pointer.

       01 agar-pixmap-record       occurs 5 times.
          05 agar-pixmap-widget        usage pointer.

       01 agar-progressbar-record.
          05 agar-progressbar-widget   usage pointer.
       01 progress-value               usage binary-long value 72.
       01 progress-min                 usage binary-long value 0.
       01 progress-max                 usage binary-long value 100.

       01 agar-radio-record.
          05 agar-radio-widget         usage pointer.
       01 radio-value                  usage binary-long.
       01 radio-array.
          05 radio-items               occurs 5 times usage pointer.
       01 item-1.
          05 value z"Radio 0".
       01 item-2.
          05 value z"Radio 1".
       01 item-3.
          05 value z"Radio 2".
       01 item-4.
          05 value z"Radio 3".

       01 agar-scrollview-record   occurs 2 times.
          05 agar-scrollview-widget    usage pointer.

       01 agar-separator-record.
          05 agar-separator-widget     usage pointer.

       01 agar-slider-record.
          05 agar-slider-widget        usage pointer.
       01 slider-integer               usage binary-long signed.
       01 slider-min                   usage binary-long signed.
       01 slider-max                   usage binary-long signed.
       01 slider-inc                   usage binary-long signed.

       01 agar-socket-record      occurs 4 times.
          05 agar-socket-widget        usage pointer.

       01 agar-table-record.
          05 agar-table-widget         usage pointer.
       01 rower                        pic 99.
       01 stdout                       usage pointer.
       01 sep-char                     usage binary-char value 44.

       01 agar-treetbl-record.
          05 agar-treetbl-widget       usage pointer.
       01 treetbl-data-function        usage program-pointer.
       01 coler                        pic 99.
       01 a-row       occurs 4 times   usage pointer.
       01 row-id                       pic 9999.

       01 agar-variable-record.
          05 agar-variable-reference   usage pointer.

       01 agar-plotter-record.
          05 agar-plotter-widget       usage pointer.

       01 agar-curve-record.
          05 agar-curve-widget         usage pointer.

       01 helptext-entry               usage program-pointer.
       01 helptext                     usage pointer.

      *> Timer trial
       01 down-time                    usage binary-long external.


       01 driverlist-buffer            pic x(80).

       01 driver-event                 pic x(48).

      *> replace some data definitions
       :AGAR-RUN-STATUS:

      *> event for the entry thing test
       01 ag-event based.
          :AGAR-EVENT:

       01 show-event                   pic x(32).

       01 ag-combo based.
          :AGAR-COMBO:

       01 ag-menu based.
          :AGAR-MENU:

       01 ag-mpane based.
          :AGAR-MPANE:

       01 ag-pane based.
          :AGAR-PANE:

      *> Datasource testing
       01 ds usage pointer.
       01 ds-buffer pic x(32767).
       01 fp usage pointer.
       01 read-len usage binary-c-long.
       01 read-pos usage binary-c-long.
       01 write-len usage binary-c-long.
       01 write-pos usage binary-c-long.
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.
       01 core-buffer.
          05 value "this is a core buffer with 49 bytes of data in it".
       01 core-len                     usage binary-c-long.

      *> Formatting strings trial
       01 trial-integer usage binary-long value 42.
       01 trial-float usage float-short value 42.42.
       01 trial-string.
          05 value z"abc".
       01 formatter usage pointer.
       01 format-buffer pic x(132).
       01 formatted-size usage binary-c-long.

      *> Object name
       01 ago usage pointer.

      *> Process Execute trial
       01 process-id usage binary-long.
       01 pid-status usage binary-long.

      *> error messages
       01 error-record.
          05 error-reference usage pointer.
       01 error-buffer pic x(40).
       01 error-length usage binary-c-long.

      *> Config settings
       01 agar-variable usage pointer.
       01 agar-size-t usage binary-c-long.

      *> Icons
       01 agar-icon occurs 5 times usage pointer.
       01 agar-surface occurs 5 times usage pointer.

       01 filename-pointer usage pointer.
       01 last-element usage pointer.
       01 filename.
          05 value "/home/btiffin/filename.cob".

      *> Unicode viewer
       01 unicode-win usage pointer.

      *> agar-version
       01 agar-version.
          05 ag-major usage binary-long.
          05 ag-minor usage binary-long.
          05 ag-patch usage binary-long.
          05 ag-release usage pointer sync.

      *> for the events via ENTRY trial
       linkage section.
       01 event-thing                  usage pointer.

       procedure division extern returning omitted.

       >>IF P64 NOT SET
       >>DISPLAY 64bit only code at the moment
       STOP "Sorry, this codebase currently only supports 64bit" &
            " please tay tuned.  Press Enter to NOT continue."
       STOP RUN
       >>END-IF

       initialize shared-data
       accept cli-command from argument-value

       evaluate true
           when versioning perform show-version
           when helping    perform show-help
           when licensing  perform show-usage
           when repoing    perform show-repository
           when templating perform generate-template
           when testing    perform run-tests
           when filing     perform try-filing
           when simpling   perform basic-tests
           when other      perform show-usage
       end-evaluate

      *> all done with the executable code stored in the UDF DSO.
       move 0 to return-code
       goback.
      *> ***************************************************************


      *> basic-tests
       basic-tests.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           display "AG_InitCore success"
           set agar-core-ready to true
       end-if

       call "AG_ListDriverNames" using
           by reference driverlist-buffer
           by value length(driverlist-buffer)
       display "Available graphic drivers :"
           trim(substitute(driverlist-buffer low-value space)) ":"

      *> accept an optional extra agrument for driver
       accept cli-subtext from argument-value

       if not agar-gui-ready then
           if cli-subtext equal spaces then
               display "using driver: null (system default)"
               call "AG_InitGraphics" using
                   by reference null          *> z"sdlfb"
                   returning rc
                   on exception
                       display "error: no libagar-gui" upon syserr
                       goback
               end-call
           else
               display "using driver: " trim(cli-subtext)
               call "AG_InitGraphics" using
                   by content concatenate(trim(cli-subtext) x"00")
                   returning rc
                   on exception
                       display "error: no libagar-gui" upon syserr
                       goback
               end-call
           end-if
           if rc not equal zero then
               display "error: AG_InitGraphics failure " rc upon syserr
               goback
           end-if
           call "AG_BindStdGlobalKeys" returning omitted
           display "AG_InitGraphics " trim(cli-subtext) " success"
           set agar-gui-ready to true
       end-if

       call "AG_GetVersion" using agar-version
       call "printf" using "libAgar %d.%d.%d, %s" & x"0a00"
          by value ag-major ag-minor ag-patch ag-release

       move agar-window(AG-WINDOW-CENTER, numval(640), numval(400))
         to agar-win-record(1)

       if cli-subtext equals "sdlfb" then
           call "AG_WindowMaximize" using by value agar-win(1)
       end-if

       move 4000 to down-time
       move agar-timer(agar-win(1), numval(0), down-time,
                       "timer", "timerfinal") to rc
       if rc not equal zero then
           display "error: agar-timer failed " rc upon syserr
       end-if

      *> display the window
       move agar-window-show(agar-win(1)) to extraneous

      *> run the event loop until run down
      *>  (close with sysmenu or Goodbye button)
       move agar-eventloop() to rc
       if rc not equal 0 then
           display "warning: eventloop non-zero " rc upon syserr
       end-if
       
      *> clean up (should these be functions?)
       call "AG_DestroyGraphics" returning omitted
       call "AG_Destroy" returning omitted

       display "Done basic tests"
       .

      *> short trials, insert code here
       run-trial.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       if not agar-gui-ready then
           call "AG_InitGraphics" using
               by reference null             *> z"sdlfb"
               returning rc
               on exception
                   display "error: no libagar-gui" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitGraphics failure " rc upon syserr
               goback
           end-if
           call "AG_BindStdGlobalKeys" returning omitted
           set agar-gui-ready to true
       end-if

      *> Short name test
       set filename-pointer to address of filename
       call "AG_ShortFilename" using
           by value filename-pointer
           returning last-element
       display "file: " content-of(filename-pointer) ", "
               filename-pointer ", " last-element ", "
               content-of(last-element)

       display "obj size: " length(trial-thing)

       call "AG_SurfaceFromBMP" using
           by reference z"/home/btiffin/.agartest/agar.bmp"
           returning agar-surface(1)

       call "AG_SurfaceFromPNG" using
         by reference "/usr/share/icons/oxygen/base/16x16/apps/" &
                      "preferences-desktop-display-color.png"
         returning agar-surface(2)

       call "AG_IconFromSurface" using
         by value agar-surface(2)
           returning agar-icon(1)

       move agar-window(AG-WINDOW-CENTER, numval(640), numval(560))
         to agar-win-record(1)

       move agar-box(agar-win(1), AG-BOX-HORIZ, numval(3))
         to agar-box-record

       move agar-label(agar-box-widget, numval(0), "Surface and pixmap")
         to agar-label-record(1)

       move agar-button(agar-box-widget, numval(0), z"Goodbye",
                        "windown", "goodbye-button", numval(1))
         to agar-button-record(1)

       move agar-pixmap-surface(agar-win(1), numval(0), agar-surface(2))
         to agar-pixmap-record(1)
       move agar-pixmap-file(agar-win(1), numval(0),
                "images/preferences-desktop-display-color.png")
         to agar-pixmap-record(2)

       move agar-pixmap-file(agar-win(1), numval(0),
                "images/preferences-desktop-display-color.png")
         to agar-pixmap-record(3)
       move agar-pixmap-surface-scaled(agar-win(1), numval(0),
                agar-surface(2), numval(128), numval(128))
         to agar-pixmap-record(4)
       move agar-pixmap-file(agar-win(1), numval(0), "images/kword.png")
         to agar-pixmap-record(5)

       call "AG_SurfaceFromPNG" using
         by reference "images/preferences-desktop-display-color.png"
         returning agar-surface(3)

       call "AG_IconFromSurface" using
         by value agar-surface(3)
           returning agar-icon(2)

       move agar-socket(agar-win(1), AG-NOFLAGS,
                        "insert-socket", "remove-socket", agar-icon(2))
         to agar-socket-record(1)

       move agar-window-show(agar-win(1)) to extraneous
       move agar-eventloop() to rc

       call "AG_ObjectGetName" using by value agar-button-widget(1)
           returning ago
       display "Object name: " content-of(ago)


      *> Formatting strings
       call "AG_PrintfP" using
           by reference "     The int is %d, the float is %f"
                      & ", the str is %s"
                      & ", the hex is %x %X, the oct is %o"
           by reference trial-integer
           by reference trial-float
           by reference trial-string
           by reference trial-integer
           by reference trial-integer
           by reference trial-integer
           returning formatter
       call "AG_ProcessFmtString" using
           by value formatter
           by reference format-buffer
           by value size size-t length(format-buffer)
           returning formatted-size
       display "Formatted :"
           trim(substitute(format-buffer low-value space) trailing) ":"

      *> try some executes
       display "Running ls -g -o -c -r -t"
       move agar-execute("ls", "../..", "-g", "-o",
                         "-c", "-r", "-t") to process-id
       display "ls pid: " process-id

       move agar-execute("cobcrun", "cobweb-agar", "repo") to process-id
       call "CBL_GC_WAITPID" using process-id returning pid-status
       display "cobweb-agar repo pid: " process-id ", " pid-status

       move agar-execute("cobc", "--version") to process-id
       move agar-wait-on-process(process-id, AG-EXEC-WAIT-INFINITE)
         to pid-status
       display "cobc --version pid: " process-id ", " pid-status

       move agar-get-error() to error-record
       display "agar-get-error :" content-of(error-reference) ":"

       move agar-get-error-pic(error-buffer) to error-length
       display "get-error-pic :" trim(error-buffer) ":, " error-length
       .

       show-version.
      *> [helpstart-version]
      *> cobweb-agar version
      *> Display the version and compile time of this cobweb-agar.
      *> [helpend-version]
       move when-compiled to nice-date
       inspect nice-date replacing first "/" by ":" after initial space
       display "cobweb-agar [version 0.7] " nice-date
       .


       show-usage.
      *> [helpstart-license]
      *> cobweb-agar license
      *> Display the usage rights for this version of cobweb-agar and
      *> the Agar licensing and obligation notice
      *> [helpend-license]
       perform show-version
       display space
       display "Copyright 2017 Brian Tiffin"
       display "Licensed for use under the GNU LGPL verion 3 or higher."
       display "  See https://www.gnu.org/licenses/lgpl-3.0.en.html"
       display space
       display "use 'cobcrun cobweb-agar help' for more information."
       display space
       display "This software uses Agar. http://www.libagar.org"
       display space
       display "Agar, is developed by Julien Nadeau (vedge) and is"
       display space
       >>SOURCE FORMAT IS FREE
       display "Copyright (c) 2001-2011 Hypertriton, Inc. <http://hypertriton.com/>"
       display "All rights reserved."
       display space
       display "Redistribution and use in source and binary forms, with or without"
       display "modification, are permitted provided that the following conditions"
       display "are met:"
       display "1. Redistributions of source code must retain the above copyright"
       display "   notice, this list of conditions and the following disclaimer."
       display "2. Redistributions in binary form must reproduce the above copyright"
       display "   notice, this list of conditions and the following disclaimer in the"
       display "   documentation and/or other materials provided with the distribution."
       display space
       display "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ""AS IS"""
       display "AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE"
       display "IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE"
       display "ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR"
       display "ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL"
       display "DAMAGES (INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR"
       display "SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER"
       display "CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,"
       display "OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE"
       display "USE OF THIS SOFTWARE EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
       >>SOURCE FORMAT IS FIXED
       .


       show-help.
      *> [helpstart-help]
      *> cobweb-agar help [topic]
      *> Display help for the given topic.
      *>
      *> Use 'help list' for the list of included topics
      *> [helpend-help]
       perform show-version
       display space
       accept cli-subtext from argument-value

       if cli-subtext equals spaces then
           display "cobcrun cobweb-agar [subcommand...]"
           display "  -h, --help,       help [topic]    show help"
           display "  -v, --version,    version         show version"
           display "  -l, --license,    license         show rights"
           display "  -r, --repository, repo            list functions"
           display "  -s, --skeleton,   new             generate sample"
           display "  -f, --file,       file            datasource demo"
           display "  -t, --test,       test            run GUI tests"
           display "  -b, --basic,      basic           run basic tests"
       else
           if lower-case(cli-subtext) equal "list" then
               display "List of cobweb-agar help topics:"
               call "SYSTEM" using concatenate(
                   "sed -rn 's/\s*\*>\s?\[help" "start-(.*)\]/\1/p' "
                   module-source " | sort | sed 's/^/    /'")
           else
               if lower-case(cli-subtext) equal "agar" then
                   accept more-help from argument-value
                   if more-help not equal spaces then
                       call "SYSTEM" using concatenate(
                           "w3m -no-graph -dump "
                           "http://www.libagar.org/mdoc.cgi?man="
                           trim(more-help) ".3")
                   else
                       call "SYSTEM" using concatenate(
                           "w3m -no-graph -dump "
                           "http://www.libagar.org/index.html")
                   end-if
               else
                   display "Help for " trim(cli-subtext)
                   call "SYSTEM" using concatenate(
                       "sed -n "
                       "'/\[help" "start-" trim(cli-subtext) "\]/,"
                       "/\[help" "end-" trim(cli-subtext) "\]/{//!p}' "
                       module-source
                       " | sed -r 's/^.{6}//;"
                                  "s/^\s*\*>\s?//;"
                                  "s/^\s*[0][1]/  /;"
                                  "s/^\s*[[:digit:]]{1,2}/     /;"
                                  "s/^/    /'")
               end-if
           end-if
       end-if
       .


       show-repository.
      *> [helpstart-repository]
      *> cobweb-agar repository
      *> Display the list of user defined functions in cobweb-agar.
      *> [helpend-repository]
       display "repository."
       call "SYSTEM" using concatenate(
           "grep function-id\\. "
           module-source
           " | sed 's/function-id\. /function /'"
           " | tr '.' ' '")
       .

      *> generate a starter skeleton
       generate-template.
      *> [helpstart-template]
      *> Generate a starter template given optional filename.
      *>
      *> Default filename is gnucobol-agar-starter.cob
      *> [helpend-template]
       accept cli-subtext from argument-value
       if cli-subtext equal spaces then
           move "gnucobol-agar-starter.cob" to cli-subtext
       end-if
       move agar-open-file(cli-subtext, "w") to agar-ds-record
       if agar-ds equal null then
           display "error: Could not open " trim(cli-subtext)
                   "for write" upon syserr
       end-if
       move agar-write-pic(agar-ds, concatenate(
       "      *> Agar GUI program"                              newline
       "      *> Copyright " current-date(1:4) " " agar-username newline
       "      *> Licensed under (pick your usage terms)"        newline
       "      *> Date started: " current-date(1:8)              newline
       "      *> Modified: "                                    newline
       "      *> Tectonics:"                                    newline
       "      *>   cobc -x " trim(cli-subtext) " cobweb-agar.cob"
       " $(agar-config --libs)"                                 newline
       "      *>"                                               newline
       "      *> Credits:"                                      newline
       "      *>   Agar by Julian Nadeau, Copyright 2001-2011"
       " Hypertriton, Inc."                                     newline
       "      *>   cobweb-agar, Copyright 2017 Brian Tiffin"    newline
       " "                                                      newline
       "       >>SOURCE FORMAT IS FREE"                         newline
       "       identification division."                        newline
       "       program-id. gnucobol-agar-starter."              newline
       " "                                                      newline
       "      *> 'cobcrun cobweb-agar repo' for the full list"  newline
       "       environment division."                           newline
       "       configuration section."                          newline
       "       repository."                                     newline
       "           function agar-window"                        newline
       "           function agar-window-show"                   newline
       "           function agar-eventloop"                     newline
       "           function agar-box"                           newline
       "           function agar-button"                        newline
       "           function agar-label"                         newline
       "           function agar-set-style"                     newline
       "           function agar-textbox"                       newline
       "           function agar-widget-focus"                  newline
       "           function all intrinsic."                     newline
       " "                                                      newline
       "       data division."                                  newline
       "       working-storage section."                        newline
       " "                                                      newline
       "      *> cobweb-agar ships with some copybooks"         newline
       "       COPY libagar."                                   newline
       " "                                                      newline
       "      *> some routines return a status, others do not"  newline
       "       01 result-code usage binary-long."               newline
       "       01 extraneous usage binary-long."                newline
       " "                                                      newline
       "      *> An application specific text field"            newline
       "       01 text-line pic x(80) external."                newline
       " "                                                      newline
       "      *> user defined function widget records"          newline
       "       01 window-record."                               newline
       "          05 window usage pointer."                     newline
       "       01 box-record."                                  newline
       "          05 box usage pointer."                        newline
       "       01 button-record."                               newline
       "          05 button usage pointer."                     newline
       "       01 label-record."                                newline
       "          05 label-widget usage pointer."               newline
       "       01 textbox-record."                              newline
       "          05 textbox usage pointer."                    newline
       " "                                                      newline
       "       procedure division."                             newline
       "       display ""cobweb-agar starter kit"""             newline
       " "                                                      newline
       "      *> creating a window also initializes the system" newline
       "       move agar-window(AG-WINDOW-CENTER, numval(400),"
       " numval(120), ""Hello from cobweb-agar"")"              newline
       "         to window-record"                              newline
       " "                                                      newline
       "      *> make a box for the button and the label"       newline
       "       move agar-box(window, AG-BOX-HORIZ,"
       " AG-BOX-HFILL)"                                         newline
       "         to box-record"                                 newline
       " "                                                      newline
       "       move agar-button(box, AG-NOFLAGS, ""Quit"","
       " ""windown"", ""sample-button"", numval(1))"            newline
       "         to button-record"                              newline
       "       move agar-set-style(button, ""text-color"","
       " ""rgb(0,0,0)"")"                                       newline
       "         to extraneous"                                 newline
       " "                                                      newline
       "       move agar-label(box, AG-LABEL-HFILL,"
       " ""cobweb-agar starter kit"")"                          newline
       "         to label-record"                               newline
       "       move agar-set-style(label-widget, ""text-color"","
       " ""rgb(255,165,0)"")"                                   newline
       "         to extraneous"                                 newline
       " "                                                      newline
       "      *> add a user edit text field"                    newline
       "       move z""Welcome to cobweb-agar"" to text-line"   newline
       "       move agar-textbox(window, AG-TEXTBOX-HFILL,"
       " ""Text:"", text-line, ""textbox-callback"","
       " ""textline"")"                                         newline
       "         to textbox-record"                             newline
       "       move agar-widget-focus(textbox) to result-code"  newline
       " "                                                      newline
       "      *> display the window"                            newline
       "       move agar-window-show(window)"                   newline
       "         to extraneous"                                 newline
       " "                                                      newline
       "      *> run the Agar event loop"                       newline
       "       move agar-eventloop() to result-code"            newline
       " "                                                      newline
       "       display ""eventloop ended with: "" result-code"  newline
       "       display ""text-line: "" trim(text-line)"         newline
       "       goback."                                         newline
       "       end program gnucobol-agar-starter."              newline
       "      *> *********************************************" newline
       " "                                                      newline
       "      *> events are handled by callback"                newline
       "       identification division."                        newline
       "       program-id. textbox-callback."                   newline
       " "                                                      newline
       "      *> extern subprograms can be called from C"       newline
       "       environment division."                           newline
       "       configuration section."                          newline
       "       special-names."                                  newline
       "           call-convention 0 is extern."                newline
       " "                                                      newline
       "       repository."                                     newline
       "           function agar-eventname"                     newline
       "           function all intrinsic."                     newline
       " "                                                      newline
       "      *> passed an event pointer"                       newline
       "       data division."                                  newline
       "       working-storage section."                        newline
       "       01 text-line      pic x(80) external."           newline
       "       01 sentinel-z     usage binary-long."            newline
       " "                                                      newline
       "       linkage section."                                newline
       "       01 event usage pointer."                         newline
       " "                                                      newline
       "      *> different handlers may return a value"         newline
       "       procedure division extern using"                 newline
       "           by value event"                              newline
       "           returning omitted."                          newline
       " "                                                      newline
       "       move 0 to sentinel-z"                            newline
       "       inspect text-line tallying sentinel-z"           newline
       "          for characters before initial low-value"      newline
       "       if sentinel-z < 1 then"                          newline
       "           move 1 to sentinel-z"                        newline
       "       end-if"                                          newline
       "       if sentinel-z > 80 then"                         newline
       "           move 80 to sentinel-z"                       newline
       "       end-if"                                          newline
       "       display ""text-line now :"""                     newline
       "          text-line(1 : sentinel-z) "":"""              newline
       " "                                                      newline
       "      *> textbox-prechg, postchg & return events"       newline
       "      *> this will end the GUI on textbox-return"       newline
       "       if agar-eventname(event) equals"
       " ""textbox-return"" then"                               newline
       "           call ""windown"" using"                      newline
       "               by value event"                          newline
       "               returning omitted"                       newline
       "       end-if"                                          newline
       " "                                                      newline
       "       goback."                                         newline
       "       end program textbox-callback." newline),
           minus-one, write-actual) to rc
      *> move agar-close-datasource(agar-ds) to extraneous
       display "Created " trim(cli-subtext) ", " write-actual " bytes"
       .

       run-tests.
      *> [helpstart-test]
      *> cobweb-agar test
      *> Run internal tests, as a demo. Also acts as an example for
      *> using cobweb-agar features.
      *>
      *> See the run-tests paragraph inside the cobweb-agar.cob program.
      *> [helpend-test]

      *> Create initial window, which includes Core and GUI init
       move agar-window(AG-WINDOW-CENTER, numval(640), numval(720))
         to agar-win-record(1)

       move 4000 to down-time
       move agar-timer(agar-win(1), numval(0), down-time,
                       "timer", "timerevent")
         to rc
       if rc not equal zero then
           display "error: agar-timer failed " rc upon syserr
       end-if

      *> Show current user info
       set agar-user-ops-symbol to entry "agUserOps_posix"
       if agar-user-ops-symbol not equal null then
           call "AG_UserNew" returning agar-user-pointer
           set address of agar-user to agar-user-pointer
           move spaces to user-name

           set address of agar-user-ops to agar-user-ops-symbol
           if user-ops-getRealUser not equal null then
               call user-ops-getRealUser using
                   by value agar-user-pointer
                   returning rc
               display "User :" trim(user-name) ":"
               display "Home :" content-of(user-home) ":"
           end-if
       end-if

      *> Show CPU info
       call "AG_GetCPUInfo" using
           by reference ag-cpuinfo
           returning omitted
       display "Architecture: " content-of(cpu-arch)
       display "VendorID: " vendor-id
       call "AG_Printf" using
           by reference "%08X"
           by value cpu-ext
           returning cpu-ext-formatted
       display "CPU flags: " content-of(cpu-ext-formatted)

      *> Config information
       call "AG_ConfigObject" returning ag-config-object

       call "AG_GetInt" using
           by value ag-config-object
           by reference z"initial-run"
           returning initial-run
       move initial-run to show-initial-run
       display "initial-run: " show-initial-run

       call "AG_GetInt" using
           by value ag-config-object
           by reference z"no-confirm-quit"
           returning initial-run
       move initial-run to show-initial-run
       display "no-confirm-quit: " show-initial-run

       call "AG_GetString" using
           by value ag-config-object
           by reference z"load-path"
           by reference load-path-buffer
           by value size size-t length(load-path-buffer)
           returning agar-size-t
       display "load-path :"
               trim(substitute(load-path-buffer low-value space)) ":"

       call "AG_GetString" using
           by value ag-config-object
           by reference z"save-path"
           by reference save-path-buffer
           by value size size-t length(save-path-buffer)
           returning agar-size-t
       display "save-path :"
               trim(substitute(save-path-buffer low-value space)) ":"

       call "AG_SetString" using
           by value ag-config-object
           by reference z"save-path"
           by reference "/home/btiffin/junk/agar/"
           by value size size-t 24
           returning agar-variable
       display "Setting save-path"

       initialize save-path-buffer
       call "AG_GetString" using
           by value ag-config-object
           by reference z"save-path"
           by reference save-path-buffer
           by value size size-t length(save-path-buffer)
           returning agar-size-t
       display "save-path :"
               trim(substitute(save-path-buffer low-value space)) ":"

       call "AG_GetString" using
           by value ag-config-object
           by reference z"tmp-path"
           by reference tmp-path-buffer
           by value size size-t length(tmp-path-buffer)
           returning agar-size-t
       display "tmp-path :"
               trim(substitute(tmp-path-buffer low-value space)) ":"

      *> Load the application style sheet
       call "AG_LoadStyleSheet" using
           by reference null
           by reference "gnucobol.css"
           returning agar-stylesheet
       display "Loaded gnucobol.css"

       move agar-menu(agar-win(1), numval(0)) to agar-menu-record
       set address of ag-menu to agar-menu-widget
       move agar-menunode(menu-root, "File", null-pointer)
         to agar-menunode-record(1)
       move agar-menunode(menu-root, "GnuCOBOL", null-pointer)
         to agar-menunode-record(2)
       move agar-menunode(menu-root, "Help", null-pointer)
         to agar-menunode-record(3)

       move agar-menuaction(agar-menunode-widget(1), "Quit",
                            agar-static-icon("agIconClose"),
                            "windown", some-data)
         to agar-menuaction-record(1)

      *> Set up GnuCOBOL to launch a browser to site via pointer arg
       set some-data to address of site-buffer
       move agar-menuaction(agar-menunode-widget(2), "SourceForge",
                            agar-static-icon("agIconGear"),
                            "spawnbrowser", some-data)
         to agar-menuaction-record(2)

       move agar-menuaction(agar-menunode-widget(3), "agar-menu",
                            null-pointer, "miscellaneous", some-data)
         to agar-menuaction-record(3)
       move agar-menuaction(agar-menunode-widget(3), "agar-menunode",
                            null-pointer, "miscellaneous", some-data)
         to agar-menuaction-record(4)

                                    *> AG-BOX-HFILL + AG-BOX-HOMOGENOUS
       move agar-box(agar-win(1), AG-BOX-HORIZ, numval(3))
         to agar-box-record


       move agar-label(agar-box-widget, numval(0), "Hello, world")
         to agar-label-record(1)


       move agar-button(agar-box-widget, numval(0), z"Zoom In",
                        "miscellaneous", "zoom-in", numval(1))
         to agar-button-record(1)

       move agar-button(agar-box-widget, numval(0), z"Zoom Out",
                        "miscellaneous", "zoom-out", numval(-1))
         to agar-button-record(2)

      *> testing callbacks into main program ENTRY, yayy
       move agar-button(agar-box-widget, numval(0), z"thing",
                        "thing", "thing-button", numval(1))
         to agar-button-record(4)

       move agar-button(agar-box-widget, numval(0), z"Goodbye",
                        "windown", "goodbye-button", numval(1))
         to agar-button-record(3)


       move agar-textbox(agar-win(1), numval(0),
                         z"textbox:", work-buffer,
                         "textboxer", "agar-text-test")
         to agar-textbox-record(1)


       move agar-combo(agar-win(1), numval(8), z"combo:")
         to agar-combo-record
       set address of ag-combo to agar-combo-widget

       move agar-tlist-add(combo-tlist, null-pointer, z"Item one")
         to agar-tlist-record
       move agar-tlist-add(combo-tlist, null-pointer, z"Item two")
         to agar-tlist-record
       move agar-tlist-add(combo-tlist, null-pointer, z"Item three")
         to agar-tlist-record

       move agar-setevent(agar-combo-widget,
                          z"combo-selected",
                          "miscellaneous")
         to agar-event-record

                                   *> HFILL
       move agar-console(agar-win(1), numval(1)) to agar-console-record
       move agar-consolemsg(agar-console-widget, "cobweb-agar console")
         to agar-consolemsg-record
       move agar-consolemsg(agar-console-widget, current-date)
         to agar-consolemsg-record

                                  *> HFILL, NOBUTTONS
       move agar-dirdlg(agar-win(1), numval(1280), ".")
         to agar-dirdlg-record

      *> parent, flags, buffer, callback, fieldname, intonly, secret
       compute bit-flags = AG-EDITABLE-HFILL + AG-EDITABLE-EXCL
       move agar-editable(agar-win(1), bit-flags, edit-buffer,
                          "edithandler", "anytext")
         to agar-editable-record(1)

       compute bit-flags = AG-EDITABLE-HFILL + AG-EDITABLE-EXCL +
                            AG-EDITABLE-INT-ONLY
       move agar-editable(agar-win(1), bit-flags, num-buffer,
                          "edithandler", "num")
         to agar-editable-record(2)

       compute bit-flags = AG-EDITABLE-HFILL + AG-EDITABLE-EXCL +
                            AG-EDITABLE-PASSWORD
       move agar-editable(agar-win(1), bit-flags, pass-buffer,
                          "edithandler", "pass")
         to agar-editable-record(3)

       move agar-filedlg(agar-win(1), AG-FILEDLG-HFILL,
                         ".", MODULE-SOURCE())
         to agar-filedlg-record(1)

      *> FixedPlotter
       move agar-fixedplotter(agar-win(1), AG-PLOTTER-LINES, numval(15))
         to agar-plotter-record

       move agar-fixedplottercurve(agar-plotter-widget, z"plot-1",
                                   numval(0),             *> red
                                   numval(255),           *> green
                                   numval(0),             *> blue
                                   numval(2000))          *> limit
         to agar-curve-record

      *> fill the fixed plot with a sin wave to about 810 degrees worth
       perform varying looper from 0 by 0.1 until looper > 14.14
           compute agar-16bits = sin(looper) * 50
           move agar-fixedplotterdatum(agar-curve-widget, agar-16bits)
             to extraneous
       end-perform

      *> start decaying the wave
       move 50 to decay
       perform varying looper from 14.14 by 0.1 until looper > 35.35
           compute agar-16bits = sin(looper) * decay
           move agar-fixedplotterdatum(agar-curve-widget, agar-16bits)
             to extraneous
           compute decay = decay - 0.2
       end-perform

      *> display the window
       move agar-window-show(agar-win(1)) to extraneous


      *> New window for graph
       move agar-window(AG-WINDOW-UPPER-RIGHT, numval(640), numval(600))
         to agar-win-record(5)
       set save-window to agar-win(5)

      *> Graph, nodes and edges
       compute bit-flags = AG-GRAPH-HFILL + AG-GRAPH-NO-MOVE
       move agar-graph(agar-win(5), bit-flags) to agar-graph-record

      *> rectangle, default size, red
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(255), numval(128), numval(128))
         to agar-graphvertex-record(1)
      *> label with default color
       move agar-graphvertex-label(agar-graphvertex-widget(1),
                                  "Vertex 1")
         to extraneous

      *> (0,0) is centre of graph
       move agar-graphvertex-position(agar-graphvertex-widget(1),
                                      numval(-280), numval(-40))
         to extraneous

      *> green, default size
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(128), numval(255), numval(128))
         to agar-graphvertex-record(2)
       move agar-graphvertex-label(agar-graphvertex-widget(2),
                                  "Vertex 2")
         to extraneous
       move agar-graphvertex-position(agar-graphvertex-widget(2),
                                      numval(-80), numval(-20))
         to extraneous

       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(128), numval(128), numval(255))
         to agar-graphvertex-record(3)
       move agar-graphvertex-label(agar-graphvertex-widget(3),
                                  "Vertex 3")
         to extraneous
       move agar-graphvertex-position(agar-graphvertex-widget(3),
                                      numval(100), numval(20))
         to extraneous

      *> default color, smaller size
       move agar-graphvertex(agar-graph-widget, user-data,
                      AG-GRAPH-VERTEX-RECTANGLE, numval(25), numval(25))
         to agar-graphvertex-record(4)
       move agar-graphvertex-label(agar-graphvertex-widget(4),
                                  "Vertex 4")
         to extraneous
       move agar-graphvertex-position(agar-graphvertex-widget(4),
                                      numval(-120), numval(40))
         to extraneous

      *> black, circle, larger
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-CIRCLE, numval(60), numval(60),
                        numval(10), numval(10), numval(10))
         to agar-graphvertex-record(5)
      *> white label
       move agar-graphvertex-label(agar-graphvertex-widget(5),
                                  "Vertex 5",
                                  numval(10), numval(10), numval(255))
         to extraneous
       move agar-graphvertex-position(agar-graphvertex-widget(5),
                                      numval(200), numval(-30))
         to extraneous

      *> edges
       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(1),
                      agar-graphvertex-widget(2),
                      user-data)
         to agar-graphedge-record(1)
       move agar-graphedge-label(agar-graphedge-widget(1), "Edge 1")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(3),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(2)
       move agar-graphedge-label(agar-graphedge-widget(2), "Edge 2")
         to extraneous

       *> default color on edge and label
       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(4),
                      user-data)
         to agar-graphedge-record(3)
       move agar-graphedge-label(agar-graphedge-widget(3), "Edge 3")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(5),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(4)
       move agar-graphedge-label(agar-graphedge-widget(4), "Edge 4")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(3),
                      agar-graphvertex-widget(5),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(5)
       move agar-graphedge-label(agar-graphedge-widget(5), "Edge 5",
                                 numval(250), numval(250), numval(250))
         to extraneous

       move agar-label(agar-win(5), numval(1), "Fixed position graph")
         to agar-label-record(1)

      *> Separator between graphs
       move agar-separator(agar-win(5), numval(0), numval(1), numval(8))
         to agar-separator-record

       move agar-label(agar-win(5), numval(1), "Auto positioned graph")
         to agar-label-record(1)
       move agar-button(agar-win(5), numval(0), z"Save Graph",
                        "savegraph", "graphsaver", numval(1))
         to agar-button-record(6)

      *> Second graph, autoplace Graph, nodes and edges
       move agar-graph(agar-win(5), AG-GRAPH-EXPAND)
         to agar-graph-record

      *> rectangle, default size, red
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(255), numval(128), numval(128))
         to agar-graphvertex-record(1)
      *> label with default color
       move agar-graphvertex-label(agar-graphvertex-widget(1),
                                  "Vertex 1")
         to extraneous

      *> (0,0) is centre of graph
      *> move agar-graphvertex-position(agar-graphvertex-widget(1),
      *>                                numval(-280), numval(-40))
      *>   to extraneous

      *> green, default size
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(128), numval(255), numval(128))
         to agar-graphvertex-record(2)
       move agar-graphvertex-label(agar-graphvertex-widget(2),
                                  "Vertex 2")
         to extraneous
      *> move agar-graphvertex-position(agar-graphvertex-widget(2),
      *>                                numval(-80), numval(-20))
      *>   to extraneous

       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-RECTANGLE, numval(0), numval(0),
                        numval(128), numval(128), numval(255))
         to agar-graphvertex-record(3)
       move agar-graphvertex-label(agar-graphvertex-widget(3),
                                  "Vertex 3")
         to extraneous
      *> move agar-graphvertex-position(agar-graphvertex-widget(3),
      *>                                numval(100), numval(20))
      *>   to extraneous

      *> default color, smaller size
       move agar-graphvertex(agar-graph-widget, user-data,
                      AG-GRAPH-VERTEX-RECTANGLE, numval(25), numval(25))
         to agar-graphvertex-record(4)
       move agar-graphvertex-label(agar-graphvertex-widget(4),
                                  "Vertex 4")
         to extraneous
      *> move agar-graphvertex-position(agar-graphvertex-widget(4),
      *>                                numval(-120), numval(40))
      *>   to extraneous

      *> black, circle, larger
       move agar-graphvertex(agar-graph-widget, user-data,
                        AG-GRAPH-VERTEX-CIRCLE, numval(60), numval(60),
                        numval(10), numval(10), numval(10))
         to agar-graphvertex-record(5)
      *> white label
       move agar-graphvertex-label(agar-graphvertex-widget(5),
                                  "Vertex 5",
                                  numval(10), numval(10), numval(255))
         to extraneous
      *> move agar-graphvertex-position(agar-graphvertex-widget(5),
      *>                                numval(200), numval(-30))
      *>   to extraneous

      *> edges
       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(1),
                      agar-graphvertex-widget(2),
                      user-data)
         to agar-graphedge-record(1)
       move agar-graphedge-label(agar-graphedge-widget(1), "Edge 1")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(3),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(2)
       move agar-graphedge-label(agar-graphedge-widget(2), "Edge 2")
         to extraneous

       *> default color on edge and label
       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(4),
                      user-data)
         to agar-graphedge-record(3)
       move agar-graphedge-label(agar-graphedge-widget(3), "Edge 3")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(2),
                      agar-graphvertex-widget(5),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(4)
       move agar-graphedge-label(agar-graphedge-widget(4), "Edge 4")
         to extraneous

       move agar-graphedge(agar-graph-widget,
                      agar-graphvertex-widget(3),
                      agar-graphvertex-widget(5),
                      user-data,
                      numval(255), numval(128), numval(128))
         to agar-graphedge-record(5)
       move agar-graphedge-label(agar-graphedge-widget(5), "Edge 5",
                                 numval(250), numval(250), numval(250))
         to extraneous

      *> Graphs can be autopositioned
       call "AG_GraphAutoPlace" using
           by value agar-graph-widget
           by value 500 300

       move agar-window-show(agar-win(5))
         to extraneous

      *> Second window
       move agar-window(AG-WINDOW-LOWER-RIGHT,
                        numval(600), numval(680), "Second window")
         to agar-win-record(2)

      *> show an image
       move agar-pixmap-file(agar-win(2), numval(0), "images/Logo.png")
         to agar-pixmap-record(1)

      *> a font selector with preview
       move agar-fontselector(agar-win(2), AG-FONTSELECTOR-HFILL)
         to agar-fontselector-record

      *> get a copy of the default font, using 100%, bind to selector
       call "AG_TextFontPct" using by value 100 returning agar-font
       move agar-bindvariable(agar-fontselector-widget, "font",
                              agar-font)
         to agar-variable-record

      *> Hue Saturation Value colour editor
       move agar-hsvpal(agar-win(2), AG-HSVPAL-HFILL)
         to agar-hsvpal-record

      *> Mpane multi pane view                *> HFILL, FRAMES
      *> BWT HERE NOT WORKING
      *> move agar-mpane(agar-win(2), AG-MPANE2H, numval(0))
      *>   to agar-mpane-record
      *> set address of ag-mpane to agar-mpane-widget

      *> move agar-label(panes(1), numval(0), "Label in an MPane")
      *>   to agar-label-record(3)
      *> move agar-hsvpal(panes(2), AG-HSVPAL-HFILL)
      *>   to agar-hsvpal-record-2

       move agar-notebook(agar-win(2), AG-NOTEBOOK-HFILL)
         to agar-notebook-record
       move agar-notebook-add(agar-notebook-widget, "Tab 1",
                              AG-BOX-HORIZ)
         to agar-notebook-tab-record(1)
                           *> HFILL, EXCL
       move agar-numerical(agar-notebook-tab-widget(1),
                           numval(9), "cm", "Numerical:", some-integer)
         to agar-numerical-record(1)

       move agar-notebook-add(agar-notebook-widget, "Tab 2",
                              AG-BOX-HORIZ)
         to agar-notebook-tab-record(2)
       move agar-label(agar-notebook-tab-widget(2), numval(0),
                       "Label for tab two")
         to agar-label-record(2)

      *> Pane split view
       move agar-pane(agar-win(2), AG-BOX-HORIZ, numval(1))
         to agar-pane-record

      *> put a label in a div
       set address of ag-pane to agar-pane-widget
       move agar-label(divs(1), numval(0), "Pane Label 1")
         to agar-label-record(4)
      *> put a Numerical in the other div
       move agar-numerical(divs(2),
                           numval(9), "cm", "Pane Number", some-integer)
         to agar-numerical-record(2)

      *> Progressbar (linked to slider via value)   *> HFILL, SHOW
       move agar-progressbar(agar-win(2), numval(0), numval(5),
                             progress-value, progress-min, progress-max)
         to agar-progressbar-record


      *> Radio button group        HFILL
       set radio-items(1) to address of item-1
       set radio-items(2) to address of item-2
       set radio-items(3) to address of item-3
       set radio-items(4) to address of item-4
       set radio-items(5) to null
       move agar-radio(agar-win(2), numval(1), radio-array, radio-value)
         to agar-radio-record

      *> Separator, lined or spacer
       move agar-separator(agar-win(2), numval(0), numval(1), numval(4))
         to agar-separator-record

      *> Slider (signed 32bit)      HORIZ      HFILL
       move 3 to slider-inc
       move agar-slider(agar-win(2), numval(0), numval(1),
                        progress-value, progress-min, progress-max,
                        slider-inc)
         to agar-slider-record

      *> Checkbox
       move agar-checkbox(agar-win(2), numval(0), z"Check bits:",
                          checkbox-bits, checkbox-bitmask,
                          "miscellaneous", "checkbox", numval(1))
         to agar-checkbox-record(1)

      *> show second window
       move agar-window-show(agar-win(2)) to extraneous

      *> third window
       move agar-window(AG-WINDOW-UPPER-LEFT,
                        numval(600), numval(680), "Third window")
         to agar-win-record(3)

       move agar-button(agar-win(3), numval(0), z"Quit",
                        "windown", "goodbye-button", numval(1))
         to agar-button-record(5)

       move agar-label(agar-win(3), numval(0), "A third window")
         to agar-label-record(5)

       compute bit-flags = AG-TABLE-MULTI
       move agar-table(agar-win(3), bit-flags, numval(600), numval(12))
         to agar-table-record

      *> move agar-table-addcol(agar-table-widget,
      *>                        z"A string",
      *>                        z"100px",
      *>                        spaces)
      *>   to rc
      *> display "AddCol: " rc
      *> move agar-table-addcol(agar-table-widget,
      *>                        z"A number",
      *>                        z"80px",
      *>                        spaces)
      *>   to rc
      *> display "AddCol: " rc
      *> move agar-table-addcol(agar-table-widget,
      *>                        z"Another string",
      *>                        spaces,
      *>                        spaces)
      *>   to rc
      *> display "AddCol: " rc

      *> table row adds will resist use from User Defined Functions
      *> due to need of vararg functionality.  CALL is the way forward

       call "AG_TableAddCol" using
           by value agar-table-widget
           by reference z"A string"
           by reference z"100px"
           by reference null
           returning rc

       call "AG_TableAddCol" using
           by value agar-table-widget
           by reference z"A number"
           by reference z"80px"
           by reference null
           returning rc

       call "AG_TableAddCol" using
           by value agar-table-widget
           by reference z"Another string"
           by reference null
           by reference null
           returning rc

       call "AG_TableBegin" using
           by value agar-table-widget
           returning omitted

       perform varying rower from 1 by 1 until rower > 16
           call "AG_TableAddRow" using
               by value agar-table-widget
               by reference z"%s:%d:%s"
               by reference concatenate("Row " rower low-value)
               by value rower
               by reference concatenate("Row " rower z" third,column")
               returning rc
       end-perform

       call "AG_TableEnd" using
           by value agar-table-widget
           returning omitted


      *> scrollview with an image
       move agar-scrollview(agar-win(3), numval(h'2'),
                            numval(200), numval(100), numval(10))
         to agar-scrollview-record(1)

      *> show an image
       move agar-pixmap-file(agar-scrollview-widget(1), numval(0),
                        "images/linux-symbol-hi.png")
         to agar-pixmap-record(3)

      *> show third window
       move agar-window-show(agar-win(3)) to extraneous

      *> fixed size and positioning
       move agar-window(AG-WINDOW-LOWER-CENTER,
                        numval(400), numval(480), "Fourth window")
         to agar-win-record(4)

       move agar-fixed(agar-win(4), AG-FIXED-EXPAND)
         to agar-fixed-record

      *> create an unattached label
       move agar-label(null-pointer, numval(1), "Grace Hopper, 1978")
         to agar-label-record(7)
       move agar-fixed-put(agar-fixed-widget, agar-label-widget(7),
                           numval(0), numval(10))
         to extraneous
       move agar-fixed-size(agar-fixed-widget, agar-label-widget(7),
                           numval(200), numval(20))
         to extraneous

       move agar-scrollview(null-pointer, numval(h'23'),
                            numval(400), numval(200), numval(10))
         to agar-scrollview-record(2)
       move agar-fixed-put(agar-fixed-widget, agar-scrollview-widget(2),
                           numval(0), numval(30))
         to extraneous
       move agar-fixed-size(agar-fixed-widget,
                            agar-scrollview-widget(2),
                            numval(400), numval(200))
         to extraneous
       move agar-pixmap-file(agar-scrollview-widget(2), numval(0),
                       "images/Grace-Hopper-office-by-Lynn-Gilbert.jpg")
         to agar-pixmap-record(4)

       move agar-label(null-pointer, numval(1),
                       "Free to use image by Lynn Gilbert")
         to agar-label-record(8)
       move agar-fixed-put(agar-fixed-widget, agar-label-widget(8),
                           numval(180), numval(232))
         to extraneous
       move agar-fixed-size(agar-fixed-widget, agar-label-widget(8),
                           numval(300), numval(20))
         to extraneous

       move agar-textbox(null-pointer, numval(h'61'),
                         spaces, text-msg,
                         "textboxer", "agar-multi-text")
         to agar-textbox-record(2)
       move agar-fixed-put(agar-fixed-widget, agar-textbox-widget(2),
                           numval(0), numval(262))
         to extraneous
       move agar-fixed-size(agar-fixed-widget, agar-textbox-widget(2),
                           numval(400), numval(200))
         to extraneous

       set treetbl-data-function to entry "treetbl"
       if treetbl-data-function not equal null then
           compute bit-flags = AG-TREETBL-MULTI +AG-TREETBL-HFILL
           move agar-treetbl(agar-win(3), bit-flags,
                             null-pointer, null-pointer,
                             numval(600), numval(12))
             to agar-treetbl-record

           call "AG_TreetblAddCol" using
               by value agar-treetbl-widget
               by value 0
               by reference z"120px"
               by reference z"First"
               by reference null
               returning rc

           call "AG_TreetblAddCol" using
               by value agar-treetbl-widget
               by value 1
               by reference z"180px"
               by reference z"Second Column"
               by reference null
               returning rc

           call "AG_TreetblAddCol" using
               by value agar-treetbl-widget
               by value 2
               by reference z"160px"
               by reference z"Third"
               by reference null
               returning rc

           call "AG_TreetblAddCol" using
               by value agar-treetbl-widget
               by value 3
               by reference z"80px"
               by reference z"A number"
               by reference null
               returning rc

           perform varying rower from 1 by 1 until rower > 4
               add 1 to row-id
               call "AG_TreetblAddRow" using
                   by value agar-treetbl-widget
                   by reference null
                   by value numval(row-id)
                   by reference z"%s"
                   by value 0
                   by reference concatenate("Tree " rower low-value)
                   returning a-row(rower)

               call "AG_TreetblExpandRow" using
                   by value agar-treetbl-widget
                   by value a-row(rower)

               perform varying coler from 1 by 1 until coler > 4
                   add 1 to row-id
                   call "AG_TreetblAddRow" using
                       by value agar-treetbl-widget
                       by value a-row(rower)
                       by value row-id
                       by reference z"%s,%s,%s,%s"
                       by value 0
                       by reference concatenate("Col 1 " rower ", "
                                                coler low-value)
                       by value 1
                       by reference concatenate("Col 2 " rower ", "
                                                coler low-value)
                       by value 2
                       by reference concatenate("Col 3 " rower ", "
                                                coler low-value)
                       by value 3
                       by reference row-id
                       returning rc
               end-perform
           end-perform

           add 100 to row-id
           call "AG_TreetblAddRow" using
               by value agar-treetbl-widget
               by reference null
               by value row-id
               by reference z"%s"
               by value 0
               by reference "row_id + 100"
               returning a-row(2)
           call "AG_TreetblExpandRow" using
               by value agar-treetbl-widget
               by value a-row(2)

           perform varying rower from 1 by 1 until rower > 8
               add 1 to row-id
               call "AG_TreetblAddRow" using
                   by value agar-treetbl-widget
                   by value a-row(2)
                   by value row-id
                   by reference z"%s,%s,%s,%d"
                   by value 0
                   by reference concatenate("Col 1 " rower low-value)
                   by value 1
                   by reference concatenate("Col 2 " rower low-value)
                   by value 2
                   by reference concatenate("Col 3 " rower low-value)
                   by value 3
                   by reference rower
                   returning rc
           end-perform
       end-if

       move agar-window-show(agar-win(4)) to extraneous


      *> run the event loop until run down
      *>  (close with sysmenu or Goodbye button)
       move agar-eventloop() to rc
       if rc not equal 0 then
           display "warning: eventloop non-zero " rc upon syserr
       end-if

      *> Custom event loop, not ready, symbols are not exported??
      *> call "AG_WindowDrawQueued" returning omitted
      *> call "AG_PendingEvents" using null returning rc
      *> if rc not equal zero then
      *>     call "AG_GetNextEvent" using null driver-event
      *>          returning rc
      *>     if rc equal 1 then
      *>         call "AG_ProcessEvent" using null driver-event
      *>             returning rc
      *>     end-if
      *> end-if
      *> call "AG_WindowProcessQueued" returning omitted
       call "AG_GetString" using
           by value agar-win(1)
           by reference z"font-family"
           by reference font-family-buffer
           by value size size-t length(font-family-buffer)
       display "font-family :"
               trim(substitute(font-family-buffer low-value space)) ":"

       display "shared-data :" shared-data ":"
       display "Radio: " radio-value

      *> display "Table:"
      *> call "CBL_GC_HOSTED" using stdout "stdout"
      *> call "AG_TableSaveASCII" using
      *>     by value agar-table-widget
      *>     by value stdout
      *>     by value sep-char

       call "AG_ListDriverNames" using
           by reference driverlist-buffer
           by value length(driverlist-buffer)
       display "Available graphic drivers :"
               trim(substitute(driverlist-buffer low-value space)) ":"

      *> clean up (should these be functions?)
       call "AG_DestroyGraphics" returning omitted
       call "AG_Destroy" returning omitted
       .


      *> DataSource operations
       try-filing.
       move agar-open-file("cobweb-agar.cob", "r")
         to agar-datasource-record
       display "OpenFile: " agar-datasource
       move 32 to read-len
       move agar-read-pic(agar-datasource, ds-buffer, read-len,
                          read-actual)
         to rc
       if rc equal zero then
           display "read for 32: " ds-buffer(1:read-actual) ":, " rc
       else
           display "read-pic failed: " rc upon syserr
           move agar-get-error() to error-record
           display "agar-error :" content-of(error-reference) ":"
              upon syserr
       end-if
       move 470 to read-pos
       move agar-read-at-pic(agar-datasource, ds-buffer, read-len,
                      read-pos, read-actual)
         to rc
       if rc equal zero then
           display "read at 470: " ds-buffer(1:read-actual) ":, " rc
                   ", " read-actual
       end-if
       move agar-close-datasource(agar-datasource) to extraneous

      *> Memory buffer
       move length(core-buffer) to core-len
       move agar-open-core-pic(core-buffer, core-len, numval(0))
         to agar-datasource-record
       move 40 to read-len
       move 0 to read-actual
       move agar-read-pic(agar-datasource, ds-buffer, read-len,
                          read-actual)
         to rc
       if rc equal zero and read-actual > 0 then
           display "Memory datasource: " ds-buffer(1:read-actual)
                   ":, " rc ", " read-actual
       else
           display "Core rc: " rc
       end-if
       move agar-close-datasource(agar-datasource) to extraneous

      *> Automatic allocation memory buffer
       move all quotes to ds-buffer
       move 0 to core-len
       move agar-open-core(null-pointer, core-len, numval(0))
         to agar-datasource-record
       move 1024 to write-len
       move agar-write-pic(agar-datasource, ds-buffer, write-len,
                       write-actual)
         to rc
       move agar-write-pic(agar-datasource, ds-buffer, write-len,
                       write-actual)
         to rc
       move agar-write-pic(agar-datasource, ds-buffer, write-len,
                       write-actual)
         to rc
       display "automatic memory write (all quotes): " rc
               ", " write-actual
       move all spaces to ds-buffer

       move 1024 to read-len
       move 0 to read-actual read-pos
       move agar-read-at-pic(agar-datasource, ds-buffer, read-len,
                         read-pos, read-actual)
         to rc
       if rc equal zero and read-actual > 0 then
           display "read from auto allocated (refmod to 40): "
                   ds-buffer(1:40) ":, " rc ", " read-actual
       else
           display "Auto rc: " rc
       end-if
       move agar-close-datasource(agar-datasource) to extraneous
       .


      *> experiment with inline ENTRY for callbacks
      *> BWT HERE
       marker.
       display "got here by fall through"
       stop run

       entry "thing" using by value event-thing.
       display "in the thing"
       display "shared-data :" shared-data ":"
       display "event-thing: " event-thing
       set address of ag-event to event-thing
       display "raw event :" substitute(event-name, x"00", space) ":"
       string event-name delimited by low-value into show-event
       display "event :" trim(show-event) ":"
       goback.

       end program cobweb-agar-gui.
      *> ***************************************************************


       identification division.
       program-id. windown.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

      *> passed an event
       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.

      *> window detached, end the event loop
       call "AG_Terminate" using by value 0 returning omitted

       goback.
       end program windown.
      *> ***************************************************************


       identification division.
       program-id. textboxer.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function all intrinsic.

      *> passed an event pointer, ag-event is a fielded based data def
       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:
       01 event-spaced                 pic x(32).
       01 variable-spaced              pic x(40).
       01 change-count                 usage binary-long.
       01 show-change-count            pic z(8)9.

       01 shared-data                  pic x(40) external.

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.

      *> textbox events, assumes event includes a pointer to user data
       if (evnt not omitted) and (evnt not equal null) then
           set address of ag-event to evnt

           *> event structure is null byte filled
           initialize event-spaced variable-spaced
           string event-name delimited by low-value into event-spaced
           string variable-name(2) delimited by low-value
             into variable-spaced

           if event-spaced equals "textbox-postchg" then
               add 1 to change-count
           end-if

           *> event variable 1 is for the associated widget
           *> event variable 2 is the user data
           if event-spaced equals "textbox-return" then
               move change-count to show-change-count
               display "field: " trim(variable-spaced)
                       " changed " trim(show-change-count) " time"
                       with no advancing
               if change-count equal 1 then
                   display "."
               else
                   display "s."
               end-if
               display "textbox buffer now :"
                       content-of(variable-ptr(2)) ":"
               move content-of(variable-ptr(2)) to shared-data
           end-if
       end-if

       goback.
       end program textboxer.
      *> ***************************************************************


       identification division.
       program-id. edithandler.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function all intrinsic.

      *> passed an event pointer, ag-event is a fielded based data def
       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:
       01 event-spaced                 pic x(32).
       01 variable-spaced              pic x(40).
       01 change-count                 usage binary-long.
       01 cursor-count                 usage binary-long.
       01 show-change-count            pic z(8)9.

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.

      *> textbox events, assumes event includes a pointer to user data
       if (evnt not omitted) and (evnt not equal null) then
           set address of ag-event to evnt

           *> event structure is null byte filled
           initialize event-spaced variable-spaced
           string event-name delimited by low-value into event-spaced
           string variable-name(2) delimited by low-value
             into variable-spaced

           if event-spaced equals "editable-prechg" then
               add 1 to cursor-count
           end-if
           if event-spaced equals "editable-postchg" then
               add 1 to change-count
           end-if

           *> event variable 1 is for the associated widget
           *> event variable 2 is the user data
           if event-spaced equals "editable-return" then
               move change-count to show-change-count
               display "edit field: " trim(variable-spaced)
                       " changed " trim(show-change-count) " time"
                       with no advancing
               if change-count equal 1 then
                   display "."
               else
                   display "s."
               end-if
               move cursor-count to show-change-count
               display "edit field: " trim(variable-spaced)
                       " cursored " trim(show-change-count) " time"
                       with no advancing
               if cursor-count equal 1 then
                   display "."
               else
                   display "s."
               end-if
               display "edit buffer now :"
                       function content-of(variable-ptr(2)) ":"
           end-if
       end-if

       goback.
       end program edithandler.
      *> ***************************************************************


       identification division.
       program-id. miscellaneous.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function agar-zoom
           function all intrinsic.

      *> passed an event
       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:
       01 extraneous                 usage binary-long.
       01 event-spaced               pic x(32).
       01 variable-spaced            pic x(40).

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.

      *> miscellaneous events, assumes event includes user data
       if (evnt not omitted) and (evnt not equal null) then
           set address of ag-event to evnt

           *> event structure is null byte filled
           initialize event-spaced variable-spaced
           string event-name delimited by low-value into event-spaced
           string variable-name(2) delimited by low-value
             into variable-spaced

           if event-spaced equals "button-pushed" then
               if variable-spaced equals "pushed-zoom-in" then
                   move agar-zoom(numval(1)) to extraneous
               else
                   move agar-zoom(numval(-1)) to extraneous
               end-if
           end-if
           if event-spaced equals "checkbox-changed" then
                   display variable-spaced
           end-if
       end-if
       goback.
       end program miscellaneous.
      *> ***************************************************************


       identification division.
       program-id. spawnbrowser.

       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function agar-execute
           function all intrinsic.

      *> passed an event
       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:
       01 event-spaced               pic x(32).
       01 variable-spaced            pic x(40).

       01 argv0.
          05 value z"env".
       01 xdg-open.
          05 value z"xdg-open".
       01 argv.
          05 args          occurs 4 times usage pointer.
       01 browser-pid                usage binary-long.

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.
       display "in spawnbrowser with " evnt
      *> menu events, assumes event includes user data
       if (evnt not omitted) and (evnt not equal null) then
           set address of ag-event to evnt

           *> event structure is null byte filled
           initialize event-spaced variable-spaced
           string event-name delimited by low-value into event-spaced
           string variable-name(2) delimited by low-value
             into variable-spaced
           display "spawnbrowser :" trim(event-spaced) ":"
                   trim(variable-spaced) ": " variable-ptr(2)
           display "browsing :" content-of(variable-ptr(2)) ":"
           set args(1) to address of argv0
           set args(2) to address of xdg-open
           set args(3) to variable-ptr(2)
           set args(4) to null
           call "AG_Execute" using
               by reference z"/usr/bin/env"
               by reference argv
               returning browser-pid
           display "Browser pid: " browser-pid
           move agar-execute(z"ls", z"-l") to browser-pid
           display "ls pid: " browser-pid
       end-if

       goback.
       end program spawnbrowser.
      *> ***************************************************************


       identification division.
       program-id. timerevent.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function all intrinsic.

      *> passed an event
       data division.
       working-storage section.
       01 occurrences                usage binary-long.
       01 down-time                  usage binary-long external.
       01 ag-timer based.
          :AGAR-TIMER:

       01 ag-event based.
          :AGAR-EVENT:
       01 event-spaced               pic x(32).
       01 variable-spaced            pic x(40).

       linkage section.
       01 timer usage pointer.
       01 evnt  usage pointer.

       procedure division extern using
           by value timer
           by value evnt.

      *> miscellaneous events, assumes event includes user data
      *> if (evnt not omitted) and (evnt not equal null) and
      *>    (timer not omitted) and (timer not equal null) then
      *>     set address of ag-event to evnt
      *>     set address of ag-timer to timer
      *> end-if

       add 1 to occurrences
       display "timer: " occurrences ", " down-time
       divide down-time by 2 giving down-time return-code
       if down-time equal zero then
           display "timer will now cancel"
       end-if

       goback.
       end program timerevent.
      *> ***************************************************************


       identification division.
       program-id. timerfinal.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       repository.
           function all intrinsic.

      *> passed an event
       data division.
       working-storage section.
       01 occurrences                usage binary-long.
       01 down-time                  usage binary-long external.
       01 ag-timer based.
          :AGAR-TIMER:

       01 ag-event based.
          :AGAR-EVENT:
       01 event-spaced               pic x(32).
       01 variable-spaced            pic x(40).

       linkage section.
       01 timer usage pointer.
       01 evnt usage pointer.

       procedure division extern using
           by value timer
           by value evnt.

      *> miscellaneous events, assumes event includes user data
      *> if (evnt not omitted) and (evnt not equal null) and
      *>    (timer not omitted) and (timer not equal null) then
      *>     set address of ag-event to evnt
      *>     set address of ag-timer to timer
      *> end-if

       add 1 to occurrences
       display "timer: " occurrences ", " down-time
       divide down-time by 2 giving down-time return-code
       if down-time equal zero then
           display "timer will now cancel, terminating eventloop"
           call "AG_Terminate" using by value 0 returning omitted
       end-if

       goback.
       end program timerfinal.


      *> ***************************************************************
       identification division.
       program-id. treetbl.

      *> This is a callback from C, and needs an extern call-convention
       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       data division.
       working-storage section.
       01 made-up-data.
          05 made-up-col               pic 99.
          05 made-up-row               pic 99.
          05 filler value x"00".

       linkage section.
       01 agar-treetbl                 usage pointer.
       01 treetbl-col                  usage binary-long.
       01 treetbl-row                  usage binary-long.
       01 cell-data-mock               pic x(8).
       01 cell-data redefines cell-data-mock usage pointer.

       procedure division extern using
           by value agar-treetbl
           by value treetbl-col
           by value treetbl-row
           returning cell-data-mock.

       move treetbl-col to made-up-col
       move treetbl-row to made-up-row
       set cell-data to address of made-up-data

       display "row: " treetbl-row ", col: " treetbl-col

       goback.
       end program treetbl.
      *> ***************************************************************


      *> Called from button on graph page
       identification division.
       program-id. savegraph.

       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.

       data division.
       working-storage section.
       01 ag-event based.
          :AGAR-EVENT:

      *> FIX THIS
       01 AG-OBJECT-NAME-MAX constant as 64.

       01 an-object based.
          :AGAR-OBJECT:

       01 rc                        usage binary-long.
       01 agar-graph-record         external.
          05 agar-graph-widget      usage pointer.

      *> the window
       01 save-window               usage pointer external.

       linkage section.
       01 evnt usage pointer.

       procedure division extern using by value evnt returning omitted.

       if agar-graph-widget not equal null then
           set address of an-object to agar-graph-widget
           display "Graph widget flags: " object-flags
           *> move h'3000' to object-flags

           call "AG_ObjectSaveToFile" using
               by value agar-graph-widget
               by reference "./AgarGraph.dat"
               returning rc
           display "Saved Auto Graph to AgarGraph.dat: ", rc

           call "AG_ObjectSaveAll" using
               by value agar-graph-widget
               returning rc
           display "Graph SaveAll: ", rc
       end-if

       if save-window not equal null then
           call "AG_ObjectSaveToFile" using
               by value save-window
               by reference "./AgarWindow-5.dat"
               returning rc
           display "Saved agar-win(5) to AgarWindow-5.dat: ", rc

           call "AG_ObjectSaveAll" using
               by value save-window
               returning rc
           display "agar-win(5) SaveAll: ", rc
       end-if

       goback.
       end program savegraph.
      *> ***************************************************************


       identification division.
       function-id. agar-window.

       data division.
       working-storage section.
       01 win-down                     usage program-pointer.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-window]
      *> [helpstart-agar-window]
      *> function agar-window(
       01 window-position          usage binary-long.
       01 window-width             usage binary-long.
       01 window-height            usage binary-long.
       01 window-title             pic x any length.
      *> ) returning
       01 agar-win-record.
          05 agar-win              usage pointer.

      *> Create a new top level Agar window.
      *>
      *> Returns a window pointer, which will be null on failure.
      *>
      *> libagar-core and libagar-gui are initialized if required.
      *> A close event handler is attached via AG_SetEvent.
      *>
      *> See 'man 3 AG_Window' for more details.
      *> [helpend-agar-window]
      *> [helpend-window]

       procedure division using
           window-position
           window-width
           window-height
           optional window-title
           returning agar-win-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       if not agar-gui-ready then
           call "AG_InitGraphics" using by reference null returning rc
               on exception
                   display "error: no libagar-gui" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitGraphics failure " rc upon syserr
               goback
           end-if
           call "AG_BindStdGlobalKeys" returning omitted
           set agar-gui-ready to true
       end-if

      *> Create a window
       call "AG_WindowNew" using by value 0 returning agar-win

       if window-title is omitted then
           call "AG_WindowSetCaption" using
               by value agar-win
               by reference z"cobweb-agar"
       else
           if window-title not equal spaces then
               call "AG_WindowSetCaption" using
                   by value agar-win
                   by reference
                       function concatenate(window-title low-value)
           end-if
       end-if

      *> Attach a run down
       set win-down to entry "windown"
       if win-down equal null then
           display "error: windown entry not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-win
               by reference "window-detached"
               by value win-down
               by reference null
       end-if

      *> Set the size, aligned to given position
       call "AG_WindowSetGeometryAligned" using
           by value agar-win
           by value window-position
           by value window-width
           by value window-height
           returning omitted
       end-call

       goback.
       end function agar-window.
      *> ***************************************************************


       identification division.
       function-id. agar-window-show.

       data division.
       linkage section.
      *> [helpstart-window-show]
      *> function agar-window-show(
       01 agar-parent                  usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Show the given window.
      *>
      *> See 'man 3 AG_Window' for more details.
      *> [helpend-window-show]

       procedure division using
           agar-parent
           returning extraneous.

       call "AG_WindowShow" using
           by value agar-parent
           returning omitted

       move 0 to extraneous

       goback.
       end function agar-window-show.
      *> ***************************************************************


       identification division.
       function-id. agar-window-hide.

       data division.
       linkage section.
      *> [helpstart-window-hide]
      *> function agar-window-hide(
       01 agar-parent                  usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Hide the given window.
      *>
      *> See 'man 3 AG_Window' for more details.
      *> [helpend-window-hide]

       procedure division using
           agar-parent
           returning extraneous.

       call "AG_WindowHide" using
           by value agar-parent
           returning omitted

       move 0 to extraneous

       goback.
       end function agar-window-hide.
      *> ***************************************************************


       identification division.
       function-id. agar-zoom.

       data division.
       linkage section.
      *> [helpstart-zoom]
      *> function agar-windowzoom(
       01 zoom-state                   usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Zoom in (zoom-state positive), Zoom out (zoom-state negative)
      *>   or Zoom Reset (zoom-state zero) the given window
      *>
      *> See 'man 3 AG_Window' for more details.
      *> [helpend-zoom]

       procedure division using
           zoom-state
           returning extraneous.

       *> display "zoom-state: " zoom-state
       if zoom-state is positive then
           call "AG_ZoomIn" returning omitted
       else
           if zoom-state is negative then
               call "AG_ZoomOut" returning omitted
           else
               call "AG_ZoomReset" returning omitted
           end-if
       end-if
       move 0 to extraneous

       goback.
       end function agar-zoom.
      *> ***************************************************************


       identification division.
       function-id. agar-setevent.

       data division.
       working-storage section.
       01 event-handler                usage program-pointer.

       linkage section.
      *> [helpstart-setevent]
      *> [helpstart-agar-setevent]
      *> function agar-setevent(
       01 agar-object                  usage pointer.
       01 agar-event-name              pic x any length.
       01 handler-name                 pic x any length.
      *> ) returning
       01 agar-event-record.
          05 agar-event                usage pointer.

      *> Attachs an event handler (by program name) to a libagar object
      *> given a named event.
      *>
      *> See also: help agar-setevent-with-field
      *> [helpend-agar-setevent]
      *> [helpend-setevent]

       procedure division using
           agar-object
           agar-event-name
           handler-name
           returning agar-event-record.

      *> Attach an event handlder
       set event-handler to entry handler-name
       if event-handler equal null then
           display "error: " agar-event-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-object
               by reference agar-event-name
               by value event-handler
               by reference null
               returning agar-event
       end-if

       goback.
       end function agar-setevent.
      *> ***************************************************************


       identification division.
       function-id. agar-eventname.

       data division.
       working-storage section.
       01 event-structure              pic x(32) based.

       linkage section.
      *> [helpstart-eventname]
      *> function agar-eventname(
       01 evnt                        usage pointer.
      *> ) returning
       01 eventname                    pic x(32).

      *> Return the name of the given event.
      *>
      *> See 'man 3 AG_Event' for more details.
      *> [helpend-eventname]

       procedure division using
           by value evnt
           returning eventname.

      *> Event structure starts with event name
       initialize eventname
       if evnt equal null then
           display "error: invalid event" upon syserr
       else
           set address of event-structure to evnt
           string event-structure delimited by low-value into eventname
       end-if

       goback.
       end function agar-eventname.
      *> ***************************************************************


       identification division.
       function-id. agar-setevent-with-field.

       data division.
       working-storage section.
       01 event-handler                usage program-pointer.

       linkage section.
      *> [helpstart-agar-setevent-with-field]
      *> agar-setevent-with-field(
       01 agar-object                  usage pointer.
       01 agar-event-name              pic x any length.
       01 handler-name                 pic x any length.
       01 field-name                   pic x any length.
       01 field-address                usage pointer.
      *> ) returning
       01 agar-event-record.
          05 agar-event                usage pointer.

      *> Attachs an event handler (by program name) to a libagar object
      *> named event with a user defined field and address argument.
      *> The field name and address will be passed to the event handler
      *> as part of the event.  Use this to write common handlers
      *> for different fields.
      *> [helpend-agar-setevent-with-field]

       procedure division using
           agar-object
           agar-event-name
           handler-name
           field-name
           field-address
           returning agar-event-record.

      *> Attach an event handlder with a %p format pointer argument
      *> with the field-name (which can be queried in the handler)
       set event-handler to entry handler-name
       if event-handler equal null then
           display "error: " agar-event-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-object
               by reference agar-event-name
               by value event-handler
               by reference function concatenate(
                   "%p(" field-name z")")
               by value field-address
               returning agar-event
       end-if

       goback.
       end function agar-setevent-with-field.
      *> ***************************************************************


       identification division.
       function-id. agar-eventloop.

       data division.
       linkage section.
       01 result-code                  usage binary-long.

       procedure division returning result-code.

      *> Run the event loop (returns only when the gui runs down)
       call "AG_EventLoop" returning result-code

       goback.
       end function agar-eventloop.
      *> ***************************************************************


       identification division.
       function-id. agar-box.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-box]
      *> function agar-box(
       01 agar-parent                  usage pointer.
       01 agar-type                    usage binary-long.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new widget packing box.  Horizontal or vertical.
      *>
      *> See 'man 3 AG_Box' for more details.
      *> [helpend-agar-box]

       procedure division using
           agar-parent
           agar-type
           agar-flags
           returning agar-widget-record.

      *> Simple label
       call "AG_BoxNew" using
           by value agar-parent
           by value agar-type
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-box.
      *> ***************************************************************


       identification division.
       function-id. agar-label.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-label]
      *> function agar-label(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-text                    pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new text label.
      *>
      *> See 'man 3 AG_Label' for more details.
      *> [helpend-agar-label]

       procedure division using
           agar-parent
           agar-flags
           agar-text
           returning agar-widget-record.

      *> Simple label
       call "AG_LabelNewS" using
           by value agar-parent
           by value agar-flags
           by reference concatenate(trim(agar-text) low-value)
           returning agar-widget

       goback.
       end function agar-label.
      *> ***************************************************************


       identification division.
       function-id. agar-button.

       data division.
       working-storage section.
       01 event-handler usage program-pointer.

       linkage section.
      *> [helpstart-agar-button]
      *> function agar-button(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-text                    pic x any length.
       01 eventer-name                 pic x any length.
       01 button-name                  pic x any length.
       01 button-number                usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new labelled button.
      *>
      *> "button-pushed" events are sent to the event handler
      *> (given by eventer-name, a program-id as character data).
      *>
      *> The event handler will include the given button-number
      *> as the second event argument variable (named button-name).
      *>
      *> See 'man 3 AG_Button' for more details.
      *> [helpend-agar-button]

       procedure division using
           agar-parent
           agar-flags
           agar-text
           eventer-name
           button-name
           button-number
           returning agar-widget-record.

      *> Simple button
       call "AG_ButtonNewS" using
           by value agar-parent
           by value agar-flags
           by reference agar-text
           returning agar-widget

      *> Attach a click handler
      *> Event is passed button-name with button-number
       set event-handler to entry eventer-name
       if event-handler equal null then
           display "error: " eventer-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-widget
               by reference  "button-pushed"
               by value event-handler
               by reference function concatenate(
                    "%i(pushed-" button-name z")")
               by value button-number
       end-if

       goback.
       end function agar-button.
      *> ***************************************************************


       identification division.
       function-id. agar-checkbox.

       data division.
       working-storage section.
       01 event-handler usage program-pointer.

       linkage section.
      *> [helpstart-agar-checkbox]
      *> function agar-checkbox(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-label                   pic x any length.
       01 agar-bits                    usage binary-long unsigned.
       01 agar-bitmask                 usage binary-long unsigned.
       01 eventer-name                 pic x any length.
       01 checkbox-name                pic x any length.
       01 checkbox-number              usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new labelled checkbox.
      *>
      *> "checkbox-changed" events are sent to the event handler
      *> (given by program name). These events pass arguments with
      *> checkbox-name and checkbox-number
      *>
      *> See 'man 3 AG_Checkbox' for more details.
      *> [helpend-agar-checkbox]

       procedure division using
           agar-parent
           agar-flags
           agar-label
           agar-bits
           agar-bitmask
           eventer-name
           checkbox-name
           checkbox-number
           returning agar-widget-record.

      *> bitmask checkbox
       call "AG_CheckboxNewFlag" using
           by value agar-parent
           by value agar-flags
           by reference agar-label
           by reference agar-bits
           by reference agar-bitmask
           returning agar-widget

      *> Attach a click handler
      *> Event is passed checkbox-name with checkbox-number
       set event-handler to entry eventer-name
       if event-handler equal null then
           display "error: " eventer-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-widget
               by reference  z"checkbox-changed"
               by value event-handler
               by reference function concatenate(
                    "%i(changed-" checkbox-name z")")
               by value checkbox-number
       end-if

       goback.
       end function agar-checkbox.
      *> ***************************************************************


       identification division.
       function-id. agar-textbox.

       data division.
       working-storage section.
       01 c-len                        usage pointer.   *> size_t
   
       01 inner-textbox based.
          :AGAR-TEXTBOX:

       01 textbox-handler              usage program-pointer.
       01 buffer-pointer               usage pointer.

       linkage section.
      *> [helpstart-textbox]
      *> [helpstart-agar-textbox]
      *> function agar-textbox(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-text                    pic x any length.
       01 agar-buffer                  pic x any length.
       01 eventer-name                 pic x any length.
       01 field-name                   pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Creates a new single line textbox, sized to fit the given
      *> string buffer. Label is a literal displayed before the
      *> entry.  The handler is a program name, as character data.
      *> The id-name is a user defined name passed to the event
      *> handler and accessible by variable-name(2) in the ag-event
      *> structure.  This allows common handlers to decide what to do
      *> given each id-name. Or you have separate handlers for each
      *> textbox.  Buffer is accessible in variable-ptr(2)
      *> inside the event handler.  Event type can also be tested
      *> inside the handler program via event-name, which will be
      *> "textbox-return" or "textbox-postchg".
      *>
      *> See program-id. textboxer. in the source of this library
      *> for an example handler.
      *>
      *> See 'man 3 AG_Textbox" for more details.
      *> [helpend-agar-textbox]
      *> [helpend-textbox]

       procedure division using
           agar-parent
           agar-flags
           agar-text
           agar-buffer
           eventer-name
           field-name
           *> field-address
           returning agar-widget-record.

      *> Textbox
       call "AG_TextboxNewS" using
           by value agar-parent
           by value agar-flags
           by reference agar-text
           returning agar-widget

      *> *** Temporary workaround until complete struct definition ***
       set address of inner-textbox to agar-widget
      *> c-len is actually a size_t, pointers work on the call frame
       set c-len up by function length(agar-buffer)

       call "AG_EditableBindASCII" using
           by value agar-editable
           by reference agar-buffer
           by value c-len
           returning omitted

       call "AG_EditableSizeHint" using
           by value agar-editable
           by reference agar-buffer
           returning omitted

       set buffer-pointer to address of agar-buffer
       *> set field-address to address of agar-buffer

      *> Attach some handlers that have names and a buffer pointer
       set textbox-handler to entry eventer-name
       if textbox-handler equal null then
           display "error: " eventer-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-widget
               by reference  "textbox-return"
               by value textbox-handler
               by reference function concatenate(
                   "%p(return-" field-name z")")
               by value buffer-pointer

           call "AG_SetEvent" using
               by value agar-widget
               by reference  "textbox-prechg"
               by value textbox-handler
               by reference function concatenate(
                   "%p(prechg-" field-name z")")
               by value buffer-pointer

           call "AG_SetEvent" using
               by value agar-widget
               by reference  "textbox-postchg"
               by value textbox-handler
               by reference function concatenate(
                   "%p(poschg-" field-name z")")
               by value buffer-pointer
       end-if

       goback.
       end function agar-textbox.
      *> ***************************************************************


       identification division.
       function-id. agar-combo.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-combo]
      *> function agar-combo(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-label                   pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new combo box. A combo is a high level Agar widget
      *> that packs a Textbox left of a Button which causes a Tlist
      *> to popup when pressed.  The Tlist disappears when an option
      *> is selected.
      *>
      *> Add items to the combo list with function agar-tlist-add.
      *>
      *> See 'man 3 AG_Combo' and 'man 3 AG_Tlist' for more details.
      *> [helpend-agar-combo]

       procedure division using
           agar-parent
           agar-flags
           agar-label
           returning agar-widget-record.

      *> Multi widget combo box, requires entries added to a Tlist
       call "AG_ComboNewS" using
           by value agar-parent
           by value agar-flags
           by reference agar-label
           returning agar-widget

       call "AG_ComboSizeHint" using
           by value agar-widget
           by reference z"XXXXXXXXXXXXXXXXXXXXXX"
           by value 3
           returning omitted

       goback.
       end function agar-combo.
      *> ***************************************************************


       identification division.
       function-id. agar-close-datasource.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-close-datasource]
      *> function agar-close-datasource(
       01 agar-datasource              usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Close a DataSource.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-close-datasource]

       procedure division using agar-datasource
           returning extraneous.

       call "AG_CloseDataSource" using
           by value agar-datasource
           returning extraneous

       goback.
       end function agar-close-datasource.
      *> ***************************************************************


       identification division.
       function-id. agar-console.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-console]
      *> function agar-console(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new console.
      *>
      *> The AG_Console widget displays a scrollable list of messages
      *> in log format. Messages may be copied to the clipboard or
      *> exported to a file.  After a message has been appended to the
      *> log, its text (and other attributes) can be changed. By
      *> default, the display automatically scrolls down to make new
      *> messages visible.
      *>
      *> Add messages with function agar-consolemsg.
      *>
      *> See 'man 3 AG_Console' for more details.
      *> [helpend-agar-console]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> Console messaging
       call "AG_ConsoleNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-console.
      *> ***************************************************************


       identification division.
       function-id. agar-consolemsg.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-consolemsg]
      *> function agar-consolemsg(
       01 agar-parent                  usage pointer.
       01 agar-text                    pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Add a new line to a console.
      *>
      *> See 'man 3 AG_Console' for more details.
      *> [helpend-agar-consolemsg]

       procedure division using
           agar-parent
           agar-text
           returning agar-widget-record.

      *> Console messaging
       call "AG_ConsoleMsg" using
           by value agar-parent
           by reference function concatenate(agar-text low-value)
           returning agar-widget

       goback.
       end function agar-consolemsg.
      *> ***************************************************************


       identification division.
       function-id. agar-dirdlg.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       linkage section.
      *> [helpstart-agar-dirdlg]
      *> function agar-dirdlg(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-dir                     pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new directory dialog. Setting initial directory.
      *>
      *> The AG_DirDlg widget is a directory selection widget. It
      *> provides an interface similar to AG_FileDlg(3), but restricts
      *> the selection to directories.
      *>
      *> See 'man 3 AG_Dirdlg' for more details.
      *> [helpend-agar-dirdlg]

       procedure division using
           agar-parent
           agar-flags
           agar-dir
           returning agar-widget-record.

      *> Multi tab Notebook
       call "AG_DirDlgNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_DirDlgSetDirectoryS" using
           by value agar-widget
           by reference function concatenate(agar-dir low-value)
           returning rc

       goback.
       end function agar-dirdlg.
      *> ***************************************************************


       identification division.
       function-id. agar-editable.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 text-handler                 usage program-pointer.

       >>IF P64 IS SET
       01 size-t constant as 8.
       >>ELSE
       01 size-t constant as 4.
       >>END-IF

       linkage section.
      *> [helpstart-agar-editable]
      *> function agar-editable(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-buffer                  pic x any length.
       01 eventer-name                 pic x any length.
       01 field-name                   pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new editable field, given buffer and event handler.
      *>
      *> See 'man 3 AG_editable' for more details.
      *> [helpend-agar-editable]

       procedure division using
           agar-parent
           agar-flags
           agar-buffer
           eventer-name
           field-name
           returning agar-widget-record.

      *> Editable widget
       call "AG_EditableNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_EditableBindASCII" using
           by value agar-widget
           by reference agar-buffer
           by value size size-t length(agar-buffer)
           returning omitted

       call "AG_EditableSizeHint" using
           by value agar-widget
           by reference agar-buffer
           returning omitted

      *> Attach a handler
       set text-handler to entry eventer-name
       if text-handler equal null then
           display "error: " eventer-name " not found" upon syserr
       else
           call "AG_SetEvent" using
               by value agar-widget
               by reference  "editable-return"
               by value text-handler
               by reference function concatenate(
                   "%p(return-" field-name z")")
               by reference agar-buffer

           call "AG_SetEvent" using
               by value agar-widget
               by reference  "editable-prechg"
               by value text-handler
               by reference function concatenate(
                   "%p(prechg-" field-name z")")
               by reference agar-buffer

           call "AG_SetEvent" using
               by value agar-widget
               by reference  "editable-postchg"
               by value text-handler
               by reference function concatenate(
                   "%p(postchg-" field-name z")")
               by reference agar-buffer

       goback.
       end function agar-editable.
      *> ***************************************************************


       identification division.
       function-id. agar-execute.

       data division.
       working-storage section.

       01 argv.
          05 args occurs 11 times usage pointer.

       linkage section.
      *> [helpstart-agar-execute]
      *> function agar-execute(
       01 agar-command                 pic x any length.
       01 agar-arg1                    pic x any length.
       01 agar-arg2                    pic x any length.
       01 agar-arg3                    pic x any length.
       01 agar-arg4                    pic x any length.
       01 agar-arg5                    pic x any length.
       01 agar-arg6                    pic x any length.
       01 agar-arg7                    pic x any length.
       01 agar-arg8                    pic x any length.
       01 agar-arg9                    pic x any length.
      *> ) returning
       01 process-id                   usage binary-long.

      *> Execute a command passing arguments
      *>
      *> See 'man 3 AG_Execute' for more details.
      *> [helpend-agar-execute]

       procedure division using
           agar-command
           agar-arg1
           agar-arg2
           agar-arg3
           agar-arg4
           agar-arg5
           agar-arg6
           agar-arg7
           agar-arg8
           agar-arg9
           returning process-id.

      *> Execute a command
       set args(1) to address of agar-command
       if agar-arg1 omitted then
           set args(2) to null
       else
           set args(2) to address of agar-arg1
       end-if
       if agar-arg2 omitted then
           set args(3) to null
       else
           set args(3) to address of agar-arg2
       end-if
       if agar-arg3 omitted then
           set args(4) to null
       else
           set args(4) to address of agar-arg3
       end-if
       if agar-arg4 omitted then
           set args(5) to null
       else
           set args(5) to address of agar-arg4
       end-if
       if agar-arg5 omitted then
           set args(6) to null
       else
           set args(6) to address of agar-arg5
       end-if
       if agar-arg6 omitted then
           set args(7) to null
       else
           set args(7) to address of agar-arg6
       end-if
       if agar-arg7 omitted then
           set args(8) to null
       else
           set args(8) to address of agar-arg7
       end-if
       if agar-arg8 omitted then
           set args(9) to null
       else
           set args(9) to address of agar-arg8
       end-if
       if agar-arg9 omitted then
           set args(10) to null
       else
           set args(10) to address of agar-arg9
       end-if
       set args(11) to null

       call "AG_Execute" using
           by reference agar-command
           by reference argv
           returning process-id

       goback.
       end function agar-execute.
      *> ***************************************************************


       identification division.
       function-id. agar-filedlg.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       linkage section.
      *> [helpstart-agar-filedlg]
      *> function agar-filedlg(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-dir                     pic x any length.
       01 agar-file                    pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new file dialog. Setting initial directory and file.
      *>
      *> AG_FileDlg is a traditional file selection widget. The widget
      *> displays a list of directories and shortcuts at the left, a
      *> list of files at the right and an input textbox and file type
      *> selector at the bottom. On platforms with glob(3) support,
      *> glob patterns may be entered in the input textbox.
      *>
      *> Although AG_FileDlg is most often used to implement "Load" or
      *> "Save as..." dialog windows, it may also be embedded into any
      *> arbitrary container widget. User-specified actions (with
      *> optional parameters) can be tied to specific file extensions.
      *>
      *> For selecting directories, the AG_DirDlg(3) widget may be used
      *> instead.
      *>
      *> See 'man 3 AG_Filedlg' for more details.
      *> [helpend-agar-filedlg]

       procedure division using
           agar-parent
           agar-flags
           agar-dir
           agar-file
           returning agar-widget-record.

      *> File dialog
       call "AG_FileDlgNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_FileDlgSetDirectoryS" using
           by value agar-widget
           by reference function concatenate(agar-dir low-value)
           returning rc

       call "AG_FileDlgSetFilenameS" using
           by value agar-widget
           by reference function concatenate(agar-file low-value)
           returning omitted

       goback.
       end function agar-filedlg.
      *> ***************************************************************


       identification division.
       function-id. agar-fixed.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fixed]
      *> function agar-fixed(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Add a fixed sixed and postion container.
      *>
      *> See 'man 3 AG_Fixed' for more details.
      *> [helpend-agar-fixed]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> Fixed positioning
       call "AG_FixedNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-fixed.
      *> ***************************************************************


       identification division.
       function-id. agar-fixed-put.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fixed-put]
      *> function agar-fixed-put(
       01 agar-parent                  usage pointer.
       01 agar-child                   usage binary-long.
       01 agar-xpos                    usage binary-long.
       01 agar-ypos                    usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Put a widget inside Fixed container with top left at x,y
      *>
      *> See 'man 3 AG_Fixed' for more details.
      *> [helpend-agar-fixed-put]

       procedure division using
           agar-parent
           agar-child
           agar-xpos
           agar-ypos
           returning extraneous.

      *> fixed-put positioning
       call "AG_FixedPut" using
           by value agar-parent
           by value agar-child
           by value agar-xpos
           by value agar-ypos
           returning omitted
       move 0 to extraneous

       goback.
       end function agar-fixed-put.
      *> ***************************************************************


       identification division.
       function-id. agar-fixed-del.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fixed-del]
      *> function agar-fixed-del(
       01 agar-parent                  usage pointer.
       01 agar-child                   usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Remove a child widget from a Fixed container.
      *>
      *> See 'man 3 AG_Fixed' for more details.
      *> [helpend-agar-fixed-del]

       procedure division using
           agar-parent
           agar-child
           returning extraneous.

      *> Remove child widget
       call "AG_FixedDel" using
           by value agar-parent
           by value agar-child
           returning omitted
       move 0 to extraneous

       goback.
       end function agar-fixed-del.
      *> ***************************************************************


       identification division.
       function-id. agar-fixed-size.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fixed-size]
      *> function agar-fixed-size(
       01 agar-parent                  usage pointer.
       01 agar-child                   usage binary-long.
       01 agar-width                   usage binary-long.
       01 agar-height                  usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Size a fixed child widget to width and height in pixels.
      *>
      *> See 'man 3 AG_Fixed' for more details.
      *> [helpend-agar-fixed-size]

       procedure division using
           agar-parent
           agar-child
           agar-width
           agar-height
           returning extraneous.

      *> fixed child sizing
       call "AG_FixedSize" using
           by value agar-parent
           by value agar-child
           by value agar-width
           by value agar-height
           returning omitted
       move 0 to extraneous

       goback.
       end function agar-fixed-size.
      *> ***************************************************************


       identification division.
       function-id. agar-fixed-move.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fixed-move]
      *> function agar-fixed-move(
       01 agar-parent                  usage pointer.
       01 agar-child                   usage binary-long.
       01 agar-xpos                    usage binary-long.
       01 agar-ypos                    usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Moved a child to a new Fixed position.
      *>
      *> See 'man 3 AG_Fixed' for more details.
      *> [helpend-agar-fixed-move]

       procedure division using
           agar-parent
           agar-child
           agar-xpos
           agar-ypos
           returning extraneous.

      *> fixed-move positioning
       call "AG_FixedMove" using
           by value agar-parent
           by value agar-child
           by value agar-xpos
           by value agar-ypos
           returning omitted
       move 0 to extraneous

       goback.
       end function agar-fixed-move.
      *> ***************************************************************


       identification division.
       function-id. agar-fixedplotter.

       data division.
       working-storage section.

      *> [helpstart-agar-fixedplotter]
      *> function agar-fixedplotter(
       linkage section.
       01 agar-parent                  usage pointer.
       01 agar-fixed-plotter-type      usage binary-long.
       01 agar-fixed-plotter-flags     usage binary-char unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Add a new fixed plot to the given parent widget.
      *>
      *> See 'man 3 AG_FixedPlotter' for more details.
      *> [helpend-agar-fixedplottercurve]


       procedure division using
           agar-parent
           agar-fixed-plotter-type
           agar-fixed-plotter-flags
           returning agar-widget-record.

      *> Create a fixed plotter
       call "AG_FixedPlotterNew" using
           by value agar-parent
           by value agar-fixed-plotter-type
           by value agar-fixed-plotter-flags
           returning agar-widget

       goback.
       end function agar-fixedplotter.
      *> ***************************************************************


       identification division.
       function-id. agar-fixedplottercurve.

       data division.
       working-storage section.

      *> [helpstart-agar-fixedplottercurve]
      *> function agar-fixedplottercurve(
       linkage section.
       01 agar-parent                  usage pointer.
       01 agar-name                    pic x any length.
       01 agar-red                     usage binary-char unsigned.
       01 agar-green                   usage binary-char unsigned.
       01 agar-blue                    usage binary-char unsigned.
       01 agar-limit                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Add a new RGB coloured curve to a fixed plotter.
      *>
      *> See 'man 3 AG_FixedPlotter' for more details.
      *> [helpend-agar-fixedplottercurve]

       procedure division using
           agar-parent
           agar-name
           agar-red
           agar-green
           agar-blue
           agar-limit
           returning agar-widget-record.

      *> Create a fixed plotter curve
       call "AG_FixedPlotterCurve" using
           by value agar-parent
           by reference agar-name
           by value agar-red
           by value agar-green
           by value agar-blue
           by value agar-limit
           returning agar-widget

       goback.
       end function agar-fixedplottercurve.
      *> ***************************************************************


       identification division.
       function-id. agar-fixedplotterdatum.

       data division.
       working-storage section.

      *> [helpstart-agar-fixedplotterdatum]
      *> function agar-fixedplotterdatum(
       linkage section.
       01 agar-parent                  usage pointer.
       01 agar-val                     usage binary-short.
      *> ) returning
       01 unused                       usage binary-long.

      *> Add a new integer y datapoint to a fixed plot.
      *>
      *> See 'man 3 AG_FixedPlotter' for more details.
      *> [helpend-agar-fixedplotterdatum]

       procedure division using
           agar-parent
           agar-val
           returning unused.

      *> Add a point to a plotter curve
       call "AG_FixedPlotterDatum" using
           by value agar-parent
           by value agar-val
           returning omitted
       move 0 to unused

       goback.
       end function agar-fixedplotterdatum.
      *> ***************************************************************


       identification division.
       function-id. agar-fontselector.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-fontselector]
      *> function agar-fontselector(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new font selector in given parent.
      *>
      *> AG_Fontselector is a traditional font selection widget. The widget
      *> displays a list of fonts, styles and sizes.  Displays a sample
      *> during selection.
      *>
      *> AG_BindPointer can retrieve a pointer to the selected font
      *> structure bound to the selector dialog.
      *>
      *> See 'man 3 AG_Fontselector' for more details.
      *> [helpend-agar-fontselector]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> Font selector
       call "AG_FontSelectorNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-fontselector.
      *> ***************************************************************


       identification division.
       function-id. agar-bindvariable.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-bindvariable]
      *> function agar-bindvariable(
       01 agar-parent                  usage pointer.
       01 agar-name                    pic x any length.
       01 agar-reference               usage pointer.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Bind a reference to a variable
      *>
      *> See 'man 3 AG_Variable' for more details.
      *> [helpend-agar-bindvariable]

       procedure division using
           agar-parent
           agar-name
           agar-reference
           returning agar-widget-record.

      *> Bind a pointer to a named AG_Variable
       call "AG_BindPointer" using
           by value agar-parent
           by reference concatenate(trim(agar-name) low-value)
           by reference agar-reference
           returning agar-widget

       goback.
       end function agar-bindvariable.
      *> ***************************************************************


       identification division.
       function-id. agar-get-error.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-get-error]
      *> function agar-get-error()
      *> returning
       01 agar-error-record.
          05 agar-error                usage pointer.

      *> Get Agar error message
      *>
      *> See 'man 3 AG_Error' for more details.
      *> [helpend-agar-get-error]

       procedure division returning agar-error-record.

      *> Retrieve error message
       call "AG_GetError" returning agar-error

       goback.
       end function agar-get-error.
      *> ***************************************************************


       identification division.
       function-id. agar-get-error-pic.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 agar-error                   usage pointer.

       linkage section.
      *> [helpstart-agar-get-error-pic]
      *> function agar-get-error-pic(
       01 agar-error-buffer            pic x any length.
      *> returning
       01 message-length               usage binary-c-long.

      *> Get Agar error message into given buffer.
      *> Returns length of retrieved error message.
      *>
      *> See 'man 3 AG_Error' for more details.
      *> [helpend-agar-get-error-pic]

       procedure division using
           agar-error-buffer
           returning message-length.

      *> Retrieve error message
       call "AG_GetError" returning agar-error
       if agar-error not equal null then
           move content-of(agar-error) to agar-error-buffer
           move content-length(agar-error) to message-length
       else
           move spaces to agar-error-buffer
           move 0 to message-length
       end-if

       goback.
       end function agar-get-error-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-graph.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graph]
      *> function agar-graph(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new vertex/edge graph.  AG_Graph will attempt a
      *> reasonable layout with minimal crossed edges.
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graph]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> Node based graphs
       call "AG_GraphNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-graph.
      *> ***************************************************************


       identification division.
       function-id. agar-graphvertex.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graphvertex]
      *> function agar-graphvertex(
       01 agar-parent                  usage pointer.
       01 agar-userdata                usage pointer.
       01 vertex-style                 usage binary-long.
       01 vertex-width                 usage binary-long unsigned.
       01 vertex-height                usage binary-long unsigned.
       01 vertex-bg-red                usage binary-char unsigned.
       01 vertex-bg-green              usage binary-char unsigned.
       01 vertex-bg-blue               usage binary-char unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new graph node.
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graphvertex]

       procedure division using
           agar-parent
           agar-userdata
           optional vertex-style
           optional vertex-width
           optional vertex-height
           optional vertex-bg-red
           optional vertex-bg-green
           optional vertex-bg-blue
           returning agar-widget-record.

      *> Graph node
       call "AG_GraphVertexNew" using
           by value agar-parent
           by value agar-userdata
           returning agar-widget

      *> rectangle or circle
       if vertex-style not omitted then
           call "AG_GraphVertexStyle" using
               by value agar-widget
               by value vertex-style
               returning omitted
       end-if

       if (vertex-width not omitted and vertex-width not equal 0) and
          (vertex-height not omitted and vertex-height not equal 0) then
           call "AG_GraphVertexSize" using
               by value agar-widget
               by value vertex-width
               by value vertex-height
               returning omitted
       end-if

       if vertex-bg-red not omitted
          and vertex-bg-green not omitted
          and vertex-bg-blue not omitted then
           call "AG_GraphVertexColorBG" using
               by value agar-widget
               by value size 1 vertex-bg-red
               by value size 1 vertex-bg-green
               by value size 1 vertex-bg-blue
               returning omitted
       end-if

       goback.
       end function agar-graphvertex.
      *> ***************************************************************


       identification division.
       function-id. agar-graphvertex-label.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graphvertex-label]
      *> function agar-graphvertex-label(
       01 agar-widget                  usage pointer.
       01 vertex-label                 pic x any length.
       01 vertex-label-red             usage binary-char unsigned.
       01 vertex-label-green           usage binary-char unsigned.
       01 vertex-label-blue            usage binary-char unsigned.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Label a graph node with option RGB colors.
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graphvertex-label]

       procedure division using
           agar-widget
           vertex-label
           vertex-label-red
           vertex-label-green
           vertex-label-blue
           returning extraneous.

       if vertex-label-red not omitted
          and vertex-label-green not omitted
          and vertex-label-blue not omitted then
           call "AG_GraphVertexColorLabel" using
               by value agar-widget
               by value size 1 vertex-label-red
               by value size 1 vertex-label-green
               by value size 1 vertex-label-blue
               returning omitted
       end-if

      *> this has to come after labelColor setting for it to take
       if vertex-label not equal spaces then
           call "AG_GraphVertexLabelS" using
               by value agar-widget
               by reference function concatenate(vertex-label low-value)
               returning omitted
       end-if

       goback.
       end function agar-graphvertex-label.
      *> ***************************************************************


       identification division.
       function-id. agar-graphvertex-position.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graphvertex-position]
      *> function agar-graphvertex-position(
       01 agar-widget                  usage pointer.
       01 vertex-xpos                  usage binary-long.
       01 vertex-ypos                  usage binary-long.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Position a graph node.
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graphvertex-position]

       procedure division using
           agar-widget
           vertex-xpos
           vertex-ypos
           returning extraneous.

      *> set initial position
       call "AG_GraphVertexPosition" using
           by value agar-widget
           by value vertex-xpos
           by value vertex-ypos
           returning omitted

       goback.
       end function agar-graphvertex-position.
      *> ***************************************************************


       identification division.
       function-id. agar-graphedge.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graphedge]
      *> function agar-graphedge(
       01 agar-parent                  usage pointer.
       01 agar-vertex1                 usage pointer.
       01 agar-vertex2                 usage pointer.
       01 agar-userdata                usage pointer.
       01 edge-red                     usage binary-char unsigned.
       01 edge-green                   usage binary-char unsigned.
       01 edge-blue                    usage binary-char unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a edge connecting vertex v1 to vertex v2.
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graphedge]

       procedure division using
           agar-parent
           agar-vertex1
           agar-vertex2
           agar-userdata
           edge-red
           edge-green
           edge-blue
           returning agar-widget-record.

      *> Connecting edges for graph nodes
       call "AG_GraphEdgeNew" using
           by value agar-parent
           by value agar-vertex1
           by value agar-vertex2
           by value agar-userdata
           returning agar-widget

      *> color of edge
       if edge-red not omitted
          and edge-green not omitted
          and edge-blue not omitted then
           call "AG_GraphEdgeColor" using
               by value agar-widget
               by value size 1 edge-red
               by value size 1 edge-green
               by value size 1 edge-blue
               returning omitted
       end-if

       goback.
       end function agar-graphedge.
      *> ***************************************************************


       identification division.
       function-id. agar-graphedge-label.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-graphedge-label]
      *> function agar-graphedge-label(
       01 agar-widget                  usage pointer.
       01 edge-label                   pic x any length.
       01 edge-label-red               usage binary-char unsigned.
       01 edge-label-green             usage binary-char unsigned.
       01 edge-label-blue              usage binary-char unsigned.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Label a graph edge
      *>
      *> See 'man 3 AG_Graph' for more details.
      *> [helpend-agar-graphedge-label]

       procedure division using
           agar-widget
           edge-label
           edge-label-red
           edge-label-green
           edge-label-blue
           returning extraneous.

      *> color of edge label
       if edge-label-red not omitted
          and edge-label-green not omitted
          and edge-label-blue not omitted then
           call "AG_GraphEdgeColorLabel" using
               by value agar-widget
               by value size 1 edge-label-red
               by value size 1 edge-label-green
               by value size 1 edge-label-blue
               returning omitted
       end-if
       if edge-label not equal spaces then
           call "AG_GraphEdgeLabelS" using
               by value agar-widget
               by reference function concatenate(edge-label low-value)
               returning omitted
       end-if

       goback.
       end function agar-graphedge-label.
      *> ***************************************************************


       identification division.
       function-id. agar-hsvpal.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-hsvpal]
      *> function agar-hsvpal(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new HSV palette editor in given parent.
      *>
      *> The AG_HSVPal widget is a HSV (Hue, Saturation, Value) color
      *> editor which allows the user to edit a color's hue,
      *> saturation, value and alpha components. The widget can bind
      *> directly to different color representations:
      *>
      *> AG_BindPointer can retrieve a pointers to various colour
      *> fields and structures bound to the colour dialog.
      *>
      *> See 'man 3 AG_HSVPal' for more details.
      *> [helpend-agar-hsvpal]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> Hue Saturation Value pallette
       call "AG_HSVPalNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-hsvpal.
      *> ***************************************************************


       identification division.
       function-id. agar-kill-process.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-kill-process]
      *> function agar-kill-process(
       01 agar-pid                     usage binary-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Kill a running process, returning success 0 or errorcode -1
      *>
      *> See 'man 3 AG_Execute' for more details.
      *> [helpend-agar-kill-process]

       procedure division using
           agar-pid
           returning result-code.

      *> Wait for process
       call "AG_Kill" using
           by value agar-pid
           returning result-code

       goback.
       end function agar-kill-process.
      *> ***************************************************************


       identification division.
       function-id. agar-menu.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-menu]
      *> function agar-menu(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new menu bar.
      *>
      *> See 'man 3 AG_menu' for more details.
      *> [helpend-agar-menu]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *> A new menu bar.
       call "AG_MenuNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-menu.
      *> ***************************************************************


       identification division.
       function-id. agar-menunode.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-menunode]
      *> function agar-menunode(
       01 agar-parent                  usage pointer.
       01 agar-text                    pic x any length.
       01 agar-surface                 usage pointer.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new menu node.  Usually used to hold submenus.
      *>
      *> See 'man 3 AG_menu' for more details.
      *> [helpend-agar-menunode]

       procedure division using
           agar-parent
           agar-text
           agar-surface
           returning agar-widget-record.

      *> Node based menus
       call "AG_MenuNode" using
           by value agar-parent
           by reference function concatenate(agar-text low-value)
           by value agar-surface
           returning agar-widget

       goback.
       end function agar-menunode.
      *> ***************************************************************


       identification division.
       function-id. agar-menuaction.

       data division.
       working-storage section.
       01 action-handler               usage program-pointer.

       linkage section.
      *> [helpstart-agar-menuaction]
      *> function agar-menuaction(
       01 agar-parent                  usage pointer.
       01 agar-text                    pic x any length.
       01 agar-surface                 usage pointer.
       01 handler-name                 pic x any length.
       01 user-data                    usage pointer.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new action menu item. Handler is given by program
      *> name.  User data is a pointer to anything needed.
      *>
      *> See 'man 3 AG_Menu' for more details.
      *> [helpend-agar-menuaction]

       procedure division using
           agar-parent
           agar-text
           agar-surface
           handler-name
           user-data
           returning agar-widget-record.

      *> Attach an event handler with a %p format pointer argument
      *> with the user-data (which can be queried in the handler)
       set action-handler to entry handler-name
       if action-handler equal null then
           display "error: " handler-name " not found" upon syserr
       else
           call "AG_MenuAction" using
               by value agar-parent
               by reference function concatenate(agar-text low-value)
               by value agar-surface
               by value action-handler
               by reference "%p(menu)"
               by value user-data
               returning agar-widget
       end-if

      *> Node based menus

       goback.
       end function agar-menuaction.
      *> ***************************************************************


       identification division.
       function-id. agar-mpane.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-mpane]
      *> function agar-mpane(
       01 agar-parent                  usage pointer.
       01 agar-layout                  usage binary-long.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new multipane container.
      *>
      *> See 'man 3 AG_MPane' for more details.
      *> [helpend-agar-mpane]

       procedure division using
           agar-parent
           agar-layout
           agar-flags
           returning agar-widget-record.

      *> Multi Pane, not functioning
       call "AG_MPaneNew" using
           by value agar-parent
           by value agar-layout
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-mpane.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocket.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-agar-netsocket]
      *> function agar-netsocket(
       01 addr-family                  usage binary-long.
       01 socket-type                  usage binary-long.
       01 socket-proto                 usage binary-long.
      *> ) returning
       01 agar-netsocket-record.
          05 agar-netsocket-socket     usage pointer.

      *> Create a new network socket
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netsocket]

       procedure division using
           addr-family
           socket-type
           socket-proto
           returning agar-netsocket-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       call "AG_NetSocketNew" using
           by value addr-family
           by value socket-type
           by value socket-proto
           returning agar-netsocket-socket

       goback.
       end function agar-netsocket.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocketfree.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netsocketfree]
      *> function agar-netsocketfree(
       01 netsocket-socket             usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Free up a network socket.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netsocketfee]

       procedure division using
           netsocket-socket
           returning extraneous.

       call "AG_NetSocketFree" using
           by value netsocket-socket
           returning omitted

       goback.
       end function agar-netsocketfree.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocketset.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netsocketset]
      *> function agar-netsocketset(
      *> ) returning
       01 agar-netsocketset-record.
          05 agar-netsocketset-set     usage pointer.

      *> Create a new netsocketset which is initialized empty.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netsocketset]

       procedure division
           returning agar-netsocketset-record.

      *> netsocketset, allocated and initialized empty
       call "AG_NetSocketSetNew"
           returning agar-netsocketset-set

       goback.
       end function agar-netsocketset.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocketset-add.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netsocketset-add]
      *> function agar-netsocketset-add(
       01 agar-netsocketset            usage pointer.
       01 agar-netpoll-flags           usage binary-long unsigned.
       01 agar-netsocket               usage pointer.
      *> ) returning
       01 agar-netsocketset-record.
          05 agar-netsocketset-set     usage pointer.

      *> Add a netsocket to a netsocketset with given polling flags
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netsocketset-add]

       procedure division using
           agar-netsocketset
           agar-netpoll-flags
           agar-netsocket
           returning agar-netsocketset-record.

      *> netsocketset, allocated and initialized empty
       call "AG_NetSocketSetAdd" using
           by value agar-netsocketset
           by value agar-netpoll-flags
           by value agar-netsocket
           returning agar-netsocketset-set

       goback.
       end function agar-netsocketset-add.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocketset-first.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netsocketset-first]
      *> function agar-netsocketset-first(
       01 agar-netsocketset            usage pointer.
      *> ) returning
       01 agar-netsocket-record.
          05 agar-netsocket-socket     usage pointer.

      *> Return first entry in a NetSocketSet
      *>
      *> See 'man 3 AG_Socket' for more details.
      *> [helpend-agar-netsocketset-first]

       procedure division using
           agar-netsocketset
           returning agar-netsocket-record.

      *> netsocketset, allocated and initialized empty
       call "AG_NetSocketSetFirst" using
           by value agar-netsocketset
           returning agar-netsocket-socket

       goback.
       end function agar-netsocketset-first.
      *> ***************************************************************


       identification division.
       function-id. agar-netsocketset-next.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netsocketset-next]
      *> function agar-netsocketset-next(
       01 agar-netsocketset            usage pointer.
      *> ) returning
       01 agar-netsocket-record.
          05 agar-netsocket-socket     usage pointer.

      *> Return first entry in a NetSocketSet
      *>
      *> See 'man 3 AG_Socket' for more details.
      *> [helpend-agar-netsocketset-next]

       procedure division using
           agar-netsocketset
           returning agar-netsocket-record.

      *> netsocketset, allocated and initialized empty
       call "AG_NetSocketSetNext" using
           by value agar-netsocketset
           returning agar-netsocket-socket

       goback.
       end function agar-netsocketset-next.
      *> ***************************************************************


       identification division.
       function-id. agar-netpoll.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netpoll]
      *> function agar-netpoll(
       01 agar-netsocketset            usage pointer.
       01 agar-netpoll-readers         usage pointer.
       01 agar-netpoll-writers         usage pointer.
       01 agar-netpoll-exceptions      usage pointer.
       01 agar-netpoll-timeout         usage binary-long unsigned.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Network poll from given socketset setting readers/writers/excp.
      *>
      *> See 'man 3 AG_Socket' for more details.
      *> [helpend-agar-netpoll]

       procedure division using
           agar-netsocketset
           agar-netpoll-readers
           agar-netpoll-writers
           agar-netpoll-exceptions
           agar-netpoll-timeout
           returning net-rc.

      *> netsocketset, allocated and initialized empty
       call "AG_NetPoll" using
           by value agar-netsocketset
           by value agar-netpoll-readers
           by value agar-netpoll-writers
           by value agar-netpoll-exceptions
           by value agar-netpoll-timeout
           returning net-rc

       goback.
       end function agar-netpoll.
      *> ***************************************************************


       identification division.
       function-id. agar-netresolve.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netresolve]
      *> function agar-netresolve(
       01 hostname                     pic x any length.
       01 port                         pic x any length.
       01 flags                        usage binary-long.
      *> ) returning
       01 agar-netaddr-record.
          05 agar-netaddr-list         usage pointer.

      *> Resolve a network address, given host and port
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netresolve]

       procedure division using
           hostname
           port
           flags
           returning agar-netaddr-record.

       call "AG_NetResolve" using
           by reference concatenate(trim(hostname) low-value)
           by reference concatenate(trim(port) low-value)
           by value flags
           returning agar-netaddr-list

       goback.
       end function agar-netresolve.
      *> ***************************************************************


       identification division.
       function-id. agar-netconnect.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netconnect]
      *> function agar-netconnect(
       01 netsocket-socket             usage pointer.
       01 netaddr-list                 usage pointer.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Connect local socket to remote, given the netaddr list
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netconnect]

       procedure division using
           netsocket-socket
           netaddr-list
           returning net-rc.

       call "AG_NetConnect" using
           by value netsocket-socket
           by value netaddr-list
           returning net-rc

       goback.
       end function agar-netconnect.
      *> ***************************************************************


       identification division.
       function-id. agar-netbind.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netbind]
      *> function agar-netbind(
       01 netsocket-socket             usage pointer.
       01 netaddr-list                 usage pointer.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Bind a local socket to remote, given the netaddr list
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netbind]

       procedure division using
           netsocket-socket
           netaddr-list
           returning net-rc.

       call "AG_NetBind" using
           by value netsocket-socket
           by value netaddr-list
           returning net-rc

       goback.
       end function agar-netbind.
      *> ***************************************************************


       identification division.
       function-id. agar-netaccept.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netaccept]
      *> function agar-netaccept(
       01 netsocket-socket             usage pointer.
      *> ) returning
       01 netsocket-connection-record.
          05 netsocket-connection      usage pointer.

      *> Accept from a bound socket returning first connection socket.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netaccept]

       procedure division using
           netsocket-socket
           returning netsocket-connection-record.

       call "AG_NetAccept" using
           by value netsocket-socket
           returning netsocket-connection

       goback.
       end function agar-netaccept.
      *> ***************************************************************


       identification division.
       function-id. agar-netclose.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netclose]
      *> function agar-netclose(
       01 netsocket-socket             usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Close a socket.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netclose]

       procedure division using
           netsocket-socket
           returning extraneous.

       call "AG_NetClose" using
           by value netsocket-socket
           returning omitted

       goback.
       end function agar-netclose.
      *> ***************************************************************


       identification division.
       function-id. agar-netread.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netread]
      *> function agar-netread(
       01 netsocket-socket             usage pointer.
       01 data-buffer                  usage pointer.
       01 data-size                    usage binary-c-long.
       01 read-actual                  usage binary-c-long.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Read from socket into buffer, setting read-actual.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netread]

       procedure division using
           netsocket-socket
           data-buffer
           data-size
           read-actual
           returning net-rc.

       call "AG_NetRead" using
           by value netsocket-socket
           by value data-buffer
           by value data-size
           by reference read-actual
           returning net-rc

       goback.
       end function agar-netread.
      *> ***************************************************************


       identification division.
       function-id. agar-netread-pic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netread-pic]
      *> function agar-netread-pic(
       01 netsocket-socket             usage pointer.
       01 data-buffer                  pic x any length.
       01 data-size                    usage binary-c-long.
       01 read-actual                  usage binary-c-long.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Read from socket into buffer, setting read-actual.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netread-pic]

       procedure division using
           netsocket-socket
           data-buffer
           data-size
           read-actual
           returning net-rc.

       call "AG_NetRead" using
           by value netsocket-socket
           by reference data-buffer
           by value data-size
           by reference read-actual
           returning net-rc

       goback.
       end function agar-netread-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-netwrite.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netwrite]
      *> function agar-netwrite(
       01 netsocket-socket             usage pointer.
       01 data-buffer                  usage pointer.
       01 data-size                    usage binary-c-long.
       01 write-actual                 usage binary-c-long.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Write data from pointer and size to socket, setting actual.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netwrite]

       procedure division using
           netsocket-socket
           data-buffer
           data-size
           write-actual
           returning net-rc.

       call "AG_NetWrite" using
           by value netsocket-socket
           by value data-buffer
           by value data-size
           by reference write-actual
           returning net-rc

       goback.
       end function agar-netwrite.
      *> ***************************************************************


       identification division.
       function-id. agar-netwrite-pic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-netwrite-pic]
      *> function agar-netwrite-pic(
       01 netsocket-socket             usage pointer.
       01 data-buffer                  pic x any length.
       01 data-size                    usage binary-c-long.
       01 write-actual                 usage binary-c-long.
      *> ) returning
       01 net-rc                       usage binary-long.

      *> Write buffer to socket, setting write actual.
      *>
      *> See 'man 3 AG_Net' for more details.
      *> [helpend-agar-netwrite-pic]

       procedure division using
           netsocket-socket
           data-buffer
           data-size
           write-actual
           returning net-rc.

       call "AG_NetWrite" using
           by value netsocket-socket
           by reference data-buffer
           by value data-size
           by reference write-actual
           returning net-rc

       goback.
       end function agar-netwrite-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-notebook.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-notebook]
      *> function agar-notebook(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new multitab notebook container.
      *>
      *> See 'man 3 AG_Notebook' for more details.
      *> [helpend-agar-notebook]

       procedure division using
           agar-parent
           agar-flags
           returning agar-widget-record.

      *>
       call "AG_NotebookNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-notebook.
      *> ***************************************************************


       identification division.
       function-id. agar-notebook-add.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-notebook-add]
      *> function agar-notebook-add(
       01 agar-parent                  usage pointer.
       01 agar-name                    pic x any length.
       01 agar-type                    usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Add a tab to a notebook.
      *>
      *> See 'man 3 AG_Notebook' for more details.
      *> [helpend-agar-notebook-add]

       procedure division using
           agar-parent
           agar-name
           agar-type
           returning agar-widget-record.

      *> Add a tab to a Notebook
       call "AG_NotebookAdd" using
           by value agar-parent
           by reference concatenate(trim(agar-name) low-value)
           by value agar-type
           returning agar-widget

       goback.
       end function agar-notebook-add.
      *> ***************************************************************


       identification division.
       function-id. agar-numerical.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-numerical]
      *> function agar-numerical(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-units                   pic x any length.
       01 agar-label                   pic x any length.
       01 agar-value                   usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new numerical spin item.
      *>
      *> Default is a floating double builtin value, unless INT flag
      *> passed. Can be scaled by physical unit conversions.
      *>
      *> See 'man 3 AG_Numerical' and 'man 3 AG_Units' for more details.
      *> [helpend-agar-numerical]

       procedure division using
           agar-parent
           agar-flags
           agar-units
           agar-label
           optional agar-value
           returning agar-widget-record.

      *> Numerical spinner
       if agar-units equals spaces then
           *> BWT HERE experiment with subtypes
           call "AG_NumericalNewInt" using
               by value agar-parent
               by value agar-flags
               by reference null
               by reference concatenate(trim(agar-label) low-value)
               by reference agar-value
               returning agar-widget
       else
           call "AG_NumericalNewS" using
               by value agar-parent
               by value agar-flags
               by reference concatenate(trim(agar-units) low-value)
               by reference concatenate(trim(agar-label) low-value)
               returning agar-widget
       end-if

       goback.
       end function agar-numerical.
      *> ***************************************************************


       identification division.
       function-id. agar-open-core.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-agar-open-core]
      *> function agar-open-core(
       01 agar-core                    usage pointer.
       01 agar-size                    usage binary-c-long.
       01 agar-const                   usage binary-long.
      *> ) returning
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.

      *> Open a memory DataSource given pointer and size.
      *>
      *> If the address is null, an Auto sized Core is opened in which
      *> case the size is irrelevant and const flag is ignored.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-open-core]

       procedure division using
           agar-core
           agar-size
           agar-const
           returning agar-datasource-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       if agar-core equal null or agar-size equal 0 then
           call "AG_OpenAutoCore"
           returning agar-datasource
       else
           if agar-const is zero then
               call "AG_OpenCore" using
                   by value agar-core
                   by value agar-size
                   returning agar-datasource
           else
               call "AG_OpenConstCore" using
                   by value agar-core
                   by value agar-size
                   returning agar-datasource
           end-if
       end-if

       goback.
       end function agar-open-core.
      *> ***************************************************************


       identification division.
       function-id. agar-open-core-pic.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-agar-open-core-pic]
      *> function agar-open-core-pic(
       01 agar-core                    pic x any length.
       01 agar-size                    usage binary-c-long.
       01 agar-const                   usage binary-long.
      *> ) returning
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.

      *> Open a memory DataSource given address and size.
      *>
      *> If the address is null, an Auto sized Core is opened in which
      *> case the size is irrelevant and const flag is ignored.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-open-core]

       procedure division using
           agar-core
           agar-size
           agar-const
           returning agar-datasource-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       if (length(agar-core) equal 0) or (agar-size equal 0) then
           call "AG_OpenAutoCore"
           returning agar-datasource
       else
           if agar-const is zero then
               call "AG_OpenCore" using
                   by reference agar-core
                   by value agar-size
                   returning agar-datasource
           else
               call "AG_OpenConstCore" using
                   by reference agar-core
                   by value agar-size
                   returning agar-datasource
           end-if
       end-if

       goback.
       end function agar-open-core-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-open-file.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-agar-open-file]
      *> function agar-open-file(
       01 agar-path                    pic x any length.
       01 agar-mode                    pic x any length.
      *> ) returning
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.

      *> Open a DataSource given file path and mode.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-open-file]

       procedure division using
           agar-path
           agar-mode
           returning agar-datasource-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       call "AG_OpenFile" using
           by reference concatenate(trim(agar-path) low-value)
           by reference concatenate(trim(agar-mode) low-value)
           returning agar-datasource

       goback.
       end function agar-open-file.
      *> ***************************************************************


       identification division.
       function-id. agar-open-filehandle.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 rc                           usage binary-long.

       :AGAR-RUN-STATUS:

       linkage section.
      *> [helpstart-agar-open-filehandle]
      *> function agar-open-filehandle(
       01 agar-filehandle              usage pointer.
      *> ) returning
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.

      *> Open a DataSource given file path and mode.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-open-filehandle]

       procedure division using
           agar-filehandle
           returning agar-datasource-record.

       if not agar-core-ready then
           call "AG_InitCore" using null by value 1 returning rc
               on exception
                   display "error: no libagar" upon syserr
                   goback
           end-call
           if rc not equal zero then
               display "error: AG_InitCore failure" upon syserr
               goback
           end-if
           set agar-core-ready to true
       end-if

       call "AG_OpenFileHandle" using
           by value agar-filehandle
           returning agar-datasource

       goback.
       end function agar-open-filehandle.
      *> ***************************************************************


       identification division.
       function-id. agar-open-netsocket.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-open-netsocket]
      *> function agar-open-netsocket(
       01 agar-netsocket               usage pointer.
      *> ) returning
       01 agar-datasource-record.
          05 agar-datasource           usage pointer.

      *> Open a DataSource given an agar-netsocket
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-open-netsocket]

       procedure division using
           agar-netsocket
           returning agar-datasource-record.

       call "AG_OpenNetSocket" using
           by value agar-netsocket
           returning agar-datasource

       goback.
       end function agar-open-netsocket.
      *> ***************************************************************


       identification division.
       function-id. agar-pane.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-pane]
      *> function agar-pane(
       01 agar-parent                  usage pointer.
       01 agar-layout                  usage binary-long.
       01 agar-flags                   usage binary-long unsigned.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new split pane container.
      *>
      *> See 'man 3 AG_Pane' for more details.
      *> [helpend-agar-pane]

       procedure division using
           agar-parent
           agar-layout
           agar-flags
           returning agar-widget-record.

      *> Split pane, given orientation
       call "AG_PaneNew" using
           by value agar-parent
           by value agar-layout
           by value agar-flags
           returning agar-widget

       goback.
       end function agar-pane.
      *> ***************************************************************


       identification division.
       function-id. agar-pixmap.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-pixmap]
      *> function agar-pixmap(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-width                   usage binary-long.
       01 agar-height                  usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new empty image by size.
      *>
      *> See 'man 3 AG_Pixmap' for more details.
      *> [helpend-agar-pixmap]

       procedure division using
           agar-parent
           agar-flags
           agar-width
           agar-height
           returning agar-widget-record.

      *> Pixmap
       call "AG_PixmapNew" using
           by value agar-parent
           by value agar-flags
           by value agar-width
           by value agar-height

       goback.
       end function agar-pixmap.
      *> ***************************************************************


       identification division.
       function-id. agar-pixmap-file.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-pixmap-file]
      *> function agar-pixmap-file(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 pixmap-file-filename              pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new image from filename.
      *>
      *> See 'man 3 AG_Pixmap' for more details.
      *> [helpend-agar-pixmap-file]

       procedure division using
           agar-parent
           agar-flags
           pixmap-file-filename
           returning agar-widget-record.

      *> Images as pixmap-file, various input formats supported
       call "AG_PixmapFromFile" using
           by value agar-parent
           by value agar-flags
           by reference function concatenate(pixmap-file-filename x"00")
           returning agar-widget

       goback.
       end function agar-pixmap-file.
      *> ***************************************************************


       identification division.
       function-id. agar-pixmap-surface.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-pixmap-surface]
      *> function agar-pixmap-surface(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-surface                 usage pointer.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new image, empty by size or from filename if the
      *> given width and height add up to zero.
      *>
      *> See 'man 3 AG_Pixmap' for more details.
      *> [helpend-agar-pixmap-surface]

       procedure division using
           agar-parent
           agar-flags
           agar-surface
           returning agar-widget-record.

      *> Images as pixmap-surface, various input formats supported
       call "AG_PixmapFromSurface" using
           by value agar-parent
           by value agar-flags
           by value agar-surface
           returning agar-widget

       goback.
       end function agar-pixmap-surface.
      *> ***************************************************************


       identification division.
       function-id. agar-pixmap-surface-scaled.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-pixmap-surface-scaled]
      *> function agar-pixmap-surface-scaled(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-surface                 usage pointer.
       01 agar-width                   usage binary-long.
       01 agar-height                  usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new image from given surface scaled to width height
      *>
      *> See 'man 3 AG_Pixmap' for more details.
      *> [helpend-agar-pixmap-surface-scaled]

       procedure division using
           agar-parent
           agar-flags
           agar-surface
           agar-width
           agar-height
           returning agar-widget-record.

      *> Images as pixmap-surface-scaled, various input formats supported
       call "AG_PixmapFromSurfaceScaled" using
           by value agar-parent
           by value agar-flags
           by value agar-surface
           by value agar-width
           by value agar-height
           returning agar-widget

       goback.
       end function agar-pixmap-surface-scaled.
      *> ***************************************************************


       identification division.
       function-id. agar-progressbar.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-progressbar]
      *> function agar-progressbar(
       01 agar-parent                  usage pointer.
       01 agar-layout                  usage binary-long.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-value                   usage binary-long.
       01 agar-min                     usage binary-long.
       01 agar-max                     usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new progressbar, given value, min and max.
      *>
      *> See 'man 3 AG_ProgressBar' for more details.
      *> [helpend-agar-progressbar]

       procedure division using
           agar-parent
           agar-layout
           agar-flags
           agar-value
           agar-min
           agar-max
           returning agar-widget-record.

      *> ProgressBar, given value, min and max as references to int
       call "AG_ProgressBarNewInt" using
           by value agar-parent
           by value agar-layout
           by value agar-flags
           by reference agar-value
           by reference agar-min
           by reference agar-max
           returning agar-widget

       goback.
       end function agar-progressbar.
      *> ***************************************************************


       identification division.
       function-id. agar-radio.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-radio]
      *> function agar-radio(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long unsigned.
       01 agar-items                   usage pointer.
       01 agar-value                   usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new radio group, given array of C strings, null at end
      *>
      *> See 'man 3 AG_Radio' for more details.
      *> [helpend-agar-radio]

       procedure division using
           agar-parent
           agar-flags
           agar-items
           agar-value
           returning agar-widget-record.

      *> radio, given array of C string (null end) and integer value.
       call "AG_RadioNewInt" using
           by value agar-parent
           by value agar-flags
           by reference agar-items
           by reference agar-value
           returning agar-widget

       goback.
       end function agar-radio.
      *> ***************************************************************


       identification division.
       function-id. agar-scrollview.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-scrollview]
      *> function agar-scrollview(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-width                   usage binary-long unsigned.
       01 agar-height                  usage binary-long unsigned.
       01 agar-inc                     usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new scrollview given width and height size hints.
      *>
      *> See 'man 3 AG_Scrollview' for more details.
      *> [helpend-agar-scrollview]

       procedure division using
           agar-parent
           agar-flags
           agar-width
           agar-height
           agar-inc
           returning agar-widget-record.

      *> scrollview
       call "AG_ScrollviewNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_ScrollviewSizeHint" using
           by value agar-widget
           by value agar-width
           by value agar-height
           returning omitted

       call "AG_ScrollviewSetIncrement" using
           by value agar-widget
           by value agar-inc
           returning omitted

       goback.
       end function agar-scrollview.
      *> ***************************************************************


       identification division.
       function-id. agar-separator.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-separator]
      *> function agar-separator(
       01 agar-parent                  usage pointer.
       01 agar-type                    usage binary-long.
       01 agar-visible                 usage binary-long.
       01 agar-padding                 usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new separator Horiz or Vert by type,
      *>  visible on non-zero.
      *>
      *> See 'man 3 AG_Separator' for more details.
      *> [helpend-agar-separator]

       procedure division using
           agar-parent
           agar-type
           agar-visible
           agar-padding
           returning agar-widget-record.

      *> separator, or spacer
       if agar-visible equal zero then
           call "AG_SpacerNew" using
               by value agar-parent
               by value agar-type
               returning agar-widget
       else
           call "AG_SeparatorNew" using
               by value agar-parent
               by value agar-type
               returning agar-widget
       end-if

       call "AG_SeparatorSetPadding" using
           by value agar-widget
           by value agar-padding
           returning omitted

       goback.
       end function agar-separator.
      *> ***************************************************************


       identification division.
       function-id. agar-set-style.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-set-style]
      *> function agar-set-style(
       01 agar-widget                  usage pointer.
       01 agar-which                   pic x any length.
       01 agar-value                   pic x any length.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Set a style element for the given widget.
      *>
      *> See 'man 3 AG_Widget' for more details.
      *> [helpend-agar-set-style]

       procedure division using
           agar-widget
           agar-which
           agar-value
           returning extraneous.

      *> set-style
       call "AG_SetStyle" using
           by value agar-widget
           by reference concatenate(trim(agar-which) low-value)
           by reference concatenate(trim(agar-value) low-value)
           returning omitted

       move 0 to extraneous
       goback.
       end function agar-set-style.
      *> ***************************************************************


       identification division.
       function-id. agar-slider.

       data division.
       working-storage section.
       01 agar-variable occurs 4 times usage pointer. *> fire and forget

       linkage section.
      *> [helpstart-agar-slider]
      *> function agar-slider(
       01 agar-parent                  usage pointer.
       01 agar-type                    usage binary-long.
       01 agar-flags                   usage binary-long.
       01 agar-value                   usage binary-long signed.
       01 agar-min                     usage binary-long signed.
       01 agar-max                     usage binary-long signed.
       01 agar-inc                     usage binary-long signed.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new slider Horiz or Vert by type,
      *>  Given a signed 32 bit integer.
      *>
      *> See 'man 3 AG_Slider' for more details.
      *> [helpend-agar-slider]

       procedure division using
           agar-parent
           agar-type
           agar-flags
           agar-value
           agar-min
           agar-max
           agar-inc
           returning agar-widget-record.

      *> slider for signed 32 bit integer value
       call "AG_SliderNew" using
           by value agar-parent
           by value agar-type
           by value agar-flags
           returning agar-widget

       call "AG_SliderSetControlSize" using
           by value agar-widget
           by value 12
           returning omitted

       call "AG_BindInt" using
           by value agar-widget
           by reference z"value"
           by reference agar-value
           returning agar-variable(1)
       call "AG_BindInt" using
           by value agar-widget
           by reference z"min"
           by reference agar-min
           returning agar-variable(2)
       call "AG_BindInt" using
           by value agar-widget
           by reference z"max"
           by reference agar-max
           returning agar-variable(3)
       call "AG_SetInt" using
           by value agar-widget
           by reference z"inc"
           by value agar-inc
           returning agar-variable(4)

       goback.
       end function agar-slider.
      *> ***************************************************************


       identification division.
       function-id. agar-socket.

       data division.
       working-storage section.
       01 insert-function              usage program-pointer.
       01 remove-function              usage program-pointer.

       linkage section.
      *> [helpstart-agar-socket]
      *> function agar-socket(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-insert                  pic x any length.
       01 agar-remove                  pic x any length.
       01 agar-icon                    usage pointer.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new socket.
      *>
      *> Icon drag and drop sockets currently only work with single
      *> window Agar drivers such as sdlfb.
      *>
      *> See 'man 3 AG_Socket' for more details.
      *> [helpend-agar-socket]

       procedure division using
           agar-parent
           agar-flags
           agar-insert
           agar-remove
           agar-icon
           returning agar-widget-record.

      *> socket for signed 32 bit integer value
       call "AG_SocketNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_SocketInsertIcon" using
           by value agar-widget
           by value agar-icon
           returning omitted

       set insert-function to entry agar-insert
       set remove-function to entry agar-remove

       goback.
       end function agar-socket.
      *> ***************************************************************


       identification division.
       function-id. agar-static-icon.

       data division.
       working-storage section.
       01 symbol-pointer               usage program-pointer.

      *> AG_StaticIcon
       01 static-icon based.
          05 filler                    pic x(24).
          05 icon-data                 usage pointer sync.
          05 icon-surface              usage pointer sync.

       linkage section.
      *> [helpstart-agar-static-icon]
      *> function agar-static-icon(
       01 agar-icon-name               pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Expose a builtin static icon.
      *>
      *> See 'man 3 AG_Surface' for more details.
      *> [helpend-agar-static-icon]

       procedure division using
           agar-icon-name
           returning agar-widget-record.

      *> look up a C external symbol name
       set symbol-pointer to entry agar-icon-name
       if symbol-pointer not equal null then
           set address of static-icon to symbol-pointer
           *> initialize the data and surface
           call "AG_InitStaticIcon" using
               by reference static-icon
               returning omitted
       end-if
       set agar-widget to icon-surface

       goback.
       end function agar-static-icon.
      *> ***************************************************************


       identification division.
       function-id. agar-table.

       data division.
       working-storage section.
       01 agar-variable occurs 4 times usage pointer. *> fire and forget

       linkage section.
      *> [helpstart-agar-table]
      *> function agar-table(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-width                   usage binary-long.
       01 agar-rows                    usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new table
      *>
      *> See 'man 3 AG_Table' for more details.
      *> [helpend-agar-table]

       procedure division using
           agar-parent
           agar-flags
           agar-width
           agar-rows
           returning agar-widget-record.

      *> table
       call "AG_TableNew" using
           by value agar-parent
           by value agar-flags
           returning agar-widget

       call "AG_TableSizeHint" using
           by value agar-widget
           by value agar-width
           by value agar-rows
           returning omitted

       goback.
       end function agar-table.
      *> ***************************************************************


       identification division.
       function-id. agar-timer.

       data division.
       working-storage section.
       01 timer-handler                usage program-pointer.
       01 ag-timer.
       :AGAR-TIMER:

       linkage section.
      *> [helpstart-agar-timer]
      *> function agar-timer(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 timer-ticks                  usage binary-long.
       01 timer-name                   pic x any length.
       01 event-name                   pic x any length.
      *> ) returning
       01 rc                           usage binary-long.

      *> Create a new timer given name and event.
      *>
      *> Resolution is in milliseconds.
      *>
      *> See 'man 3 AG_Timer' for more details.
      *> [helpend-agar-timer]

       procedure division using
           agar-parent
           agar-flags
           timer-ticks
           timer-name
           event-name
           returning rc.

      *> timer
       *>set timer to address of ag-timer
       call "AG_InitTimer" using
           by reference ag-timer
           by reference timer-name
           by value agar-flags
           returning omitted

       set timer-handler to entry event-name
       if timer-handler equal null then
           display "error: no handler " event-name upon syserr
           move -1 to rc
       else
           call "AG_AddTimer" using
               by value agar-parent
               by reference ag-timer
               by value timer-ticks
               by value timer-handler
               by reference null
               returning rc
       end-if

       goback.
       end function agar-timer.
      *> ***************************************************************


       identification division.
       function-id. agar-tlist-add.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-tlist-add]
      *> function agar-tlist-add(
       01 agar-parent                  usage pointer.
       01 agar-surface                 usage pointer.
       01 agar-text                    pic x any length.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.
      *>
      *> Add a text item to a Tlist with the given surface.
      *>
      *> See 'man 3 AG_Tlist' for more details.
      *> [helpend-agar-tlist-add]

       procedure division using
           agar-parent
           agar-surface
           agar-text
           returning agar-widget-record.

       call "AG_TlistAddS" using
           by value agar-parent
           by value agar-surface
           by reference agar-text
           returning agar-widget

       goback.
       end function agar-tlist-add.
      *> ***************************************************************


       identification division.
       function-id. agar-treetbl.

       data division.
       working-storage section.
       01 agar-variable occurs 4 times usage pointer. *> fire and forget

       linkage section.
      *> [helpstart-agar-treetbl]
      *> function agar-treetbl(
       01 agar-parent                  usage pointer.
       01 agar-flags                   usage binary-long.
       01 agar-data-function           usage program-pointer.
       01 agar-sort-function           usage program-pointer.
       01 agar-width                   usage binary-long.
       01 agar-rows                    usage binary-long.
      *> ) returning
       01 agar-widget-record.
          05 agar-widget               usage pointer.

      *> Create a new treetbl
      *>
      *> See 'man 3 AG_treetbl' for more details.
      *> [helpend-agar-treetbl]

       procedure division using
           agar-parent
           agar-flags
           agar-data-function
           agar-sort-function
           agar-width
           agar-rows
           returning agar-widget-record.

      *> treetbl
       call "AG_TreetblNew" using
           by value agar-parent
           by value agar-flags
           by value agar-data-function
           by value agar-sort-function
           returning agar-widget

       call "AG_TreetblSizeHint" using
           by value agar-widget
           by value agar-width
           by value agar-rows
           returning omitted

       goback.
       end function agar-treetbl.
      *> ***************************************************************


       identification division.
       function-id. agar-read.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-read]
      *> function agar-read(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  usage pointer.
       01 agar-read-request            usage binary-c-long.
       01 agar-read-actual             usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Read from a datasource to destination pointer given length.
      *>
      *> Actual bytes read set in agar-read-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-read]

       procedure division using
           agar-datasource
           agar-buffer
           agar-read-request
           agar-read-actual
           returning result-code.

       call "AG_ReadP" using
           by value agar-datasource
           by value agar-buffer
           by value agar-read-request
           by reference agar-read-actual
           returning result-code

       goback.
       end function agar-read.
      *> ***************************************************************


       identification division.
       function-id. agar-read-pic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-read-pic]
      *> function agar-read-pic(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  pic x any length.
       01 agar-read-request            usage binary-c-long.
       01 agar-read-actual             usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Read from a datasource into buffer for a given length.
      *>
      *> Actual bytes read set in agar-read-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-read-pic]

       procedure division using
           agar-datasource
           agar-buffer
           agar-read-request
           agar-read-actual
           returning result-code.

       call "AG_ReadP" using
           by value agar-datasource
           by reference agar-buffer
           by value agar-read-request
           by reference agar-read-actual
           returning result-code

       goback.
       end function agar-read-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-read-at.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-read-at]
      *> function agar-read-at(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  usage pointer.
       01 agar-read-request            usage binary-c-long.
       01 agar-read-position           usage binary-c-long.
       01 agar-read-actual             usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Read from a datasource given length and position (from start).
      *>
      *> Actual bytes read set in agar-read-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-read-at]

       procedure division using
           agar-datasource
           agar-buffer
           agar-read-request
           agar-read-position
           agar-read-actual
           returning result-code.

       call "AG_ReadAtP" using
           by value agar-datasource
           by value agar-buffer
           by value agar-read-request
           by value agar-read-position
           by reference agar-read-actual
           returning result-code

       goback.
       end function agar-read-at.
      *> ***************************************************************


       identification division.
       function-id. agar-read-at-pic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-read-at-pic]
      *> function agar-read-at-pic(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  pic x any length.
       01 agar-read-request            usage binary-c-long.
       01 agar-read-position           usage binary-c-long.
       01 agar-read-actual             usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Read from a datasource given length and position (from start).
      *>
      *> Actual bytes read set in agar-read-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-read-at-pic]

       procedure division using
           agar-datasource
           agar-buffer
           agar-read-request
           agar-read-position
           agar-read-actual
           returning result-code.

       call "AG_ReadAtP" using
           by value agar-datasource
           by reference agar-buffer
           by value agar-read-request
           by value agar-read-position
           by reference agar-read-actual
           returning result-code

       goback.
       end function agar-read-at-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-wait-on-process.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-wait-on-process]
      *> function agar-wait-on-process(
       01 agar-pid                     usage binary-long.
       01 agar-wait-type               usage binary-long.
      *> ) returning
       01 process-id                   usage binary-long.

      *> Check on status or Wait for a running process.
      *>
      *> The function returns the PID of the terminated process,
      *>   -1 if an error occured, or 0 if wait_type is
      *>   AG_EXEC_WAIT_IMMEDIATE and the process is still running.
      *>
      *> See 'man 3 AG_Execute' for more details.
      *> [helpend-agar-wait-on-process]

       procedure division using
           agar-pid
           agar-wait-type
           returning process-id.

      *> Wait for process
       call "AG_WaitOnProcess" using
           by value agar-pid
           by value agar-wait-type
           returning process-id

       goback.
       end function agar-wait-on-process.
      *> ***************************************************************


       identification division.
       function-id. agar-widget-focus.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-widget-focus]
      *> function agar-widget-focus(
       01 agar-widget                  usage pointer.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Attempt to force widget to hold focus
      *>
      *> See 'man 3 AG_Widget' for more details.
      *> [helpend-agar-widget-focus]

       procedure division using
           agar-widget
           returning result-code.

      *> widget focus
       call "AG_WidgetFocus" using
           by value agar-widget
           returning result-code

       goback.
       end function agar-widget-focus.
      *> ***************************************************************


       identification division.
       function-id. agar-widget-unfocus.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-widget-unfocus]
      *> function agar-widget-unfocus(
       01 agar-widget                  usage pointer.
      *> ) returning
       01 extraneous                   usage binary-long.

      *> Attempt to force widget to lose focus
      *>
      *> See 'man 3 AG_Widget' for more details.
      *> [helpend-agar-widget-unfocus]

       procedure division using
           agar-widget
           returning extraneous.

      *> widget unfocus
       call "AG_WidgetunFocus" using
           by value agar-widget
           returning omitted

       move 0 to extraneous
       goback.
       end function agar-widget-unfocus.
      *> ***************************************************************


       identification division.
       function-id. agar-write.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-write]
      *> function agar-write(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  usage pointer.
       01 agar-write-request           usage binary-c-long.
       01 agar-write-actual            usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Write to a datasource from source pointer for a given length.
      *>
      *> Actual bytes written set in agar-write-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-write]

       procedure division using
           agar-datasource
           agar-buffer
           agar-write-request
           agar-write-actual
           returning result-code.

       call "AG_WriteP" using
           by value agar-datasource
           by value agar-buffer
           by value agar-write-request
           by reference agar-write-actual
           returning result-code

       goback.
       end function agar-write.
      *> ***************************************************************


       identification division.
       function-id. agar-write-pic.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-write-pic]
      *> function agar-write-pic(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  pic x any length.
       01 agar-write-request           usage binary-c-long.
       01 agar-write-actual            usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Write to a datasource for a given length.
      *>
      *> Actual bytes written set in agar-write-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-write-pic]

       procedure division using
           agar-datasource
           agar-buffer
           agar-write-request
           agar-write-actual
           returning result-code.

       if agar-write-request < 0 then
           move length(agar-buffer) to agar-write-request
       end-if
       if agar-write-request > length(agar-buffer) then
           move length(agar-buffer) to agar-write-request
       end-if
       call "AG_WriteP" using
           by value agar-datasource
           by reference agar-buffer
           by value agar-write-request
           by reference agar-write-actual
           returning result-code

       goback.
       end function agar-write-pic.
      *> ***************************************************************


       identification division.
       function-id. agar-write-at.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-write-at]
      *> function agar-write-at(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  usage pointer.
       01 agar-write-request           usage binary-c-long.
       01 agar-write-position          usage binary-c-long.
       01 agar-write-actual            usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Write to a datasource given length and position (from start).
      *>
      *> Actual bytes written set in agar-write-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-write-at]

       procedure division using
           agar-datasource
           agar-buffer
           agar-write-request
           agar-write-position
           agar-write-actual
           returning result-code.

       call "AG_WriteAtP" using
           by value agar-datasource
           by value agar-buffer
           by value agar-write-request
           by value agar-write-position
           by reference agar-write-actual
           returning result-code

       goback.
       end function agar-write-at.
      *> ***************************************************************


       identification division.
       function-id. agar-write-at-pic.

       data division.
       working-storage section.

       linkage section.
      *> [helpstart-agar-write-at-pic]
      *> function agar-write-at-pic(
       01 agar-datasource              usage pointer.
       01 agar-buffer                  pic x any length.
       01 agar-write-request            usage binary-c-long.
       01 agar-write-position           usage binary-c-long.
       01 agar-write-actual             usage binary-c-long.
      *> ) returning
       01 result-code                  usage binary-long.

      *> Write to a datasource given length and position (from start).
      *>
      *> Actual bytes written set in agar-write-actual.
      *> result-code is -1 for error, or 0 for success.
      *>
      *> Note: the binary-c-long (for size_t), arguments can not be
      *> literals from the caller, but must be properly sized.
      *>
      *> See 'man 3 AG_DataSource' for more details.
      *> [helpend-agar-write-at-pic]

       procedure division using
           agar-datasource
           agar-buffer
           agar-write-request
           agar-write-position
           agar-write-actual
           returning result-code.

       call "AG_WriteAtP" using
           by value agar-datasource
           by reference agar-buffer
           by value agar-write-request
           by value agar-write-position
           by reference agar-write-actual
           returning result-code

       goback.
       end function agar-write-at-pic.
      *> ***************************************************************


       identification division.
       function-id. repne-scasb.

       data division.
       working-storage section.
       01 limiter                       usage binary-long.

       linkage section.
      *> [helpstart-repne-scasb]
      *> function repne-scasb(
       01 buffer                        pic x any length.
      *> ) returning
       01 sentinel-z                    usage binary-long.

      *> Find sentinel NUL byte
      *> [helpend-agar-write-at-pic]

       procedure division using
           buffer
           returning sentinel-z.

       move 0 to sentinel-z
       move function length(buffer) to limiter
       inspect buffer tallying sentinel-z for characters
           before initial low-value
       if sentinel-z < 1 then move 1 to sentinel-z end-if
       if sentinel-z > limiter then move limiter to sentinel-z end-if

       goback.
       end function repne-scasb.
      *> ***************************************************************
