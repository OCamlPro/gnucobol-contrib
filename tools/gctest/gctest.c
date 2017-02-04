/*
   Copyright (C) 2014-2017,  Free Software Foundation, Inc.
   Written by Ron Norman

   This file is part of GnuCOBOL.

   The GnuCOBOL runtime library is free software: you can redistribute it
   and/or modify it under the terms of the GNU Lesser General Public License
   as published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   GnuCOBOL is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with GnuCOBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
     Program:  gctest.c

     Function: This program is used to drive GNUCobol testing
               and create the autotest data as a byproduct
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h> 
#include <time.h> 
#include <sys/time.h> 
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h>  

extern char *optarg;
extern int optind;

static int incrErr = 0;
static char progexe[100] = " ? $ ";
static char diffProg[32] = "gcdiff";
/*
 * Display program usage information
*/
static void
usage(char *binname)
{
	fprintf(stdout,"GnuCOBOL compile a COBOL program, execute & capture output\n");
	fprintf(stdout,"to create an autotest.at file named from -p programname\n");
	fprintf(stdout," \n");
	fprintf(stdout,"  %s [options]\n",binname);
	fprintf(stdout,"Where [options] are:\n");
	fprintf(stdout,"  -p program      The COBOL program to compile and test\n");
	fprintf(stdout,"  -C mod.c        A C module used by 'program' to compile\n");
	fprintf(stdout,"  -B copybook     Include 'copybook' to autotest file for compile\n");
	fprintf(stdout,"  -i inputfile    Define input file for test program\n");
	fprintf(stdout,"  -o outputfile   Define Output report file\n");
	fprintf(stdout,"  -O LSoutfile    Define LINE SEQUENIAL output file\n");
	fprintf(stdout,"  -b              Make test code start with blank line\n");
	fprintf(stdout,"  -e              test compile only; Expecting errors\n");
	fprintf(stdout,"  -E              compile only; both std=mf & std=2002; Expecting errors\n");
	fprintf(stdout,"  -m              use -std=mf instead of -std=cobol2002\n");
	fprintf(stdout,"  -I              use -std=ibm instead of -std=cobol2002\n");
	fprintf(stdout,"  -w              Compile with no warnings\n");
	fprintf(stdout,"  -c \"compile command\"  \n");
	fprintf(stdout,"  -k \"Test keywords\"  \n");
	fprintf(stdout,"  -s \"Test setup name\"  \n");
	fprintf(stdout," \n");
	fprintf(stdout,"Example command:\n");
	fprintf(stdout," gctest -m -b -k report -s \"Sample REPORT\" -i STUDENT=./student0.inp \\\n");
	fprintf(stdout,"           -o REPORT1=./REPORT0.txt -p rwtst0.bat\n");
	fflush(stdout);
}

/*
 * Split out file name specification
 */
static void
getFileName(
	char	*dd,		/* External name for file */
	char	*file,		/* 'filename' */
	char	*given)		/* 'filename' or EXTERNALNAME=filename */
{
	int	i;
	char	*p;
	if((p=strchr(given,'=')) != NULL) {
		memcpy(dd,given,p-given);
		dd[p-given] = 0;
		strcpy(file,p+1);
	} else {
		dd[0] = 0;
		strcpy(file,given);
	}
	return;
}

/*
 * Copy 'fi' thru to 'fo'
 */
