      *> A managed widget pool, access by subscript
       01 number-new           usage binary-long         external.
       01 gtk-widgets                                    external.
          05 cw                occurs 32768 times
                               depending on number-new.
             10 gtk-widget-record.
                15 widget                usage pointer.
          66 gwin         renames cw.            
          66 gbox         renames gtk-widget-record.
          66 gbutton      renames gtk-widget-record.
          66 gentry       renames gtk-widget-record.
          66 glabel       renames gtk-widget-record.

