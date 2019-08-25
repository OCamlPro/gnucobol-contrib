htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0006_comment

# compile
0006_comment:	0006_comment.cob 0006_comment_param.cpy
	cobc -x -free 0006_comment.cob -o 0006_comment
	cp 0006_comment $(cgibin)/0006_comment
	cp 0006_comment_test.html $(htdocs)/0006_comment_test.html
	
# convert
0006_comment.cob:	0006_comment_cob.html
	$(htm2cob) 0006_comment_cob.html -v
	
clean:
	rm -f 0006_comment.cob
	rm -f 0006_comment
	rm -f $(cgibin)/0006_comment
	rm -f $(htdocs)/0006_comment_test.html
    