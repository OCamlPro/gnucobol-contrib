htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0037_ajax_query_str_1 0037_ajax_query_str_2

# compile
0037_ajax_query_str_1:	0037_ajax_query_str_1.cob 0037_ajax_query_str_1_param.cpy
	cobc -x -free 0037_ajax_query_str_1.cob -o 0037_ajax_query_str_1
	cp 0037_ajax_query_str_1 $(cgibin)/0037_ajax_query_str_1
	cp 0037_ajax_query_str_test.html $(htdocs)/0037_ajax_query_str_test.html

0037_ajax_query_str_2:	0037_ajax_query_str_2.cob 0037_ajax_query_str_2_param.cpy
	cobc -x -free 0037_ajax_query_str_2.cob -o 0037_ajax_query_str_2
	cp 0037_ajax_query_str_2 $(cgibin)/0037_ajax_query_str_2
	
# convert
0037_ajax_query_str_1.cob:	0037_ajax_query_str_1_cob.html
	$(htm2cob) 0037_ajax_query_str_1_cob.html -v
	
0037_ajax_query_str_2.cob:	0037_ajax_query_str_2_cob.html
	$(htm2cob) 0037_ajax_query_str_2_cob.html -v -m
	
clean:
	rm -f 0037_ajax_query_str_1.cob
	rm -f 0037_ajax_query_str_1
	rm -f $(cgibin)/0037_ajax_query_str_1
	rm -f 0037_ajax_query_str_2.cob
	rm -f 0037_ajax_query_str_2
	rm -f $(cgibin)/0037_ajax_query_str_2
	rm -f $(htdocs)/0037_ajax_query_str_test.html
    