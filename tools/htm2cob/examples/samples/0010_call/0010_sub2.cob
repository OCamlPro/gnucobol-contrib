*> 0010_sub2.COB
*> 
*> Dynamic CALL test. 
*>
 IDENTIFICATION DIVISION.
 PROGRAM-ID. 0010_sub2.
   AUTHOR. Laszlo Erdos

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 
 01 LNK-DATA                 PIC X ANY LENGTH.
 01 LNK-DATA-LEN             PIC S9(9) COMP-5.
 
 PROCEDURE DIVISION USING LNK-DATA, LNK-DATA-LEN.

 MAIN-SUB2 SECTION.

	DISPLAY "<p><h3>Start 0010_sub2</h3></p>"
    
    DISPLAY "LNK-DATA: " LNK-DATA "<BR>"
    DISPLAY "LNK-DATA-LEN: " LNK-DATA-LEN

    EXIT PROGRAM
	.
 MAIN-SUB2-EXIT.
     EXIT.
