Brian Tiffin mentioned Rosetta Code at one time. So I looked it up (rosettacode.org) and browsed through the different Tasks list.  I saw that there was no COBOL entry for the Biorhythms task. I remember back in the 1980’s, when I was on the mainframe and using COBOL, we also had use to EasyTrieve and QUIKJOB.  Quikjob has a biorhythm program that came with the software and it would create a graph (text graph) of the three biorhythm cycles. (Physical, Emotional, and Mental).  I saw the graph that the Fortran program in that tasks produced and the QuikJob program was similar. 
I thought of doing the same, but now, with the many software packages that do graphs and plots, I figure just create a CSV file and run it though one of those. I picked MicroSoft Excel and LibreOffice Calc.
Biorhythms programs: 
Bio1.cbl: This program is the one I used to put as an entry into the Rosetta Code page. I will take a birthdate and a specific days date and print out to sysout the number of days between the date and the 3 biorhythm cycles, with the cycle day and the plot on the Y axis, and if it were a Critical (crosses the X axis), or a Peak (at the top of the Y axis, or a Valley (at the bottom of the Y axis). This program would follow the RosettaCode specs. 
Bio2.cbl: This program is the exact same of Bio1.cbl, but I removed the hard coded edits for the dates and used the intrinsic function test-formatted-datetime to verify the dates.
Bio3.cbl: This program will list the date and the 3 cycles for 98 days (hard coded). Then you can see 3 months of data in the sysout listing. 
Bio4.cbl: This program creates the CSV sysout file for 34 days, which would have at least one full cycle of all three biorhythm cycles. Save the sysout file as a txt file and run it through the Excel or Calc software to create the Graphs. 

I compiled each program with this option: 
cobc -x bioX.cbl -std=mf 
To run the programs and see the sysout: 
Bio2 18090212 18650415 
Here is the output of bio2.cbl:
bio2 18090212 18650415  
jamesw@pop-os:~/cbl$ bio2 18090212 18650415
0020516
Physical  00:+000.0% critical
Emotional 20:-097.5% valley
Mental    23:-094.5% 

And to create the 34 day CSV file (I named it a txt file): 
bioX BirthDate PlotDate >Out.Txt example for Abe Lincoln:  
bio4 18090212 18650330 > bio4April1865.txt
There are some good videos on how to import and plot the CSV files. 
I like these two short, to the point, videos:
You can look them up on YouTube. 
“ How to Create a Line Chart in LibreOffice Calc “ :: the one with 8:20 time
“ How to Plot Multiple Lines on One Excel Chart “  :: the one with 4:51 time

I will include an image of the bio4 CSV plot here. 
