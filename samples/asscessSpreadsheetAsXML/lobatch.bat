:: this writes the xml to the (new) directory in the --outdir variable
::  and uses the input file name with the new .xml extention

@echo off

@echo off
set libreofficePath=C:\Program Files\LibreOffice\program\
set filePath=D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\censusTestLO100.ods  
set outputDir=D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\ConvertedToXML

"%libreofficePath%\soffice.exe" --headless --convert-to xml "%filePath%"  --outdir "%outputDir%"  
