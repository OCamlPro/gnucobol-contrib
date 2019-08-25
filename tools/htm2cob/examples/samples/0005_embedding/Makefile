htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0005_embedding

# compile
0005_embedding:	0005_embedding.cob 0005_embedding_param.cpy
	cobc -x -free 0005_embedding.cob -o 0005_embedding
	cp 0005_embedding $(cgibin)/0005_embedding
	cp 0005_embedding_test.html $(htdocs)/0005_embedding_test.html
	
# convert
0005_embedding.cob:	0005_embedding_cob.html
	$(htm2cob) 0005_embedding_cob.html -v
	
clean:
	rm -f 0005_embedding.cob
	rm -f 0005_embedding
	rm -f $(cgibin)/0005_embedding
	rm -f $(htdocs)/0005_embedding_test.html
    