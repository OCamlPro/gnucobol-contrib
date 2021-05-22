*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  treeFrames.cpy is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  treeFrames.cpy is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with treeFrames.cpy.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      treeFrames.cpy
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2021.04.29
*>
*> Usage:        Copy file for tree_internal_frames.cob
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.04.29 Laszlo Erdos: 
*>            - first version.
*>******************************************************************************
 
 01 C-MAX-IND                          CONSTANT AS 25.
 01 WS-NODES.
*>----------------------------------------------------------------------
*> root
*> 001 
  02 FILLER                            PIC 9(4) VALUE 0.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Order Management System (OMS)           ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Main Features --> 1 
*> 002 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Products                                ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 003 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Customers                               ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 004 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Shopping-Carts                          ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 005 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Orders                                  ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 006 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Audits                                  ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 007 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(40) VALUE
     "Reports                                 ".
  02 FILLER                            PIC X(40) VALUE
     "                                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Products --> 2
*> 008
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Department                              ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_department                         ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 009
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Category                                ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_category                           ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 010
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Product                                 ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_product                            ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 011
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Product-Category                        ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_product_category                   ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Customers --> 3
*> 012
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Customer                                ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_customer                           ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Shopping-Carts --> 4
*> 013
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Shopping-Cart                           ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_shopping_cart                      ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 014
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Shipping-Region                         ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_shipping_region                    ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 015
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Shipping                                ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_shipping                           ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 016
  02 FILLER                            PIC 9(4) VALUE 4.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Tax                                     ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_tax                                ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Orders --> 5
*> 017
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Orders                                  ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_orders                             ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 018
  02 FILLER                            PIC 9(4) VALUE 5.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Order-Detail                            ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_order_detail                       ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Audits --> 6
*> 019
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Audit                                   ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_audit                              ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 020
  02 FILLER                            PIC 9(4) VALUE 6.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Review                                  ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_review                             ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------
*> WS-NODE-PARENT-IND for Reports --> 7
*> 021
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Products-Report                         ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_products_report                    ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 022
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Customers-Report                        ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_customers_report                   ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 023
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Orders-Report                           ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_orders_report                      ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 024
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Export-Data                             ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_export_data                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*> 025
  02 FILLER                            PIC 9(4) VALUE 7.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(40) VALUE
     "Import-Data                             ".
  02 FILLER                            PIC X(40) VALUE
     "ifrm_import_data                        ".
  02 FILLER                            PIC 9(1) VALUE 0.
*>----------------------------------------------------------------------

 01 WS-NODES-R REDEFINES WS-NODES.
  02 WS-NODES-LINES OCCURS C-MAX-IND TIMES.
   03 WS-NODE-PARENT-IND               PIC 9(4).
   03 WS-NODE-ID                       BINARY-LONG.
   03 WS-LEAF-FLAG                     PIC 9(1).
      88 V-LEAF-NO                     VALUE 0.
      88 V-LEAF-YES                    VALUE 1.
   03 WS-NODE-NAME                     PIC X(40).
   03 WS-IFRAME-NAME                   PIC X(40).
   03 WS-IFRAME-CREATED                PIC 9(1).
      88 V-NO                          VALUE 0.
      88 V-YES                         VALUE 1.
