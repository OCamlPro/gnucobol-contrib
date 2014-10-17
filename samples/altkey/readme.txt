
 altkey * Alternate Key demo. 

    This program demonstrates how alternate keys are used.  It is 
 intended for students who would like to learn how to use alternate   
 keys. 
 
    The program creates an indexed file and writes sample records to 
 it.  

    It then issues a START command on the alternate key.  This causes 
 all read next commands to read the file using the alternate key 
 instead of the primary key. 
 
    After each read through the alternate keys, one of the alternate 
 keys is blanked out or deleted and the read loop run again.  This is 
 repeated until there are no more alternate keys. 

    The program displays each file operation on the screen.  The left 
 column shows the operation, including the file status code.  The 
 right column shows the record, with the primary key followed by the 
 alternate key. 

    Blank alternate keys do not appear in the read loop because of the
 'suppress when spaces' clause.  As an exercise, comment out the 
 clause and see the difference when the program is run again. 

    To compile and run under GNU Cobol on Linux/Cygwin/MSYS:

cobc -x altkey.cob 
./altkey 

    To compile and run under GNU Cobol on MS Windows:

cobc -x altkey.cob 
.\altkey.exe

    If "suppress when space" is not supported, use the file i/o 
 rewrite and compile it again.  Or run the program without it.  
