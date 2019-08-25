htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0030_ck_param_1 0030_ck_param_2

# compile
0030_ck_param_1:	0030_ck_param_1.cob 0030_ck_param_1_param.cpy
	cobc -x -free 0030_ck_param_1.cob -o 0030_ck_param_1
	cp 0030_ck_param_1 $(cgibin)/0030_ck_param_1
	cp 0030_ck_param_test.html $(htdocs)/0030_ck_param_test.html

0030_ck_param_2:	0030_ck_param_2.cob 0030_ck_param_2_param.cpy
	cobc -x -free 0030_ck_param_2.cob -o 0030_ck_param_2
	cp 0030_ck_param_2 $(cgibin)/0030_ck_param_2
	
# convert
0030_ck_param_1.cob:	0030_ck_param_1_cob.html
	$(htm2cob) 0030_ck_param_1_cob.html -v

0030_ck_param_2.cob:	0030_ck_param_2_cob.html
	$(htm2cob) 0030_ck_param_2_cob.html -v
	
clean:
	rm -f 0030_ck_param_1.cob
	rm -f 0030_ck_param_1
	rm -f $(cgibin)/0030_ck_param_1
	rm -f 0030_ck_param_2.cob
	rm -f 0030_ck_param_2
	rm -f $(cgibin)/0030_ck_param_2
	rm -f $(htdocs)/0030_ck_param_test.html
    