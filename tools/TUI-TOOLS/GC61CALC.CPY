01 GC61CALC pic x(12) value 'GC61CALC'.
01 Calc-Area.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    WORK-AREA FOR GC61CALC.COB - POCKET CALCULATOR
*> Usage:      call GC61CALC using Calc-Area
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2018.01.31
*> Changelog:
*> ***********************************************************************************
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*>
*> Result    number calculated returned to MODULE-CALLER-ID
*>
*> ***********************************************************************************
           05  Cc-Result        Pic 9(13) value zero.
