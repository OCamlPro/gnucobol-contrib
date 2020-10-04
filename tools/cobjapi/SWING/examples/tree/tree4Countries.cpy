*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tree4Countries.cpy is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tree4Countries.cpy is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tree4Countries.cpy.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tree4Countries.cpy
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.10.03
*>
*> Usage:        Copy file for tree4.cob
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.10.03 Laszlo Erdos: 
*>            - first version.
*>******************************************************************************
 
 01 C-MAX-IND                          CONSTANT AS 222.
 01 WS-NODES.
*>----------------------------------------------------------------------
*> root
*> 001 
  02 FILLER                            PIC 9(4) VALUE 0.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "All countries in the world                                      ".
*>----------------------------------------------------------------------
*> alphabet
*> 002 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "A                                                               ".
*> 003 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "B                                                               ".
*> 004 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "C                                                               ".
*> 005 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "D                                                               ".
*> 006 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "E                                                               ".
*> 007 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "F                                                               ".
*> 008 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "G                                                               ".
*> 009 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "H                                                               ".
*> 010 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "I                                                               ".
*> 011 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "J                                                               ".
*> 012 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "K                                                               ".
*> 013 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "L                                                               ".
*> 014 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "M                                                               ".
*> 015 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "N                                                               ".
*> 016 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "O                                                               ".
*> 017 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "P                                                               ".
*> 018 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "Q                                                               ".
*> 019 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "R                                                               ".
*> 020 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "S                                                               ".
*> 021 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "T                                                               ".
*> 022 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "U                                                               ".
*> 023 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "V                                                               ".
*> 024 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "Y                                                               ".
*> 025 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(64) VALUE
     "Z                                                               ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for A --> 2
*> 026
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Afghanistan                     Kabul                    Asia   ".
*> 027
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Albania                         Tirana                   Europe ".
*> 028
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Algeria                         Algiers                  Africa ".
*> 029
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Andorra                         Andorra la Vella         Europe ".
*> 030
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Angola                          Luanda                   Africa ".
*> 031
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Antigua and Barbuda             St. John's               America".
*> 032
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Argentina                       Buenos Aires             America".
*> 033
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Armenia                         Yerevan                  Asia   ".
*> 034
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Australia                       Canberra                 Oceania".
*> 035
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Austria                         Vienna                   Europe ".
*> 036
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Azerbaijan                      Baku                     Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for B --> 3
*> 037
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bahamas                         Nassau                   America".
*> 038
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bahrain                         Manama                   Asia   ".
*> 039
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bangladesh                      Dhaka                    Asia   ".
*> 040
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Barbados                        Bridgetown               America".
*> 041
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Belarus                         Minsk                    Europe ".
*> 042
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Belgium                         Brussels                 Europe ".
*> 043
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Belize                          Belmopan                 America".
*> 044
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Benin                           Porto Novo               Africa ".
*> 045
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bhutan                          Thimphu                  Asia   ".
*> 046
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bolivia                         Sucre                    America".
*> 047
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bosnia and Herzegovina          Sarajevo                 Europe ".
*> 048
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Botswana                        Gaborone                 Africa ".
*> 049
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Brazil                          Brasilia                 America".
*> 050
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Brunei                          Bandar Seri Begawan      Asia   ".
*> 051
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Bulgaria                        Sofia                    Europe ".
*> 052
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Burkina Faso                    Ouagadougou              Africa ".
*> 053
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Burundi                         Bujumbura                Africa ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for C --> 4
*> 054
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Cambodia                        Phnom Penh               Asia   ".
*> 055
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Cameroon                        Yaounde                  Africa ".
*> 056
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Canada                          Ottawa                   America".
*> 057
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Cape Verde                      Praia                    Africa ".
*> 058
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Central African Republic        Bangui                   Africa ".
*> 059
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Chad                            N'Djamena                Africa ".
*> 060
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Chile                           Santiago                 America".
*> 061
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "China                           Beijing                  Asia   ".
*> 062
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Colombia                        Bogota                   America".
*> 063
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Comoros                         Moroni                   Africa ".
*> 064
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Costa Rica                      San Jose                 America".
*> 065
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Croatia                         Zagreb                   Europe ".
*> 066
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Cuba                            Havana                   America".
*> 067
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Cyprus                          Nicosia                  Europe ".
*> 068
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Czech Republic                  Prague                   Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for D --> 5
*> 069
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Democratic Republic of Congo    Kinshasa                 Africa ".
*> 070
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Denmark                         Copenagen                Europe ".
*> 071
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Djibouti                        Djibouti                 Africa ".
*> 072
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Dominica                        Roseau                   America".
*> 073
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Dominican Republic              Santo Domingo            America".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for E --> 6
*> 074
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "East Timor                      Dili                     Oceania".
*> 075
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ecuador                         Quito                    America".
*> 076
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Egypt                           Cairo                    Africa ".
*> 077
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "El Salvador                     San Salvador             America".
*> 078
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Equatorial Guinea               Malabo                   Africa ".
*> 079
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Eritrea                         Asmara                   Africa ".
*> 080
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Estonia                         Tallinn                  Europe ".
*> 081
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ethiopia                        Addis Ababa              Africa ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for F --> 7
*> 082
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Fiji                            Suva                     Oceania".
*> 083
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Finland                         Helsinki                 Europe ".
*> 084
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "France                          Paris                    Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for G --> 8
*> 085
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Gabon                           Libreville               Africa ".
*> 086
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Gambia                          Banjul                   Africa ".
*> 087
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Georgia                         Tbilisi                  Asia   ".
*> 088
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Germany                         Berlin                   Europe ".
*> 089
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ghana                           Accra                    Africa ".
*> 090
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Greece                          Athens                   Europe ".
*> 091
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Grenada                         St. George's             America".
*> 092
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Guatemala                       Guatemala City           America".
*> 093
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Guinea                          Conakry                  Africa ".
*> 094
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Guinea-Bissau                   Bissau                   Africa ".
*> 095
  02 FILLER                            PIC 9(4) VALUE 8.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Guyana                          Georgetown               America".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for H --> 9
