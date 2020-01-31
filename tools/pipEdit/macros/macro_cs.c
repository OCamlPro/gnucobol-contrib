# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <unistd.h>
# include <ctype.h>

char *linetab[128000];
int linecnt=0;

char config_file[256];

/******************************************************************************/
void ucase(char *s)
{
	int t;
	int c;

	for(t=0;;t++){
		c=s[t];
		if(c==0) break;
		s[t]=toupper(c);
	}
}
/******************************************************************************/
void rtrim(char *s)
{
	for(;;){
		if(s[strlen(s)-1]!=' ') break;
		s[strlen(s)-1]=0;
	}
}
/******************************************************************************/
void trim(char *s)
{
	for(;;){
		if(s[strlen(s)-1]!=' ') break;
		s[strlen(s)-1]=0;
	}
	for(;;){
		if(s[0]==0) break;
		if(s[0]!=' ' && s[0]!='\t'){
			break;
		}
		strcpy(s, s+1);
	}
}
/******************************************************************************/
int read_one_line(FILE *fp, char *line)
{
	int t;
	int c;

	for(t=0; t<512; t++){
		c=fgetc(fp);
		if(c==EOF || c=='\r' || c=='\n') break;
		line[t]=c;
	}
	line[t]=0;

	return(c);
}
/******************************************************************************/
void get_config_entry(char *pentry, char *value)
{
	FILE *fp;
	int rc;
	char line[256];
	char entry[256];

	strcpy(value, "");
	fp=fopen(config_file, "rb");
	if(fp==NULL) return;

	sprintf(entry, "%s=", pentry);

	for(;;){
		rc=read_one_line(fp, line);
		if(rc==EOF) break;
		if(strncmp(line, entry, strlen(entry))==0){
			strcpy(value, line+strlen(entry));
			break;
		}
	}
}
/******************************************************************************/
int do_replace(char *s, char *old, char *new)
{
   int t;
   int i;
   int f;
   char zwi[4096];

   if(strcmp(old, new)==0){
      return(0);
   }
   for(t=0;t<(strlen(s)-strlen(old)+1);t++){
      f=1;
      for(i=0; i<strlen(old); i++){
         if(s[t+i]!=old[i]){
            f=0;
            break;
         }
      }
      if(f==1){ // found!!!!
      	strcpy(zwi, s);
      	zwi[t]=0;
      	strcat(zwi, new);
      	strcat(zwi, s+t+strlen(old));
      	strcpy(s, zwi);
      	return(1);
   	}
 	}
	return(0);
}
/******************************************************************************/
int main(int argc, char **argv)
{
	char filename[256];
	char orifilename[256];
	char parfile[256];
	char line[1024];
	char line2[1024];
	char zwi[1024];
	char set_msg[256];
	char set_message[256];
	FILE *fp;
	int t, i;
	int start, end, tmp, after, before;
	int modified=0;

	strcpy(filename, argv[1]);
	// printf("argc=%d\n", argc);
	if(argc<3){
		printf("parfile is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(parfile, argv[2]);
	if(argc<4){
		printf("orignal file name is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(orifilename, argv[3]);
	if(argc<5){
		printf("config file name is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(config_file, argv[4]);


	fprintf(stderr, "config_file=>%s<\n", config_file);
	// fprintf(stderr, "orifilename=>%s<\n", orifilename);

	// printf("comp: reading file from >%s<\n", filename);
	fp=fopen(filename, "rb");
	if(fp==NULL){
		exit(99);
	}

   read_one_line(fp, line); // skip msg
   read_one_line(fp, line); // skip message
   read_one_line(fp, line); // skip cursor_x
   read_one_line(fp, line); // skip cursor_y
   read_one_line(fp, line); // skip modified

	for(t=0;;){
		if(read_one_line(fp, line)==EOF) break;
		if(line[6]!='M'){
			linetab[t]=malloc(strlen(line)+1);
			strcpy(linetab[t], line);
			t++;
		}
	}
	linecnt=t;
	fclose(fp);

	start=-1;
	end=-1;
	after=-1;
	before=-1;
	for(t=0; t<linecnt; t++){
		strncpy(zwi, linetab[t]+7, 6);
		zwi[7]=0;
		trim(zwi);
		ucase(zwi);
		if(strcmp(zwi, ".A")==0){
			start=t;
			for(i=7; i<14; i++){
				linetab[t][i]=' ';
			}
		}
		if(strcmp(zwi, ".B")==0){
			end=t;
			for(i=7; i<14; i++){
				linetab[t][i]=' ';
			}
		}
		if(strcmp(zwi, "A")==0){
			after=t;
			for(i=7; i<14; i++){
				linetab[t][i]=' ';
			}
		}
		if(strcmp(zwi, "B")==0){
			before=t;
			for(i=7; i<14; i++){
				linetab[t][i]=' ';
			}
		}
		fprintf(stderr,">%s<\n", zwi);
	}
	if(start==-1 && end==-1 && after==-1 && before==-1){
		fp=fopen(filename, "wb");
   	fprintf(fp, "msg=Nothing done\n");
   	fprintf(fp, "message=Nothing to do, no .a and .b  or a and b found!\n");
   	fprintf(fp, "cursor_x=14\n");
   	fprintf(fp, "cursor_y=3\n");
   	fprintf(fp, "modified=0\n");
		for(t=0; t<linecnt; t++){
			fprintf(fp, "%s\n", linetab[t]);
		}
		fclose(fp);
		return(0);
	}
	if(start>end){
		tmp=end;
		end=start;
		start=tmp;
	}
	if(start>-1 && end>-1){
		sprintf(zwi, "/tmp/%s.scratch", getenv("USER"));
		fp=fopen(zwi, "wb");
		for(t=start; t<=end; t++){
			fprintf(fp, "%s\n", linetab[t]+7+6);
		}
		fclose(fp);
		strcpy(set_msg, "Copied");
		strcpy(set_message, "Block copied to scratch file");
	}
	if(after>-1){
		sprintf(zwi, "/tmp/%s.scratch", getenv("USER"));
		fp=fopen(zwi, "rb");
		if(fp==NULL){
			strcpy(set_msg, "No scratch file");
			strcpy(set_message, "No scratch file found, nothing inserted");
			fclose(fp);
		}
		else{
			after++;
			for(;;){
				if(read_one_line(fp, line)==EOF) break;
				for(t=linecnt; t>after; t--){
					linetab[t]=linetab[t-1];
				}
				sprintf(line2, "             %s", line);
				linetab[after]=malloc(strlen(line2)+1);
				strcpy(linetab[after], line2);
				after++;
			}
			fclose(fp);
			strcpy(set_msg, "Block inserted");
			strcpy(set_message, "Scratch file inserted after target line");
			modified=1;
		}
	}
	fprintf(stderr, "macro_cs: scratchfile=>%s<\n", zwi);
	fprintf(stderr, "macro_cs: start=%d end=%d\n", start, end);
	fprintf(stderr, "macro_cs: end of loop, linecnt=%d\n", linecnt);
	fprintf(stderr, "macro_cs: modified=%d\n", modified);
	// return(0);
	// ####################################################################
	fp=fopen(filename, "wb");
   fprintf(fp, "msg=%s\n", set_msg);
   fprintf(fp, "message=%s\n", set_message);
   fprintf(fp, "cursor_x=14\n");
   fprintf(fp, "cursor_y=3\n");
   fprintf(fp, "modified=%d\n", modified);
	for(t=0; t<linecnt; t++){
		fprintf(fp, "%s\n", linetab[t]);
	}
	fclose(fp);
	// fprintf(stderr, "macro: end of loop, linecnt=%d\n", linecnt);

	return(0);
}

