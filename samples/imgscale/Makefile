all:	imgscale-test

imgscale-test:	imgscale-test.cob imgscale.c
			cobc -x -free -W imgscale-test.cob imgscale.c -lgd -lpng -lz -ljpeg -lfreetype -lm

clean:
	rm imgscale-test
	rm *_400.*