*> 096
  02 FILLER                            PIC 9(4) VALUE 9.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Haiti                           Port-au-Prince           America".
*> 097
  02 FILLER                            PIC 9(4) VALUE 9.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Honduras                        Tegucigalpa              America".
*> 098
  02 FILLER                            PIC 9(4) VALUE 9.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Hungary                         Budapest                 Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for I --> 10
*> 099
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Iceland                         Reykjavik                Europe ".
*> 100
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "India                           New Delhi                Asia   ".
*> 101
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Indonesia                       Jakarta                  Asia   ".
*> 102
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Iran                            Tehran                   Asia   ".
*> 103
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Iraq                            Baghdad                  Asia   ".
*> 104
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ireland                         Dublin                   Europe ".
*> 105
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Israel                          Jerusalem                Asia   ".
*> 106
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Italy                           Rome                     Europe ".
*> 107
  02 FILLER                            PIC 9(4) VALUE 10.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ivory Coast                     Yamoussoukro             Africa ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for J --> 11
*> 108
  02 FILLER                            PIC 9(4) VALUE 11.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Jamaica                         Kingston                 America".
*> 109
  02 FILLER                            PIC 9(4) VALUE 11.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Japan                           Tokyo                    Asia   ".
*> 110
  02 FILLER                            PIC 9(4) VALUE 11.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Jordan                          Amman                    Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for K --> 12
*> 111
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kazakhstan                      Astana                   Asia   ".
*> 112
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kenya                           Nairobi                  Africa ".
*> 113
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kiribati                        Tarawa                   Oceania".
*> 114
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Korea, North                    Pyongyang                Asia   ".
*> 115
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Korea, South                    Seoul                    Asia   ".
*> 116
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kosovo                          Pristina                 Europe ".
*> 117
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kuwait                          Kuwait City              Asia   ".
*> 118
  02 FILLER                            PIC 9(4) VALUE 12.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Kyrgyzstan                      Bishkek                  Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for L --> 13
