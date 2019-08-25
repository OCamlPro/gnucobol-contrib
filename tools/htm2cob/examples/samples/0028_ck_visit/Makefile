htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0028_ck_visit

# compile
0028_ck_visit:	0028_ck_visit.cob 0028_ck_visit_param.cpy
	cobc -x -free 0028_ck_visit.cob -o 0028_ck_visit
	cp 0028_ck_visit $(cgibin)/0028_ck_visit
	cp 0028_ck_visit_test.html $(htdocs)/0028_ck_visit_test.html
	
# convert
0028_ck_visit.cob:	0028_ck_visit_cob.html
	$(htm2cob) 0028_ck_visit_cob.html -v
	
clean:
	rm -f 0028_ck_visit.cob
	rm -f 0028_ck_visit
	rm -f $(cgibin)/0028_ck_visit
	rm -f $(htdocs)/0028_ck_visit_test.html
    