htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0029_ck_save_data_1 0029_ck_save_data_2

# compile
0029_ck_save_data_1:	0029_ck_save_data_1.cob 0029_ck_save_data_1_param.cpy
	cobc -x -free 0029_ck_save_data_1.cob -o 0029_ck_save_data_1
	cp 0029_ck_save_data_1 $(cgibin)/0029_ck_save_data_1
	cp 0029_ck_save_data_test.html $(htdocs)/0029_ck_save_data_test.html

0029_ck_save_data_2:	0029_ck_save_data_2.cob 0029_ck_save_data_2_param.cpy
	cobc -x -free 0029_ck_save_data_2.cob -o 0029_ck_save_data_2
	cp 0029_ck_save_data_2 $(cgibin)/0029_ck_save_data_2
	
# convert
0029_ck_save_data_1.cob:	0029_ck_save_data_1_cob.html
	$(htm2cob) 0029_ck_save_data_1_cob.html -v

0029_ck_save_data_2.cob:	0029_ck_save_data_2_cob.html
	$(htm2cob) 0029_ck_save_data_2_cob.html -v
	
clean:
	rm -f 0029_ck_save_data_1.cob
	rm -f 0029_ck_save_data_1
	rm -f $(cgibin)/0029_ck_save_data_1
	rm -f 0029_ck_save_data_2.cob
	rm -f 0029_ck_save_data_2
	rm -f $(cgibin)/0029_ck_save_data_2
	rm -f $(htdocs)/0029_ck_save_data_test.html
    