*> 119
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Laos                            Vientiane                Asia   ".
*> 120
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Latvia                          Riga                     Europe ".
*> 121
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Lebanon                         Beirut                   Asia   ".
*> 122
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Lesotho                         Maseru                   Africa ".
*> 123
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Liberia                         Monrovia                 Africa ".
*> 124
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Libya                           Tripoli                  Africa ".
*> 125
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Liechtenstein                   Vaduz                    Europe ".
*> 126
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Lithuania                       Vilnius                  Europe ".
*> 127
  02 FILLER                            PIC 9(4) VALUE 13.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Luxembourg                      Luxembourg               Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for M --> 14
*> 128
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Macedonia                       Skopje                   Europe ".
*> 129
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Madagascar                      Antananarivo             Africa ".
*> 130
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Malawi                          Lilongwe                 Africa ".
*> 131
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Malaysia                        Kuala Lumpur             Asia   ".
*> 132
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Maldives                        Male                     Asia   ".
*> 133
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mali                            Bamako                   Africa ".
*> 134
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Malta                           Valletta                 Europe ".
*> 135
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Marshall Islands                Majuro                   Oceania".
*> 136
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mauritania                      Nouakchott               Africa ".
*> 137
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mauritius                       Port Louis               Africa ".
*> 138
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mexico                          Mexico City              America".
*> 139
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Micronesia                      Palikir                  Oceania".
*> 140
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Moldova                         Chisinau                 Europe ".
*> 141
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Monaco                          Monaco                   Europe ".
*> 142
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mongolia                        Ulaanbaatar              Asia   ".
*> 143
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Montenegro                      Podgorica                Europe ".
*> 144
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Morocco                         Rabat                    Africa ".
*> 145
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Mozambique                      Maputo                   Africa ".
*> 146
  02 FILLER                            PIC 9(4) VALUE 14.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Myanmar                         Naypyidaw                Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for N --> 15
*> 147
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Namibia                         Windhoek                 Africa ".
*> 148
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Nauru                           Yaren                    Oceania".
*> 149
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Nepal                           Kathmandu                Asia   ".
*> 150
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Netherlands                     Amsterdam                Europe ".
*> 151
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "New Zealand                     Wellington               Oceania".
*> 152
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Nicaragua                       Managua                  America".
*> 153
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Niger                           Niamey                   Africa ".
*> 154
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Nigeria                         Abuja                    Africa ".
*> 155
  02 FILLER                            PIC 9(4) VALUE 15.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Norway                          Oslo                     Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for O --> 16
*> 156
  02 FILLER                            PIC 9(4) VALUE 16.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Oman                            Muscat                   Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for P --> 17
*> 157
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Pakistan                        Islamabad                Asia   ".
*> 158
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Palau                           Melekeok                 Oceania".
*> 159
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Palestine                       East Jerusalem           Asia   ".
*> 160
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Panama                          Panama City              America".
*> 161
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Papua New Guinea                Port Moresby             Oceania".
*> 162
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Paraguay                        Asuncion                 America".
*> 163
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Peru                            Lima                     America".
*> 164
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Philippines                     Manila                   Asia   ".
*> 165
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Poland                          Warsaw                   Europe ".
*> 166
  02 FILLER                            PIC 9(4) VALUE 17.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Portugal                        Lisbon                   Europe ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Q --> 18
*> 167
  02 FILLER                            PIC 9(4) VALUE 18.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Qatar                           Doha                     Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for R --> 19
*> 168
  02 FILLER                            PIC 9(4) VALUE 19.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Republic of the Congo           Brazzaville              Africa ".
*> 169
  02 FILLER                            PIC 9(4) VALUE 19.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Romania                         Bucharest                Europe ".
*> 170
  02 FILLER                            PIC 9(4) VALUE 19.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Russia                          Moscow                   Europe ".
*> 171
  02 FILLER                            PIC 9(4) VALUE 19.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Rwanda                          Kigali                   Africa ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for S --> 20
