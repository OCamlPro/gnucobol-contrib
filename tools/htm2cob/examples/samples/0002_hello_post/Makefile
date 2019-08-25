htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0002_hello_post

# compile
0002_hello_post:	0002_hello_post.cob 0002_hello_post_param.cpy
	cobc -x -free 0002_hello_post.cob -o 0002_hello_post
	cp 0002_hello_post $(cgibin)/0002_hello_post
	cp 0002_hello_post_test.html $(htdocs)/0002_hello_post_test.html
	
# convert
0002_hello_post.cob:	0002_hello_post_cob.html
	$(htm2cob) 0002_hello_post_cob.html -v
	
clean:
	rm -f 0002_hello_post.cob
	rm -f 0002_hello_post
	rm -f $(cgibin)/0002_hello_post
	rm -f $(htdocs)/0002_hello_post_test.html
    