static void
copyFile(FILE *fi, FILE *fo, int addBlank, int rmvseq, int showit, char *oldnm, char *newnm, int incrnum, int tabs)
{
	char	buf[4096], wrk[256], *p;
	int	i,j,k,olen = 0, nlen = 0;
	int	didName = 0;
	int	atBegin = 1;
	int	didProgId = 0;
	int	didEndProg = 0;
	if(fi == NULL)
		return;
	if(ferror(fi))
		return;
	if(feof(fi))
		return;
	memset(buf,0,sizeof(buf));
	if(oldnm) {
		olen = strlen(oldnm);
		nlen = strlen(newnm);
	}
	while(fgets(buf,sizeof(buf),fi) != NULL) {
		for(k=strlen(buf); buf[k-1] == '\r' || buf[k-1] == '\n'; k--);
		buf[k] = 0;
		if(addBlank
		&& atBegin
		&& k < 1) {
			printf("Note: program already starts with a blank line!\n");
			addBlank = 0;
			incrErr = 0;
		}
		if(addBlank
		&& atBegin) {
			fprintf(fo,"\n");
			addBlank = 0;
		}
		for(j=6; buf[j] == ' '; j++);
		if(memcmp(&buf[j],"PROGRAM-ID.",11) == 0
		&& !didProgId) {
			didProgId = 1;
			if(strstr(buf," INITIAL") != NULL) {
				strcpy(&buf[j],"PROGRAM-ID. prog INITIAL.");
			} else {
				strcpy(&buf[j],"PROGRAM-ID. prog.");
			}
		} else if(buf[6] != '*'
			&& !didEndProg
			&& strstr(buf,"END PROGRAM") != NULL) {
			didEndProg = 1;
			strcpy(buf,"           END PROGRAM prog.");
		}
		if(strstr(buf,"SYSTEM") != NULL
		&& (p=strstr(buf,progexe)) != NULL) {
			memcpy(p,"./prog",6);
		}
		if(rmvseq) {
			for(k=0; k < 7; k++) {
				if(isdigit(buf[k]))
					buf[k] = ' ';
			}
		}
		if(showit)
			fprintf(stdout,"%s\n",buf);

		didName = 0;
		if(olen > 0
		&& strlen(buf) < sizeof(wrk)-8) {		/* replace program name */
			for(i=j=0; buf[j] != 0; ) {
				if(memcmp(&buf[j],oldnm,olen) == 0) {
					memcpy(&wrk[i],newnm,nlen);
					didName = 1;
					i += nlen;
					j += olen;
				} else {
					wrk[i++] = buf[j++];
				}
			}
			wrk[i] = 0;
			strcpy(buf,wrk);
		}
		if(incrnum > 0
		&& didName
		&& strlen(buf) < sizeof(wrk)-8) {	/* Increment error line number */
			for(i=j=0; buf[j] != 0; ) {
				if(buf[j] == ':'
				&& buf[j+1] == ' '
				&& isdigit(buf[j+2])) {
					k = atoi(&buf[j+2]);
					for(j=j+2; isdigit(buf[j]); j++);
					i += sprintf(&wrk[i],": %d",k+incrnum);
				} else {
					wrk[i++] = buf[j++];
				}
			}
			wrk[i] = 0;
			strcpy(buf,wrk);
		}

		if(tabs) {
			for(i=j=0; buf[j] != 0; j++) {
				if(buf[j] == '\t') {
					wrk[i++] = ' ';
					while( (i%3) != 0)
						wrk[i++] = ' ';
				} else {
					wrk[i++] = buf[j];
				}
			}
			wrk[i] = 0;
			fprintf(fo,"%s\n",wrk);
		} else {
			fprintf(fo,"%s\n",buf);
		}
		memset(buf,0,sizeof(buf));
		atBegin = 0;
	}
}

/*
 * Build command and replace @f and @F
 */
static char *
makeCommand(
	char	*out,
	char	*cmd,
	char	*progout,
	char	*prog,
	char	*cmod)
{
	int j,k;
	for(j=k=0; cmd[j] != 0; j++) {
		if(memcmp(&cmd[j],"@f",2) == 0) {
			k += sprintf(&out[k],"%s",progout);
			j++;
		} else if(memcmp(&cmd[j],"@F",2) == 0) {
			k += sprintf(&out[k],"%s",prog);
			j++;
		} else if(memcmp(&cmd[j],"@c",2) == 0) {
			if(cmod[0] > ' ')
				k += sprintf(&out[k],"%s",cmod);
			j++;
		} else {
			out[k++] = cmd[j];
		}
	}
	out[k] = 0;
	for(j=k=0; out[j] != 0; j++) {		/* Remove multiple spaces */
		if(out[j] == ' ')
			while(out[j+1] == ' ')
				j++;
		out[k++] = out[j];
	}
	out[k] = 0;
	return out;
}