*> 172
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Saint Kitts and Nevis           Basseterre               America".
*> 173
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Saint Lucia                     Castries                 America".
*> 174
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Saint Vincent and the GrenadinesKingstown                America".
*> 175
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Samoa                           Apia                     Oceania".
*> 176
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "San Marino                      San Marino               Europe ".
*> 177
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Sao Tome and Principe           Sao Tome                 Africa ".
*> 178
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Saudi Arabia                    Riyadh                   Asia   ".
*> 179
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Senegal                         Dakar                    Africa ".
*> 180
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Serbia                          Belgrade                 Europe ".
*> 181
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Seychelles                      Victoria                 Africa ".
*> 182
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Sierra Leone                    Freetown                 Africa ".
*> 183
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Singapore                       Singapore                Asia   ".
*> 184
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Slovakia                        Bratislava               Europe ".
*> 185
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Slovenia                        Ljubljana                Europe ".
*> 186
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Solomon Islands                 Honiara                  Oceania".
*> 187
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Somalia                         Mogadishu                Africa ".
*> 188
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "South Africa                    Pretoria                 Africa ".
*> 189
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "South Sudan                     Juba                     Africa ".
*> 190
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Spain                           Madrid                   Europe ".
*> 191
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Sri Lanka                       Sri Jayawardenapura KotteAsia   ".
*> 192
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Sudan                           Khartoum                 Africa ".
*> 193
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Suriname                        Paramaribo               America".
*> 194
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Swaziland                       Mbabane                  Africa ".
*> 195
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Sweden                          Stockholm                Europe ".
*> 196
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Switzerland                     Bern                     Europe ".
*> 197
  02 FILLER                            PIC 9(4) VALUE 20.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Syria                           Damascus                 Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for T --> 21
*> 198
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Taiwan                          Taipei                   Asia   ".
*> 199
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Tajikistan                      Dushanbe                 Asia   ".
*> 200
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Tanzania                        Dodoma                   Africa ".
*> 201
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Thailand                        Bangkok                  Asia   ".
*> 202
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Togo                            Lome                     Africa ".
*> 203
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Tonga                           Nukualofa                Oceania".
*> 204
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Trinidad and Tobago             Port of Spain            America".
*> 205
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Tunisia                         Tunis                    Africa ".
*> 206
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Turkey                          Ankara                   Asia   ".
*> 207
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Turkmenistan                    Ashgabat                 Asia   ".
*> 208
  02 FILLER                            PIC 9(4) VALUE 21.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Tuvalu                          Funafuti                 Oceania".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for U --> 22
*> 209
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Uganda                          Kampala                  Africa ".
*> 210
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Ukraine                         Kiev                     Europe ".
*> 211
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "United Arab Emirates            Abu Dhabi                Asia   ".
*> 212
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "United Kingdom                  London                   Europe ".
*> 213
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "United States                   Washington D.C.          America".
*> 214
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Uruguay                         Montevideo               America".
*> 215
  02 FILLER                            PIC 9(4) VALUE 22.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Uzbekistan                      Tashkent                 Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for V --> 23
*> 216
  02 FILLER                            PIC 9(4) VALUE 23.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Vanuatu                         Port Vila                Oceania".
*> 217
  02 FILLER                            PIC 9(4) VALUE 23.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Vatican City                    Vatican City             Europe ".
*> 218
  02 FILLER                            PIC 9(4) VALUE 23.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Venezuela                       Caracas                  America".
*> 219
  02 FILLER                            PIC 9(4) VALUE 23.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Vietnam                         Hanoi                    Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Y --> 24
*> 220
  02 FILLER                            PIC 9(4) VALUE 24.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Yemen                           Sana'a                   Asia   ".
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Z --> 25
*> 221
  02 FILLER                            PIC 9(4) VALUE 25.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Zambia                          Lusaka                   Africa ".
*> 222
  02 FILLER                            PIC 9(4) VALUE 25.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(64) VALUE
     "Zimbabwe                        Harare                   Africa ".

 01 WS-NODES-R REDEFINES WS-NODES.
  02 WS-NODES-LINES OCCURS C-MAX-IND TIMES.
   03 WS-NODE-PARENT-IND               PIC 9(4).
   03 WS-NODE-ID                       BINARY-LONG.
   03 WS-LEAF-FLAG                     PIC 9(1).
      88 V-LEAF-NO                     VALUE 0.
      88 V-LEAF-YES                    VALUE 1.
   03 WS-COUNTRY                       PIC X(32).
   03 WS-CAPITAL                       PIC X(25).
   03 WS-CONTINENT                     PIC X(7).
