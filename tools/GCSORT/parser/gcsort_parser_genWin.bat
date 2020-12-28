:: GCSort
:: Windows environment
:: Generate parser GCSort 
::
win_bison     --defines=..\parser.h -o ..\parser.c parser.y
win_flex      --header-file=..\scanner.h  -d --nounistd --wincompat -o ..\scanner.c scanner.l
		 