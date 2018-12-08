# cobweb-agar, libagar bindings as GnuCOBOL user defined functions
.RECIPEPREFIX = >
#.DEFAULT_GOAL = targets

# the main GnuCOBOL user defined function repository
cobweb-agar.so: cobweb-agar.cob libagar.cpy
> cobc -debug -m -g cobweb-agar.cob `agar-config --libs` `agar-math-config --libs` `agar-dev-config --libs`

# Get C Values from Agar headers into COBOL statements
gcv: gcv.c
> gcc -o gcv -DAGAR gcv.c

libagar.cpy: gcv libagar.gcv
> CFLAGS='-I/usr/local/include/agar -I/usr/local/include/agar/agar' sed -rf commands.sed libagar.gcv > libagar.cpy

cobweb-agar.o: cobweb-agar.cob
> cobc -debug -c -debug cobweb-agar.cob `agar-config --libs` `agar-math-config --libs`

# helper targets
.PHONY: basic test file template html docs
.PHONY: help helplist tarball targets clean

# relies on .gc. extension extension
clean:
> -rm cobweb-agar.gc.c cobweb-agar.gc.c.* cobweb-agar.i cobweb-agar.so gcv libagar.cpy gnucobol-agar-starter*

# documentation
cobweb-agar.html: cobweb-agar.rst cobweb-agar.so commands.sed
> CFLAGS='-I/usr/local/include/agar' sed -r -f commands.sed cobweb-agar.rst | rst2html - cobweb-agar.html 

html: cobweb-agar.html
docs: cobweb-agar.html
> xdg-open cobweb-agar.html

basic: cobweb-agar.so
> cobcrun cobweb-agar basic

test: cobweb-agar.so
> cobcrun cobweb-agar test

file: cobweb-agar.so
> cobcrun cobweb-agar file

template: cobweb-agar.so
> cobcrun cobweb-agar new

starter: cobweb-agar.so
> cobcrun cobweb-agar new
> cobc -g -xj gnucobol-agar-starter.cob cobweb-agar.cob `agar-config --libs` `agar-math-config --libs` `agar-dev-config --libs`

help: cobweb-agar.so
> @echo 'For makefile target list use make targets'
> @echo 'What follows is cobweb-agar DSO help command'
> @echo
> cobcrun cobweb-agar help

helplist: cobweb-agar.so
> cobcrun cobweb-agar help list

# Create tarball with cobweb-agar as top level name
tarball: cobweb-agar.cob cobweb-agar-repository.cpy gcv.c commands.sed\
 libagar.gcv cobweb-agar.rst gnucobol.css\
 $(wildcard *.jpg) $(wildcard *.png) Makefile
> tar czf cobweb-agar.tar.gz --transform 's#^#cobweb-agar/#' $^

targets:
> @echo "Makefile targets:"
> @echo "  cobweb-agar.so"
> @echo "  libagar.cpy"
> @echo
> @echo "  cobweb-agar.html"
> @echo "  docs, html"
> @echo
> @echo "  template"
> @echo "  tarball"
> @echo
> @echo "  basic"
> @echo "  test"
> @echo "  file"
> @echo
> @echo "  help"
> @echo "  helplist"
> @echo "  targets"
