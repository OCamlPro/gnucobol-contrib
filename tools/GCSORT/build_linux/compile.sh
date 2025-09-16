make -f ../Makefile clean
make -f ../Makefile all 2>logerr.txt | tee logout.txt

mkdir -p gcsort_testcase/bin
cp gcsort gcsort_testcase/bin/gcsort

mkdir -p tests/bin
cp gcsort tests/bin/gcsort