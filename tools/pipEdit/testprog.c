/******************************************************************************
    testprog.c test program for pipcurses
 ******************************************************************************/

# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <unistd.h>    
# include <ctype.h>
# include <time.h>
# include <ctype.h>
# include "pipcurses.c"

#ifndef TRUE
	#define TRUE (0==0)
	#define FALSE (0!=0)
#endif


int main(int arg, char **argv)
{
   int rc;

	initscr();

   init_terminal();

   set_foreground_white();
   set_background_blue();
   clear_screen();
   print_at(10, 10, "Hello world!");

   print_at(24, 30, "* Hit any key to continue *");
   rc=getch();

   set_background_black();
   clear_screen();
   print_at(8, 30, "*** the 2nd screen ***");
   print_at(24, 30, "* Hit any key to terminate *");
   rc=getch();
   end_program();
   puts("Done.");

	endwin();

	return (0);
}
