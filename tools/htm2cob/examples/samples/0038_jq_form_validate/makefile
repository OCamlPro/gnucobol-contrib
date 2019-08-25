htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0038_jq_form_validate_1 0038_jq_form_validate_2

# compile
0038_jq_form_validate_1:	0038_jq_form_validate_1.cob 0038_jq_form_validate_1_param.cpy
	cobc -x -free 0038_jq_form_validate_1.cob -o 0038_jq_form_validate_1
	cp 0038_jq_form_validate_1 $(cgibin)/0038_jq_form_validate_1
	cp 0038_jq_form_validate_test.html $(htdocs)/0038_jq_form_validate_test.html
	cp js/jquery-3.3.1.min.js $(htdocs)/js/jquery-3.3.1.min.js
	cp js/jquery.validate.min.js $(htdocs)/js/jquery.validate.min.js

0038_jq_form_validate_2:	0038_jq_form_validate_2.cob 0038_jq_form_validate_2_param.cpy
	cobc -x -free 0038_jq_form_validate_2.cob -o 0038_jq_form_validate_2
	cp 0038_jq_form_validate_2 $(cgibin)/0038_jq_form_validate_2
	
# convert
0038_jq_form_validate_1.cob:	0038_jq_form_validate_1_cob.html
	$(htm2cob) 0038_jq_form_validate_1_cob.html -v

0038_jq_form_validate_2.cob:	0038_jq_form_validate_2_cob.html
	$(htm2cob) 0038_jq_form_validate_2_cob.html -v
	
clean:
	rm -f 0038_jq_form_validate_1.cob
	rm -f 0038_jq_form_validate_1
	rm -f $(cgibin)/0038_jq_form_validate_1
	rm -f 0038_jq_form_validate_2.cob
	rm -f 0038_jq_form_validate_2
	rm -f $(cgibin)/0038_jq_form_validate_2
	rm -f $(htdocs)/0038_jq_form_validate_test.html
	rm -f $(htdocs)/js/jquery-3.3.1.min.js
	rm -f $(htdocs)/js/jquery.validate.min.js
    