/*
 * Read thru file, sniff for directives
 */

static void
snifFile(FILE *fi, int *fixedFormat, 
	int look4summary, char *testsummary,
	int look4keyword, char *testkeyword)
{
	char	buf[1024],upr[1024],*p;
	int	i,k;
	if(fi == NULL)
		return;
	if(ferror(fi))
		return;
	if(feof(fi))
		return;
	while(fgets(buf,sizeof(buf),fi) != NULL) {
		for(k=strlen(buf); buf[k-1] == '\r' || buf[k-1] == '\n' || buf[k] == ' '; k--);
		buf[k] = 0;
		for(i=0; i < k; i++)
			upr[i] = toupper(buf[i]);
		upr[i] = 0;
		if(strstr(upr,">>") != NULL
		&& strstr(upr,"SOURCE") != NULL 
		&& strstr(upr,"FORMAT") != NULL ) {
			if( strstr(upr,"FREE") != NULL )
				*fixedFormat = 0;
			if( strstr(upr,"FIXED") != NULL )
				*fixedFormat = 1;
		}
		if(look4summary) {
			if((p = strstr(buf,"SUMMARY:")) != NULL) {
				p = p + 8;
				while(*p == ' ') p++;
				strcpy(testsummary,p);
				look4summary = 0;
			}
		}
		if(look4keyword) {
			if((p = strstr(buf,"KEYWORD:")) != NULL) {
				p = p + 8;
				while(*p == ' ') p++;
				strcpy(testkeyword,p);
				look4keyword = 0;
			}
		}
	}
	fclose(fi);
}

#define dMaxFile 12
/*
 * M A I N L I N E   Starts here
 */
