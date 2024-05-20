# COBOL-access-spreadsheet-as-xml
Read or even update spreadsheets that are converted to xml with Cobol 
Convert speadsheet to XML and then you can read through it and access the individual cell data. 
Read or even update spreadsheets that are converted to xml with Cobol.  Convert spreadsheet to XML and then you can read through it and access the individual cell data.
To manually create an xml file from a spreadsheet, just open create or the spreadsheet in Microsoft® (MS) or LibreOffice® (LO) calc and save as xml (or even fods for LibreOffice).  
If you have many spreadsheets to convert you can run a batch process for LibreOffice on Linux or Windows®.  I read where you can run a .bat file on Windows for Excel, but I was not able to do that.   I use Linux mostly anyway.  I included the .sh and the .bat file for my LO conversions.  The process will name the output file the same as the input file name but with the new extention (xml or fods)
NOTE;  When running the .sh conversion script on Linux, the following 3 applications had to be added as I received these errors:
	First error was:  javaldx error. Second error was:  Error: source file could not be loaded. 
	javaldx: Could not find a Java Runtime Environment!
	Warning: failed to read path from javaldx
	javaldx failed!
	Warning: failed to read path from javaldx
	Error: source file could not be loaded
The fix was to install on Linux: 
	sudo apt-get install default-jre libreoffice-java-common
	sudo apt install libreoffice-writer
	sudo apt install libreoffice-calc

The xml for MS is different from LO as MS has a table line that tells the number of rows.  Both have the number of columns, which the Cobol programs uses to parse through the rows. So there are two GnuCOBOL programs, one for Microsoft and one for LibreOffice.  

I have attached both programs, the batch file for Linux LO and Windows MS for multi-files just use the asterisk (*) for substitution. I have attached my small test spreadsheet and converted xml/fods files.   The program just reads through the xml/fods file until it reads a table record or a cell/column record or an end-of-row record.  
The programs just print the data as it would appear in a spreadsheet.  

You can actually update or insert or delete rows.  Just keep the MS row counter updated… Also you would still have to create a new spreadsheet in MS Excel or LO calc, so that the fonts and sizes and all the other data descriptions are there.  If you do that then you are on your own, but the changes to the program would be to just write out 5 files: a Header file (all the stuff before the data cells), a table file (may have changes) , a middle file (has data you will need if table changes), a  cell file (the data), and the end file (with the end stuff). That is more than this little project will do.  This project is just to access and print out to a file a spreadsheet converted for this purpose, as reading it as a binary spreadsheet would be… Not good.  

If you do update the xml/fods file, just upload it back and manually convert (or batch script/shell) it back to a spreadsheet. 

To compile on Gnucobol: cobc -x processexcelxmlLO.cbl -std=mf 
 or                        cobc -x processexcelxmlMS.cbl -std=mf

To Execute:  processexcelxmlLO input.spreadsheet.file.name output.xml 
 or           processexcelxmlMS input.spreadsheet.file.name output.xml
