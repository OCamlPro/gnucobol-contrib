01  wTabe-Rec.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2018.03.02
*> Changelog:  1.0 first release.
*> *************************************************************
*> TABLES FILE     LREC = 100 Key = 7 data = 93 (75 + 18 filler)
*>****************************************************************
    03 wTabe-key.
       05 wTabe-ktip                        pic x(01). *> H = table header,  I = table item
       05 wTabe-ktab                        pic x(03).
       05 wTabe-ktab9 redefines wTabe-ktab  pic 9(03).
       05 wTabe-kcod                        pic x(03).
    03 wTabe-data                           pic x(75).
    03 wTabe-Fill                           pic x(18).

01  Tabe-fs                                 pic x(02).
01  wFileName                               pic x(012) value 'GC76F---.DAT'.
01  TABEFSPEC                               PIC X(012).
