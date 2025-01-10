# Matching 2 files - three different ways: Sequential or Indexed or Memory Mapping 

## Linux or Windows 

This project will provide 3 GnuCOBOL programs that will match file1 to file2. 
And show Memory Mapping.  

## Files 
File2 is the master file, the largest file that contains records that have the 
record key in the first 9 bytes, then data for next 20 bytes.
File1 is the smaller file that just has 9 byte keys that may or may not 
 be found on File2.  
The programs will look up every file1 record to see if it is on file2, 
 if it finds a match it prints ( to sysout ) the matched record.
 
## Programs 

 ### createfile1.cbl
  This program creates a random number for the key and then does an internal 
  sort and dedups the records. The program is set to create 100,000 records 
  before the sort process. It will out put the record to sysout. The output 
  file will be 9 bytes and is created by sending records to sysout. 
  
 ### createfile2.cbl 
  This program creates a random number for the key and then does an internsl 
  sort and dedups the records. The program is set to create 350,000,000 records 
  before the sort process. It will out put the record to sysout. The output 
  file will be 29 or 30 bytes, depending on Linux or Windows, with 9 byte key 
  and some random data filling out rest of the record. 

 ### flat2index.cbl
  This program reads in file2 and creates an indexed file with primary 
  key as the first 9 bytes and writes the file out as file2.dat. 

 ### indexmatchfile.cbl 
  This program reads in file1 and does a random read to file2.dat. If there 
  is a match, it will write out the matched record to sysout. 

 ### mmapmatchfile.cbl or wmmapmatchfile.cbl 
  This it the memory mapping program that does lookups using a search 
  on them mapped file2.  If there is a match, it will write out the matched 
  record to sysout.   
  
  ### seqmatchfile.cbl 
   This file simply reads both files and will match file1 to file2. 
   If there is a match, it will write out the matched record to sysout.    

 ## Compiling and Running 
 
  ### Linux
   All programs were compiled with: 
   ```
   cobc -x pgmname.cbl -std=mf 
   ``` 
   I previously, a few years ago, had Simon Sobisch help correct my System call
   on the Linux mmap program. Maybe even a new version of the GnuCOBOL compiler 
   will change it either way...
   
  ### Windows 
   Using windows is a little different. The memory map call is way different, so 
   I had to set up the compile/run environment with these two SET statements to 
   use the correct library. 
   ```
   set COB_LIBRARY_PATH=C:\Windows\System32
   set COB_PRE_LOAD=kernel32 
   ``` 
   All programs except the memory mapping program were compiled with: 
   ```
   cobc -x pgmname.cbl -std=mf 
   ```
   The wmmapmatch.cbl program was compiled with: 
   ```
   cobc -x wmmapfilex2.cbl -lkernel32 -Q "C:\Windows\System32\kernel32.dll" 
   ``` 
   I had to ask Chuck Haatvedt on the Windows compile instructions 
   and other Windows help. Hat tip to Chuck. And I did run my linux mmap program
   by AI and it helped me with the windows calls (so did Chuck) 
   
  ### How to run the programs
    I have included a Windows .bat file and a Linux .sh file that runs  
    and times the programs. Adjust to your system and directory structure. 
    You can see that most programs have the >sysout 2>syserr to write files and 
    log errors. 
    If you do not wish to use the timers, then just run the executables manually
    in the same sequence. 

  ### File sizes and 64 vs 32 bit OS 
    The createfile2 program can be edited to create a 1.5 Gigabyte file 
    by using the 50,000,000 perform statement. To create a 7.7 Gigabyte 
    file, change it to 350,000,000 . 
    My Window and Linux boxes are all 64 bit and can run very large Gigabyte files.
    But if you are on 32 bits, just don't create a file2 over your limit.
    The Indexed file2.dat will be about twice the side of the flat file2 size. 
    The 3 .out files from the 3 matching programs should contain the exact 
    same records, If you run all 3 matching programs. 	

  ### Time of processing	
    The reason I wanted to have the three different matching programs 
	was to see which is the fastest. And also, some developers do not use 
	indexed files and could use the memory mapping process as it is faster 
	than the sequential file process (taking into account the file sizes) 
	So the fastest I have determined is Indexed, then Memory 
	Mapping (with very close times as the indexed ones); and ofcourse
	the sequential is the slower process.   
    I have included the test text files of the two runtime logs in this project. 
    __NOTE:__  the createfile2 program may run over 1 hour to 1.5 hours, depending
    on the speed of Your system. So don't be alarmed, especially if you 
    are creating the 7+Gigabyte file. 
	
  ## License 
   This is just a sample and to be used as a guide if useful at all.  
   Licensed under the GNU Lesser General Public License as published by the
   Free Software Foundation, either version 3 of the License, or (at your 
   option) any later version.
   	
	
	