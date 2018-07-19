      *>************************************************************************
      *>  This file is part of DBsample.
      *>
      *>  LNMOD1.cpy is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  LNMOD1.cpy is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with LNMOD1.cpy.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      LNMOD1.cpy
      *>
      *> Purpose:      Linkage for the module PGMOD1.cbl
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        Use this copy file in GnuCOBOL PostgreSQL programs.
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       01 LN-MOD.
         02 LN-INPUT.
           03 LN-FNC                      PIC X(2).
              88 V-LN-FNC-CONNECT         VALUE "CO".
              88 V-LN-FNC-DISCONNECT      VALUE "DC".
           03 LN-CONNECT.
             04 LN-DBNAME                 PIC X(20).
             04 LN-USERID                 PIC X(20).
             04 LN-PSWD                   PIC X(20).
         02 LN-OUTPUT.
           03 LN-MSG.
             04 LN-SQLCODE                PIC S9(10).
             04 LN-SQLSTATE               PIC X(5).
             04 LN-MSG-1                  PIC X(80).
             04 LN-MSG-2                  PIC X(80).
             04 LN-MSG-3                  PIC X(80).
             04 LN-MSG-4                  PIC X(80).
