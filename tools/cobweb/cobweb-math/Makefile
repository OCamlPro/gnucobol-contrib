# make cobweb-math with libmatheval and libreadline
.RECIPEPREFIX = >

.PHONY: all clean doc

all: cobweb-math.so cobweb-math-demo

cobweb-math.so: cobweb-math.cob wrapmath.c
> cobc -bvgd cobweb-math.cob wrapmath.c -lmatheval -lreadline

cobweb-math-demo: cobweb-math-demo.cob cobweb-math.so
> LD_RUN_PATH=. cobc -xj cobweb-math-demo.cob -l:cobweb-math.so -L.

cobweb-math-demo.out: cobweb-math-demo
> ./cobweb-math-demo >cobweb-math-demo.out

cobweb-math.html: cobweb-math.cob wrapmath.c cobweb-math-demo.cob \
    cobweb-math.cpy  Makefile cobweb-math-demo.out
doc: cobweb-math.html
> sed ':loop;/!doc-marker!/{d};N;b loop' cobweb-math.cob | sed '$${/^$$/d;}' \
| sed '$$d' | rst2html >cobweb-math.html

callmath: callmath.cob wrapmath.c
> cobc -xjd callmath.cob wrapmath.c -lmatheval

clean:
> -rm cobweb-math.c.* cobweb-math.c cobweb-math.i cobweb-math.so
