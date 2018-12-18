# compile
all : COOKIE-TEST

COOKIE-TEST : COOKIE-TEST.cob COOKIE
	cobc -x -free -W COOKIE-TEST.cob

COOKIE : COOKIE.cob
	cobc -m -free -W COOKIE.cob 
	
# clean
clean :
	rm -f COOKIE.dll
	rm -f COOKIE-TEST.exe

	