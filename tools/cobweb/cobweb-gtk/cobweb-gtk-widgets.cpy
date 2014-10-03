      *>****C* cobweb/cobweb-gtk-widgets [0.2]
      *> Author:
      *>   Brian Tiffin
      *> Colophon:
      *>   Part of the GNU Cobol free software project
      *>   Copyright (C) 2014, Brian Tiffin
      *>   Date      20130308
      *>   Modified  20140910
      *>   License   GNU General Public License, GPL, 3.0 or greater
      *>   Documentation licensed GNU FDL, version 2.1 or greater
      *> Purpose:
      *> A managed widget pool, access by subscript
       01 total-widgets        usage binary-long             external.
       01 gtk-widgets                                        external.
          05 contrivance  occurs 32768 times depending on total-widgets.
             10 contrived      usage pointer.
             10 cobweb-pointer usage pointer.
             10 cobweb-int     usage binary-long.
      *>****
