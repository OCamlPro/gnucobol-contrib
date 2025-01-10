@echo off
title Running wmmapjobs Sequentially
echo Starting wmmapjobs 

echo Running Job 1...
echo %time%
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\createfile1.exe" >file1
echo %time% 
echo Job 1 completed.

echo Running Job 2...
echo %time% 
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\createfile2.exe" >file2 
echo %time% 
echo Job 2 completed.

echo %time% 
echo Running Job 3...
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\flat2index.exe" file2 file2.dat 
echo %time% 
echo Job 3 completed.

echo %time% 
echo Running Job 4...
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\indexmatchfile.exe" file1 file2.dat >indxmatch.out 2>indxmatch.err 
echo %time% 
echo Job 4 completed.

echo Running Job 5...
echo %time% 
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\wmmapmatchfile.exe" >wmmapmatch.out 2>wmmapmatch.err 
echo %time% 
echo Job 5 completed.

echo Running Job 6...
echo %time% 
call "D:\Old Hard Drive\Documents\Computer Stuff\TEMPS\seqmatchfile.exe" >seqmatch.out 2>seqmatch.err
echo %time% 
echo Job 6 completed.

echo wmmapjobs completed.