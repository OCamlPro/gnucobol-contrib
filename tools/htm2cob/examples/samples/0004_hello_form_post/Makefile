htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0004_hello_form_post

# compile
0004_hello_form_post:	0004_hello_form_post.cob 0004_hello_form_post_param.cpy
	cobc -x -free 0004_hello_form_post.cob -o 0004_hello_form_post
	cp 0004_hello_form_post $(cgibin)/0004_hello_form_post
	cp 0004_hello_form_post_test.html $(htdocs)/0004_hello_form_post_test.html
	
# convert
0004_hello_form_post.cob:	0004_hello_form_post_cob.html
	$(htm2cob) 0004_hello_form_post_cob.html -v
	
clean:
	rm -f 0004_hello_form_post.cob
	rm -f 0004_hello_form_post
	rm -f $(cgibin)/0004_hello_form_post
	rm -f $(htdocs)/0004_hello_form_post_test.html
    