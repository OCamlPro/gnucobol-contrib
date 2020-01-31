# ifdef __USE_PIPCURSES__
# ifndef __PIPCURSES_H__
# define __PIPCURSES_H__ 1

# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <string.h>
# include <ctype.h>
# include <fcntl.h>
# include <termios.h>
/*****************************************
 *
 * 20180615 | JG | first release
 *
 *
 *****************************************/

# ifndef TRUE
   # define TRUE (0==0)
   # define FALSE (0!=0)
# endif

# define WINDOW int
# define KEY_UP         1265
# define KEY_DOWN       1266
# define KEY_RIGHT      1267
# define KEY_LEFT       1268
# define KEY_DUMMY1     5
// # define KEY_HOME       6
# define KEY_HOME       1272
# define KEY_BACKSPACE  8
# define KEY_STAB       9
# define KEY_ENTER     10
# define KEY_END       14
# define KEY_IC        19
# define KEY_DC        22
# define KEY_ESCAPE    27
# define KEY_F1        1049
# define KEY_F2        1050
# define KEY_F3        1051
# define KEY_F4        1052
# define KEY_F5        1053
# define KEY_F6        1055
# define KEY_F7        1056
# define KEY_F8        1057
# define KEY_F9        1148
# define KEY_F10       1149
# define KEY_F11       1151
# define KEY_F12       1152
# define KEY_PPAGE     1153
# define KEY_NPAGE     1154
# define KEY_SEND      386

# define COLOR_BLACK   0
# define COLOR_RED     1
# define COLOR_GREEN   2
# define COLOR_YELLOW  3
# define COLOR_BLUE    4
# define COLOR_MAGENTA 5
# define COLOR_CYAN    6
# define COLOR_WHITE   7

# define A_BOLD        1
char terminaltype[256]="";

int *stdscr=0;
/* - - - - - - - - - - - - - - - - - - - - */
void move_to(int row, int col);
void print_at(int row, int col, unsigned char *s);
void init_terminal();
/* - - - - - - - - - - - - - - - - - - - - */

