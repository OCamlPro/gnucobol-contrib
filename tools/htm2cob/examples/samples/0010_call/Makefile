htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0010_call 0010_sub1.dll 0010_sub2.dll

# compile
0010_call:	0010_call.cob 0010_call_param.cpy
	cobc -x -free 0010_call.cob -o 0010_call
	cp 0010_call $(cgibin)/0010_call
	cp 0010_call_test.html $(htdocs)/0010_call_test.html

0010_sub1.dll:	0010_sub1.cob
	cobc -m -free 0010_sub1.cob -o 0010_sub1
	cp 0010_sub1.dll $(cgibin)\0010_sub1.dll

0010_sub2.dll:	0010_sub2.cob
	cobc -m -free 0010_sub2.cob -o 0010_sub2
	cp 0010_sub2.dll $(cgibin)\0010_sub2.dll
	
# convert
0010_call.cob:	0010_call_cob.html
	$(htm2cob) 0010_call_cob.html -v
	
clean:
	rm -f 0010_call.cob
	rm -f 0010_call
	rm -f 0010_sub1.dll
	rm -f 0010_sub2.dll
	rm -f $(cgibin)/0010_call
	rm -f $(htdocs)/0010_call_test.html
	rm -f $(cgibin)/0010_sub1.dll
	rm -f $(cgibin)/0010_sub2.dll
    