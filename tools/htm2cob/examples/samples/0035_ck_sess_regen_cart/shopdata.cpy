*> categories
 01 CAT-MAX-IND                        CONSTANT AS 4.
 01 WS-CAT-TAB-R.
  02 FILLER                            PIC X(180) 
     VALUE "1;Vital items".
  02 FILLER                            PIC X(180) 
     VALUE "2;Robots and Mars-Rovers".
  02 FILLER                            PIC X(180) 
     VALUE "3;Real estate".
  02 FILLER                            PIC X(180) 
     VALUE "4;Travel".
 01 WS-CAT-TAB REDEFINES WS-CAT-TAB-R.
  02 WS-CAT-LINES OCCURS CAT-MAX-IND TIMES.
   03 WS-CAT-LINE.
    04 WS-CAT-NR                       PIC 9(1).
    04 FILLER                          PIC X(1).
    04 WS-CAT-NAME                     PIC X(178).    

*> items    
 01 CAT-ITEM-MAX-IND                   CONSTANT AS 17.
 01 WS-CAT-ITEM-TAB-R.
*> category 1 
  02 FILLER                            PIC X(180) 
     VALUE "1;1;0000000001;Oxygen (1 liter)".
  02 FILLER                            PIC X(180) 
     VALUE "1;2;0000000050;Water (1 liter)".
  02 FILLER                            PIC X(180) 
     VALUE "1;3;0000000250;Potato (1 Kg)".
  02 FILLER                            PIC X(180) 
     VALUE "1;4;0000000399;Mars beer (0,33 liter)".
  02 FILLER                            PIC X(180) 
     VALUE "1;5;0000000999;Mars VitalMix (0,33 liter)".
*> category 2 
  02 FILLER                            PIC X(180) 
     VALUE "2;1;0000060000;Universal Mars Robot".
  02 FILLER                            PIC X(180) 
     VALUE "2;2;0000200000;<a href='https://www.youtube.com/watch?v=BR542tQhXJo' target='_blank'>Cherry 2000 Female Android</a>".
  02 FILLER                            PIC X(180) 
     VALUE "2;3;0001500000;Mars Rover Speed".
  02 FILLER                            PIC X(180) 
     VALUE "2;4;0002500000;Mars Rover Off Road 4x4".
  02 FILLER                            PIC X(180) 
     VALUE "2;5;0008000000;Mars Flying Saucer".
*> category 3 
  02 FILLER                            PIC X(180) 
     VALUE "3;1;0005000000;Mars Iglu".
  02 FILLER                            PIC X(180) 
     VALUE "3;2;0020000000;Mars Farm".
  02 FILLER                            PIC X(180) 
     VALUE "3;3;0060000000;Mars Flat in the City".
  02 FILLER                            PIC X(180) 
     VALUE "3;4;0250000000;Mars Villa".
*> category 4 
  02 FILLER                            PIC X(180) 
     VALUE "4;1;0000049900;Travel to the north pole".
  02 FILLER                            PIC X(180) 
     VALUE "4;2;0000049900;Travel to the south pole".
  02 FILLER                            PIC X(180) 
     VALUE "4;3;0000200000;Mars Round trip".
 01 WS-CAT-ITEM-TAB REDEFINES WS-CAT-ITEM-TAB-R.
  02 WS-CAT-ITEM-LINES OCCURS CAT-ITEM-MAX-IND TIMES.
   03 WS-CAT-ITEM-LINE.
    04 WS-CAT-NR                       PIC 9(1).
    04 FILLER                          PIC X(1).
    04 WS-CAT-ITEM-NR                  PIC 9(1).
    04 FILLER                          PIC X(1).
    04 WS-CAT-ITEM-PRICE               PIC 9(8)V9(2).
    04 FILLER                          PIC X(1).
    04 WS-CAT-ITEM-NAME                PIC X(165).    