int colorfore[32];
int colorback[32];
/******************************************************************************/
int COLOR_PAIR(int nbr)
{
	return(nbr);
}
/******************************************************************************/
void nonl(void)
{
	return;
}
/******************************************************************************/
void refresh(void)
{
	return;
}
/******************************************************************************/
void cbreak(void)
{
	return;
}
/******************************************************************************/
void init_pair(int nbr, int fore, int back)
{
	if(nbr>31) nbr=31;
	if(nbr<0) nbr=0;
	colorfore[nbr]=fore;
	colorback[nbr]=back;
	return;
}
/******************************************************************************/
void start_color(void)
{
	return;
}
/******************************************************************************/
void color_set(int colorpair, int dummy)
{
	printf("%c[%dm", 27, colorfore[colorpair]+30);
	printf("%c[%dm", 27, colorback[colorpair]+40);
	return;
}
/******************************************************************************/
void attron(int colorpair)
{
	printf("%c[%d;1m", 27, colorfore[colorpair]+30);
	printf("%c[%d;1m", 27, colorback[colorpair]+40);
	return;
}
/******************************************************************************/
void raw(void)
{
	return;
}
/******************************************************************************/
void noecho(void)
{
	return;
}
/******************************************************************************/
int has_colors(void)
{
	return(TRUE);
}
/******************************************************************************/
# define getmaxyx(w, y, x) (y=24, x=80)
/**************************
void getmaxyx(int *win, int *y, int *x)
{
	*y=25;
	*x=81;
	return;
}
*******************************/
/******************************************************************************/
void clear(void)
{
	int f;
	int t;

	if(terminaltype[0]==0){
		fprintf(stderr, "pipcurses: Terminal not initialized, aborting..\n");
		exit(1);
	}

	f=0;
	if(strncmp(terminaltype, "xterm", 5)==0){
		printf("%c[2J", 27);
		printf("%c[0m", 27);
		f=1;
	}
	for(t=0; t<24; t++){
		print_at(0, t, "                                                                                ");
	}
	if(strncmp(terminaltype, "xterm", 5)==0){
		printf("%c[2J", 27);
		printf("%c[0m", 27);
	}

	if(f==0){
		fprintf(stderr, "pipcurses: Unknown terminal type >%s<, aborting..\n", 
			terminaltype);
		exit(1);
	}
}
/******************************************************************************/
void cursor_home(void)
{
	int f;

	if(terminaltype[0]==0){
		fprintf(stderr, "pipcurses: Terminal not initialized, aborting..\n");
		exit(1);
	}

	f=0;
	if(strncmp(terminaltype, "xterm", 5)==0){
		printf("%c[H", 27);
		f=1;
	}

	if(f==0){
		fprintf(stderr, "pipcurses: Unknown terminal type >%s<, aborting..\n", 
			terminaltype);
		exit(1);
	}
}
/******************************************************************************/
int set_canon(int flag)
{
	struct termios t;

	tcgetattr(fileno(stdin), &t);
	if(flag==1){
		t.c_lflag |= ICANON;  // enable buffered IO
		t.c_lflag |= ECHO;    // enable echo
	}
	else{
		t.c_lflag &= ICANON;  // disable buffered IO
		t.c_lflag &= ECHO;    // disable echo
	}
	tcsetattr(fileno(stdin), TCSANOW, &t);

	return(1);
}
/******************************************************************************/
void nodelay(int *win, int opt)
{
	return;
}
/******************************************************************************/
void wrefresh(int *win)
{
	return;
}
/******************************************************************************/
void keypad(int *win, int opt)
{
	if(opt==TRUE){
		printf("%c[23B", 27);
	}
	else{
	}
	return;
}
/******************************************************************************/
void delwin(int *nbr)
{
	return;
}
/******************************************************************************/
void endwin(void)
{
	clear();
	cursor_home();
	/******************************************************************
	*******************************************************************/
	// 1b 63 
	printf("%cc", 27);

	// 1b 5d 31 30 34 07  
	printf("%c]104%c", 27, 7);

	// 1b 5b 21 70 
	printf("%c[!p", 27);

	// 1b 5b 3f 33 3b 34 6c 
	printf("%c[?3;4l", 27);

	// 1b 5b 34 6c 
	printf("%c[4l", 27);

	// 1b  3e 0d
	printf("%c>%c", 27, 13);
	set_canon(1);         // switch back to line mode

	system("stty cooked echo"); // cooked input - reset  echo on - reset

	return;
}
/******************************************************************************/
void move(int row, int col)
{
	// move_to(row, col+1); 
	move_to(row+1, col); 
	return;
}
/******************************************************************************/
void wmove(int *scr, int row, int col)
{
	// move_to(row, col);
	move_to(row, col+1);
	return;
}
/******************************************************************************/
void mvaddstr(int row, int col, unsigned char *s)
{
	print_at(row+1, col+1, s);
	return;
}
/******************************************************************************/
char *initscr(void)
{
	int t;
	int f;
	char *ptr;

	ptr=getenv("TERM");

	if(ptr==NULL){
		strcpy(terminaltype, "");
	}
	else{
		strcpy(terminaltype, ptr);
	}

	f=0;
	if(strncmp(terminaltype, "xterm", 5)==0){
		f=1;
	}
	if(f==0){
		fprintf(stderr, "pipcurses: Unknown terminal type >%s<, aborting..\n", 
			terminaltype);
		exit(1);
	}

	for(t=0; t<32; t++){
		colorfore[t]=0;
		colorback[t]=0;
	}

	/***********************************************************
	printf("%cc", 27); // init
	printf("%c[?1049h", 27); // alternate screen
	printf("%c[m", 27); // turn off character attributes
	printf("%c[4l", 27); // reset mode, 4=insert mode
	printf("%c[?7h", 27); // set auto wrap mode
	printf("%c[?1h", 27); // set cursor key to application
	printf("%c=", 27); // set alternate keypad mode
	************************************************************/
	system("stty raw -echo");// raw input - wait for only a single keystroke echo off

	return((char*)1);
}
/******************************************************************************/
/* get a single char from stdin                                               */
int getch(void)
{
	int c;
	// char zwi[256];

	set_canon(0);
	// system("stty raw -echo");// raw input - wait for only a single keystroke echo off

	c=getchar();

	// sprintf(zwi, "pipcurses: c=%d", c);
	// write_to_log(zwi);

	// system("stty cooked echo"); // cooked input - reset  echo on - reset
	set_canon(1);

	// no matter if 13 or 10 was returned, return always KEY_ENTER
	if(c==13 || c==10){
		c=KEY_ENTER;
	}

	// handle CTRL-z and CTRL-c
	/***************************************************************
	if(c==3){
		endwin();
		printf("Program execution interrupted by user (CTRL-c).\n");
		fprintf(stderr, "Program execution interrupted by user (CTRL-c).\n");
		exit(1);
	}
	if(c==26){
		endwin();
		printf("Program execution interrupted by user (CTRL-z).\n");
		fprintf(stderr, "Program execution interrupted by user (CTRL-z).\n");
		exit(2);
	}
	***************************************************/
   return(c);
}
/******************************************************************************/
void print_at(int row, int column, unsigned char *s)
{
	int f;

	if(terminaltype[0]==0){
		fprintf(stderr, "pipcurses: Terminal not initialized, aborting..\n");
		exit(1);
	}

	f=0;
	if(strncmp(terminaltype, "xterm", 5)==0){
		printf("%c[%d;%dH%s", 27, row, column, s);
		f=1;
	}

	if(f==0){
		fprintf(stderr, "pipcurses: Unknown terminal type >%s<, aborting..\n", 
			terminaltype);
		exit(1);
	}
}
/******************************************************************************/
void move_to(int row, int column)
{
	int f;

	if(terminaltype[0]==0){
		fprintf(stderr, "pipcurses: Terminal not initialized, aborting..\n");
		exit(1);
	}

	f=0;
	if(strncmp(terminaltype, "xterm", 5)==0){
		printf("%c[%d;%dH", 27, row, column);
		f=1;
	}

	if(f==0){
		fprintf(stderr, "pipcurses: Unknown terminal type >%s<, aborting..\n", 
			terminaltype);
		exit(1);
	}
}
/******************************************************************************/
/****************************************************************************
int main(int arg, char **argv)
{
	int rc;

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
	return(0);
}
*****************************************************************************/
# endif
# endif
