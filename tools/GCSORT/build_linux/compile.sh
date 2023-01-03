make -f ../Makefile clean
make -f ../Makefile all 2>logerr.txt | tee logout.txt
cp gcsort gcsort_testcase/bin/gcsort
cp gcsort tests/bin/gcsort