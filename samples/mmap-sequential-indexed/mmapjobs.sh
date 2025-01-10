#!/bin/bash 
echo "date time start mmapjobs.sh " `date`
cd $HOME/Data 
echo "date time start mmapjobs.sh " `date`
echo "date time start job1 " `date`
createfile1 >file1 2>file1.err
echo "date time end job1 " `date`
echo "date time start job2 " `date`
createfile2 >file2 2>file2.err
echo "date time end job2 " `date`
echo "date time start job3 " `date`
flat2index file2 file2.dat 
echo "date time end job3 " `date`
echo "date time start job4 " `date`
indexmatchfile file1 file2.dat >indxmatch.out 2>indxmatch.err
echo "date time end job4 " `date`
echo "date time start job5 " `date`
mmapmatchfile >mmapmatch.out 2>mmapmatch.err 
echo "date time end job5 " `date`
echo "date time start job6 " `date` 
seqmatchfile >seqmatch.out 2>seqmatch.err 
echo "date time end job6 " `date`
echo "date time end mmapjobs.sh " `date` 