int
main(
	int		argc,
	char	*argv[])
{
	int		opt,i,j,k,compsts,runsts;
	int		getSummary = 1;
	int		getKeyword = 1;
	int		fixedFormat = 1;
	int		bCompileOnly = 0;
	int		bCompile = 1;
	int		bWall = 1;
	int		bStdMf = 0;
	int		bStdIBM = 0;
	int		bStd2002 = 1;
	int		preln;
	char	inpdd[48],outdd[48],*p,setdd[48],settestfile[200];
	char	tmp[300],wrk[200],prog[100],progout[200],cmod[80];
	char	setup[200],keywords[200],callfh[48];
	char	inptestfile[200],outtestfile[200],compilecmd[256];
	char	outlst[80],errlst[80],compprefx[64];
	char	libs[256],flags[128];
	char	outFiles[dMaxFile][80];
	char	ddFiles[dMaxFile][80];
	char	bookFiles[dMaxFile][80];
	FILE	*at,*fi;
	int		addBlank = 0, numFiles = 0, numBooks = 0;

	strcpy(setup,"SAMPLE PROGRAM");
	strcpy(keywords,"report");
	strcpy(outlst,"./stdout.lst");
	strcpy(errlst,"./stderr.lst");
	strcpy(inpdd,"INPUT");
	strcpy(outdd,"OUTPUT");
	memset(inptestfile,0,sizeof(inptestfile));
	memset(outtestfile,0,sizeof(outtestfile));
	memset(prog,0,sizeof(prog));
	memset(progexe,0,sizeof(progexe));
	memset(cmod,0,sizeof(cmod));
	memset(callfh,0,sizeof(callfh));
	memset(libs,0,sizeof(libs));
	memset(flags,0,sizeof(flags));
	putenv("SHELL=/bin/sh");
	while ((opt=getopt(argc, argv, "i:o:O:c:d:hp:C:B:s:k:x:eEbImwL:l:f:")) != EOF) {
		switch(opt) {
		case 'm':
			bStdMf = 1;
			bStdIBM = 0;
			bStd2002 = 0;
			bCompile = 0;
			break;
		case 'I':
			bStdMf = 0;
			bStdIBM = 1;
			bStd2002 = 0;
			bCompile = 0;
			break;
		case 'w':
			bWall = 0;	/* No warnings */
			bCompile = 0;
			break;
		case 'e':		/* COMPILE only as errors expected */
			bCompileOnly = 1;
			break;
		case 'E':		/* COMPILE only as errors expected */
			bCompileOnly = 1;
			bStdMf = 1;
			bStd2002 = 1;
			break;
		case 'i':
			getFileName(inpdd,inptestfile,optarg);
			break;
		case 'o':
			getFileName(outdd,outtestfile,optarg);
			break;
		case 'O':
			if(numFiles < dMaxFile) {
				getFileName(setdd,settestfile,optarg);
				strcpy(outFiles[numFiles],settestfile);
				strcpy(ddFiles[numFiles],setdd);
				if(setdd[0] > ' ') {
					sprintf(wrk,"%s=%s",setdd,settestfile);
					putenv(strdup(wrk));
					unlink(settestfile);
				} else {
					unlink(optarg);
				}
				numFiles++;
			}
			break;
		case 'c':
			strcpy(compilecmd,optarg);
			break;
		case 'd':
			strcpy(diffProg,optarg);
			break;
		case 's':
			strcpy(setup,optarg);
			getSummary = 0;
			break;
		case 'x':
			strcpy(callfh,optarg);
			break;
		case 'k':
			strcpy(keywords,optarg);
			getKeyword = 0;
			break;
		case 'p':
			strcpy(prog,optarg);
			strcpy(progexe,optarg);
			if((p=strchr(progexe,'.')) != NULL) 
				*p = 0;
			break;
		case 'C':
			strcpy(cmod,optarg);
			break;
		case 'B':
			if(numBooks < dMaxFile)
				strcpy(bookFiles[numBooks++],optarg);
			break;
		case 'b':
			addBlank = incrErr = 1;
			break;
		case 'L':
			sprintf(&libs[strlen(libs)]," -L%s",optarg);
			break;
		case 'l':
			sprintf(&libs[strlen(libs)]," -l%s",optarg);
			break;
		case 'f':
			sprintf(&flags[strlen(flags)]," -f%s",optarg);
			break;
		default:
			printf("Unknown option '%c' \n",opt);
		case 'h':
			usage(argv[0]);
			exit(0);
			break;
		}
	}
	if(bStdIBM)
		sprintf(compprefx,"cobc -x -std=ibm");
	else if(bStdMf)
		sprintf(compprefx,"cobc -x -std=mf");
	else
		sprintf(compprefx,"cobc -x -std=cobol2002");
	if(bWall)
		strcat(compprefx," -debug -Wall");
	else
		strcat(compprefx," -w");
	if(callfh[0] > ' ')
		sprintf(&compprefx[strlen(compprefx)]," -use-extfh=%s",callfh);
	preln = strlen(compprefx);
	sprintf(compilecmd,"%s%s%s -o @f @F @c",compprefx,libs,flags);	/* Collect warnings */
	if(prog[0] <= ' '
	&& optind < argc) {
		strcpy(prog,argv[optind]);
	}
	if(prog[0] <= ' ') {
		printf("Missing program name to test;\n");
		usage(argv[0]);
		exit(0);
	}
	strcpy(progout,prog);
	if((p=strrchr(progout,'.') ) != NULL)
		*p = 0;
	sprintf(tmp,"./%s",progout);
	unlink(tmp);
	fi = fopen(prog,"r");
	if(fi == NULL) {
		perror(prog);
		exit(-1);
	}
	snifFile(fi,&fixedFormat,getSummary,setup,getKeyword,keywords);
	fi = NULL;
	sprintf(tmp,"%s.at",progout);
	at = fopen(tmp,"w");
	if(at == NULL) {
		perror(tmp);
		exit(-1);
	}
	fprintf(at,"\n");
	fprintf(at,"AT_SETUP([%s])\n",setup);
	fprintf(at,"AT_KEYWORDS([%s])\n",keywords);
	fprintf(at,"\n");

	if(inptestfile[0] > ' ') {
		sprintf(tmp,"DD_%s=%s",inpdd,inptestfile);
		putenv(strdup(tmp));
	}
	if(outtestfile[0] > ' ') {
		sprintf(tmp,"DD_%s=%s",outdd,outtestfile);
		putenv(strdup(tmp));
	}
	makeCommand(tmp,compilecmd,progout,prog,cmod);
	unlink(outlst); unlink(errlst);
	sprintf(&tmp[strlen(tmp)]," 1>%s 2>%s",outlst,errlst);
	compsts = system(tmp);
	if(compsts != 0)
		printf("Compile of %s failed!\n",prog);
	if(inptestfile[0] > ' '
	&& compsts == 0) {
		fi = fopen(inptestfile,"r");
		if(fi == NULL) {
			perror(inptestfile);
			exit(-1);
		}
		fprintf(at,"AT_DATA([inp_data],[");
		copyFile(fi,at,0,0,0,NULL,NULL,0,0);
		fclose(fi);
		fi = NULL;
		fprintf(at,"])\n\n");
	}

	for(i=0; i < numBooks; i++) {
		fprintf(at,"\n");
		fprintf(at,"AT_DATA([./%s], [",bookFiles[i]);
		fi = fopen(bookFiles[i],"r");
		if(fi) {
			copyFile(fi,at,0,0,0,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
		}
		fprintf(at,"])\n\n");
	}

	fi = fopen(prog,"r");
	if(fi == NULL) {
		perror(prog);
		exit(-1);
	}
	fprintf(at,"AT_DATA([prog.cob], [");
	copyFile(fi,at,addBlank,fixedFormat,0,NULL,NULL,0,0);
	fclose(fi);
	fi = NULL;
	fprintf(at,"])\n\n");

	if(cmod[0] > ' ') {
		fi = fopen(cmod,"r");
		if(fi == NULL) {
			perror(cmod);
			exit(-1);
		}
		fprintf(at,"AT_DATA([cmod.c], [[");
		copyFile(fi,at,addBlank,0,0,NULL,NULL,0,1);
		fclose(fi);
		fi = NULL;
		fprintf(at,"]])\n\n");
	}

ReDoCompile:
	if(!bCompile) {
		strcpy(wrk,compilecmd);
	} else
	if(memcmp(compilecmd,compprefx,preln) == 0) {
		sprintf(wrk,"$COMPILE %s%s",bStdMf?"-std=mf ":"",&compilecmd[preln]);
		if(bCompileOnly)
			sprintf(wrk,"$COMPILE_ONLY %s%s",bStdMf?"-std=mf ":"",&compilecmd[preln]);
	} else if(memcmp(compilecmd,"cobc -x",7) == 0) {
		sprintf(wrk,"$COMPILE %s%s",bStdMf?"-std=mf ":"",&compilecmd[7]);
		if(bCompileOnly)
			sprintf(wrk,"$COMPILE_ONLY %s%s",bStdMf?"-std=mf ":"",&compilecmd[7]);
	} else {
		strcpy(wrk,compilecmd);
	}
	makeCommand(tmp,wrk,"prog","prog.cob",cmod[0]>' '?"cmod.c":"");
	if((p=strstr(tmp,"-o prog ")) != NULL) {
		memmove(p,p+8,48);
	}
	fprintf(at,"AT_CHECK([%s], [%d], [],",tmp,WEXITSTATUS(compsts));
	if(bCompileOnly)
		fprintf(at,"\n[");
	else
		fprintf(at," [");
	fi = fopen(errlst,"r");
	if(fi) {
		copyFile(fi,at,0,0,1,prog,"prog.cob",incrErr,0);
		fclose(fi);
		fi = NULL;
	}
	fprintf(at,"])\n\n");
	if(bCompileOnly
	&& bStdMf
	&& bStd2002) {
		bStdMf = 0;
		sprintf(compprefx,"cobc -x -std=cobol2002");
		if(bWall)
			strcat(compprefx," -debug -Wall");
		else
			strcat(compprefx," -w");
		preln = strlen(compprefx);
		sprintf(compilecmd,"%s -o @f @F @c",compprefx);	/* Collect warnings */
		makeCommand(tmp,compilecmd,progout,prog,cmod);
		unlink(outlst); unlink(errlst);
		sprintf(&tmp[strlen(tmp)]," 1>%s 2>%s",outlst,errlst);
		compsts = system(tmp);
		if(compsts != 0)
			printf("Second Compile of %s failed!\n",prog);
		goto ReDoCompile;
	}
	if(compsts == 0 && !bCompileOnly) {
		sprintf(tmp,"./%s 1>%s 2>%s",progout,outlst,errlst);
		runsts = system(tmp);
		if(runsts != 0) {
#if defined(WCOREDUMP)
			printf("Execution of %s failed! Status: %d; exit %d; Core %d\n",prog,runsts,
						WIFEXITED(runsts),WEXITSTATUS(runsts),WCOREDUMP(runsts));
#else
			printf("Execution of %s failed! Status: %d; exit %d\n",prog,runsts,
						WIFEXITED(runsts),WEXITSTATUS(runsts));
#endif
		}
		fprintf(at,"AT_CHECK([");
		if(inptestfile[0] > ' ') {
			fprintf(at,"export DD_%s=%s\n",inpdd,"./inp_data");
		}
		if(outtestfile[0] > ' ') {
			fprintf(at,"export DD_%s=%s\n",outdd,"./report.txt");
		}
		for(i=0; i < numFiles; i++) {
			if (ddFiles[i][0] > ' ') {
				fprintf(at,"export %s=%s\n",ddFiles[i],outFiles[i]);
			}
		}
		fprintf(at,"./prog], [%d], ",WEXITSTATUS(runsts));
		fi = fopen(outlst,"r");
		if(fi) {
			fprintf(at,"[");
			copyFile(fi,at,0,0,1,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
			fprintf(at,"]");
		}
		fi = fopen(errlst,"r");
		if(fi) {
			fprintf(at,", [");
			copyFile(fi,at,0,0,1,prog,"prog.cob",incrErr,0);
			fclose(fi);
			fi = NULL;
			fprintf(at,"]");
		}
		fprintf(at,")\n\n");
		if(outtestfile[0] > ' ') {
			fprintf(at,"\n");
			fprintf(at,"AT_CAPTURE_FILE(%s)\n\n","./report.txt");
			fprintf(at,"AT_DATA([reference], [");
			fi = fopen(outtestfile,"r");
			if(fi) {
				copyFile(fi,at,0,0,0,NULL,NULL,0,0);
				fclose(fi);
				fi = NULL;
			}
			fprintf(at,"])\n\n");
			fprintf(at,"AT_CHECK([%s reference report.txt], [0])\n\n",diffProg);
		}
		for(i=0; i < numFiles; i++) {
			fprintf(at,"\n");
			fprintf(at,"AT_CAPTURE_FILE(./%s)\n\n",outFiles[i]);
			fprintf(at,"AT_DATA([reference], [");
			fi = fopen(outFiles[i],"r");
			if(fi) {
				copyFile(fi,at,0,0,0,NULL,NULL,0,0);
				fclose(fi);
				fi = NULL;
			}
			fprintf(at,"])\n\n");
			fprintf(at,"AT_CHECK([%s reference %s], [0], [], [])\n\n",diffProg,outFiles[i]);
		}
	}
	fprintf(at,"AT_CLEANUP\n\n");
	fclose(at);
	unlink(outlst); unlink(errlst);
	sprintf(tmp,"./%s",progout);
	unlink(tmp);
	exit(0);
	return 0;
}

