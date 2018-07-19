      *>************************************************************************
      *>  This file is part of DB2sample.
      *>
      *>  LNSQLMSG.cpy is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  LNSQLMSG.cpy is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with LNSQLMSG.cpy.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************

      *>************************************************************************
      *> Program:      LNSQLMSG.cpy
      *>
      *> Purpose:      Linkage for the module DB2SQLMSG.cob
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2015.12.24
      *>
      *> Tectonics:    ---
      *>
      *> Usage:        Use this copy file in GnuCOBOL DB2 programs.
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2015.12.24 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       01 LN-SQLMSG.
         02 LN-MSG-1                   PIC X(80).
         02 LN-MSG-2                   PIC X(80).
         02 LN-MSG-3                   PIC X(80).
         02 LN-MSG-4                   PIC X(80).
