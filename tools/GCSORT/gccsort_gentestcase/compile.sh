make clean  1>logout.txt  2>logerr.txt
make 2>>logerr.txt | tee -a logout.txt
cp gcsort_gentestcase bin/
