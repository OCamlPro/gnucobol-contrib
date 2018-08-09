/*
  Author: Brian Tiffin
  Dedicated to the public domain

  Date started: August 2018
  Modified: 2018-08-09/17:42-0400 btiffin

  Tectonics:
    gcc [-D AGAR] -o gcv gcv.c
    export CFLAGS
    ./gcv expression includefiles spec

*/

/* gcv, Get C Value, given an expression, include files and spec */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char** argv)
{

    int rc;
    int i;
    FILE *tmpfile;
    char leader;
    char opt;
    char *datatype;  /* the printf spec (without percent) for output handling */

    if (argc > 1 && (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help"))) {
        printf("Usage: gcv 'expression' [includes...] [-V|-C|-E|-'spec']\n");
        printf("  compile a C fragment and print the value given a printf spec\n");
        printf("  include as many headers as it takes to resolves symbols\n");
        printf("  last argument can be -V, -C, -E, or -spec or %%c-of-spec\n");
        printf("\n");
        printf("  -v, --version and -h, --help also supported\n");
        printf("\n");
        printf("  Relies on exported CFLAGS to manage include file search path\n");
        return 0;
    }
    if (argc > 1 && (!strcmp(argv[1], "-v") || !strcmp(argv[1], "--version"))) {
        printf("gcv version 0.3 Aug 2018\n");
        return 0;
    }
    /* Remain silent on no args as this is paired with commands.sed for substitution */
    if (argc < 2) return 0;

    /* if not help or style, then treat last option as the printf spec, default %d */
    leader = argv[argc-1][0];
    opt = argv[argc-1][1];
    datatype = "%d";
    if (leader == '-'&& (opt != 'V' && opt != 'C' && opt != 'E')) { datatype = &argv[argc-1][1]; }
    if (leader == '%') { datatype = &argv[argc-1][0]; }

    /* create a small C program */
    tmpfile = fopen("gcv.tmp.c", "w");
    if (tmpfile) {

        /* transform underscores in names to dashes */
        char *underdash = strdup(argv[1]);
        for (char* current_pos = underdash; (current_pos = strchr(underdash, '_')) != NULL; *current_pos = '-');

        /* extra arguments are include files to load to get at symbols */
        for (i = 2; i < argc; i++) {
            if (argv[i] && strcmp(argv[i], "stdio.h") &&
                strcmp(argv[i], "stddef.h") &&
#ifdef AGAR
                strcmp(argv[i], "agar/core.h") &&
                strcmp(argv[i], "agar/gui.h") &&
#endif
                argv[i][0] != '-' && argv[i][0] != '%') {
                fprintf(tmpfile, "%s%s%s", "#include \"", argv[i], "\"\n");
            }
        }
        fprintf(tmpfile, "%s", "#include <stdio.h>\n");
        fprintf(tmpfile, "%s", "#include <stddef.h>\n");
#ifdef AGAR
        fprintf(tmpfile, "%s", "#include \"agar/core.h\"\n");
        fprintf(tmpfile, "%s", "#include \"agar/gui.h\"\n\n");
#endif
        fprintf(tmpfile, "%s", "int main(int argc, char** argv) {\n");

        if (leader == '-' && opt == 'C') {
            fprintf(tmpfile, "    %s%s%s%s%s", "printf(\"01 %s%d%s\", \"", underdash, " constant as \", (int)(", argv[1], "), \".\\n\");\n");
        } else if (leader == '-' && opt == 'V') {
            fprintf(tmpfile, "    %s%s%s%s%s", "printf(\"   05 %s%d%s\", \"", underdash, " usage binary-long value \", (int)(", argv[1], "), \".\\n\");\n");
        } else {
            fprintf(tmpfile, "    %s%s%s%s%s", "printf(\"", datatype, "\", ", argv[1], ");\n");
        }
        fprintf(tmpfile, "%s", "}\n");

        free(underdash);
    }

    rc = fclose(tmpfile);
    if (!rc) {
        if (leader == '-' && opt == 'E') {
            rc = system("cat gcv.tmp.c");
            rc = system("echo gcc \"$CFLAGS\" -o gcv.tmp gcv.tmp.c");
            rc = system("gcc $CFLAGS -o gcv.tmp gcv.tmp.c");
        } else {
            rc = system("gcc -w $CFLAGS -o gcv.tmp gcv.tmp.c");
        }
        if (!rc) {
            rc = system("./gcv.tmp");
        }
    }

    /* only leave generated sources around with -E echo */
    if (leader != '-' || opt != 'E') {
        rc = unlink("./gcv.tmp.c");
    }
    rc = unlink("./gcv.tmp");
    return rc;
}
