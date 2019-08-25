htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0039_jq_jcarousel

# compile
0039_jq_jcarousel:	0039_jq_jcarousel.cob 0039_jq_jcarousel_param.cpy
	cobc -x -free 0039_jq_jcarousel.cob -o 0039_jq_jcarousel
	cp 0039_jq_jcarousel $(cgibin)/0039_jq_jcarousel
	cp 0039_jq_jcarousel_test.html $(htdocs)/0039_jq_jcarousel_test.html
	cp js/jquery-3.3.1.min.js $(htdocs)/js/jquery-3.3.1.min.js
	cp js/jquery.jcarousel.min.js $(htdocs)/js/jquery.jcarousel.min.js
	cp js/jcarousel.basic.js $(htdocs)/js/jcarousel.basic.js
	cp css/jcarousel.basic.css $(htdocs)/css/jcarousel.basic.css
	cp img/0039_img1.jpg $(htdocs)/img/0039_img1.jpg
	cp img/0039_img2.jpg $(htdocs)/img/0039_img2.jpg
	cp img/0039_img3.jpg $(htdocs)/img/0039_img3.jpg
	cp img/0039_img4.jpg $(htdocs)/img/0039_img4.jpg
	cp img/0039_img5.jpg $(htdocs)/img/0039_img5.jpg
	cp img/0039_img6.jpg $(htdocs)/img/0039_img6.jpg
	cp img/0039_img7.jpg $(htdocs)/img/0039_img7.jpg
	cp img/0039_img8.jpg $(htdocs)/img/0039_img8.jpg
	
# convert
0039_jq_jcarousel.cob:	0039_jq_jcarousel_cob.html
	$(htm2cob) 0039_jq_jcarousel_cob.html -v
	
clean:
	rm -f 0039_jq_jcarousel.cob
	rm -f 0039_jq_jcarousel
	rm -f $(cgibin)/0039_jq_jcarousel
	rm -f $(htdocs)/0039_jq_jcarousel_test.html
	rm -f $(htdocs)/js/jquery-3.3.1.min.js
	rm -f $(htdocs)/js/jquery.jcarousel.min.js
	rm -f $(htdocs)/js/jcarousel.basic.js
	rm -f $(htdocs)/css/jcarousel.basic.css
	rm -f $(htdocs)/img/0039_img1.jpg
	rm -f $(htdocs)/img/0039_img2.jpg
	rm -f $(htdocs)/img/0039_img3.jpg
	rm -f $(htdocs)/img/0039_img4.jpg
	rm -f $(htdocs)/img/0039_img5.jpg
	rm -f $(htdocs)/img/0039_img6.jpg
	rm -f $(htdocs)/img/0039_img7.jpg
	rm -f $(htdocs)/img/0039_img8.jpg
    