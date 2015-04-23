/*
 *  Copyright (C) 2009 Cedric ISSALY
 *
 *	This file is part of OCSort.
 *
 *  OCSort is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  OCSort is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with OCSort.  If not, see <http://www.gnu.org/licenses/>.

*/



#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include "ocsort.h"
#include "job.h"
#include "file.h"
#include "sortfield.h"
#include "condfield.h"
#include "outrec.h"
#include "parser.h"
#include "scanner.h"
#include "utils.h"

int yyparse ();
int job_compare(const void *first, const void *second);

struct job_t {

	struct file_t *outputFile;
	struct file_t *inputFile;

	struct sortField_t *sortField;
	struct condField_t *includeCondField;
	struct condField_t *omitCondField;
	struct outrec_t *outrec;
	int sumFields;

	int recordNumber;
	int recordNumberAllocated;
	char *recordData;

	int inputLength;
	int outputLength;

};

struct job_t *globalJob;

int job_setOutputFile(struct file_t *file) {
	globalJob->outputFile=file;
	return 0;
}
int job_addInputFile(struct file_t *file) {
	file_addQueue(&globalJob->inputFile,file);
	return 0;
}
int job_addSortField(struct sortField_t *sortField) {
	sortField_addQueue(&(globalJob->sortField), sortField);
	return 0;
}
int job_setSortField(struct sortField_t *sortField) {
	globalJob->sortField=sortField;
	return 0;
}
int job_setIncludeCondField(struct condField_t *condField) {
	globalJob->includeCondField=condField;
	return 0;
}
int job_setOmitCondField(struct condField_t *condField) {
	globalJob->omitCondField=condField;
	return 0;
}
int job_setSumFields() {
	globalJob->sumFields=1;
	return 0;
}
int job_addOutrec(struct outrec_t *outrec) {
	outrec_addQueue(&(globalJob->outrec),outrec);
	return 0;
}




struct job_t *job_constructor() {
	struct job_t *job=(struct job_t *)malloc(sizeof(struct job_t));
	job->outputFile=NULL;
	job->inputFile=NULL;
	job->sortField=NULL;
	job->includeCondField=NULL;
	job->omitCondField=NULL;
	job->outrec=NULL;
	job->sumFields=0;

	job->recordNumber=0;
	job->recordNumberAllocated=0;

	job->recordData=NULL;

	job->inputLength=0;
	job->outputLength=0;
	return job;
}
void job_destructor(struct job_t *job) {
	free(job);
}


int job_load(struct job_t *job, int argc, char **argv) {
	int i;
	int bufferLength=0;
	int argvLength;
	char *buffer=NULL;
	int returnCode;
	globalJob=job;
	for (i=1;i<argc;i++) {
		if (argv[i]!=NULL) {
			argvLength=strlen(argv[i])+1;
			buffer=(char *)realloc(buffer,bufferLength+argvLength+1);
			buffer[bufferLength]=' ';
			strcpy(buffer+bufferLength+1,argv[i]);
			bufferLength+=argvLength;
		}
	}
	if (buffer==NULL) {
		fprintf(stderr,"No parameter\n");
		return -1;
	}
	yy_scan_string(buffer);
	returnCode=yyparse();
	free(buffer);
	return returnCode;
}
int job_check(struct job_t *job) {
	struct file_t *file;
	if (job->includeCondField!=NULL && job->omitCondField!=NULL) {
		fprintf(stderr,"INCLUDE COND and OMIT are mutually exclusive\n");
		return -1;
	}
	if (job->inputFile==NULL) {
		fprintf(stderr,"No input file specified\n");
		return -1;
	}
	if (job->outputFile==NULL) {
		fprintf(stderr,"No output file specified\n");
		return -1;
	}

	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		if (job->inputLength<file_getMaxLength(file)) {
			job->inputLength=file_getMaxLength(file);
		}
	}

	if (job->outrec!=NULL) {
		job->outputLength=outrec_getLength(job->outrec);
		if (job->outputLength != file_getMaxLength(job->outputFile) && file_getMaxLength(job->outputFile)!=0) {
			fprintf(stderr,"Outrec clause define a file with a different length than give record clause\n");
			return -1;
		}
	} else {
		job->outputLength=file_getMaxLength(job->outputFile);
		if (job->outputLength==0) {
			job->outputLength=job->inputLength;
		}
	}
	return 0;
}
int job_print(struct job_t *job) {
	struct file_t *file;
	struct sortField_t *sortField;
	struct outrec_t *outrec;
	if (job->inputFile!=NULL) {
		printf("INPUT FILE :\n");
		for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
			printf("\t");
			file_print(file);
		}
	}
	if (job->outputFile!=NULL) {
		printf("OUTPUT FILE :\n");
		printf("\t");
		file_print(job->outputFile);
	}
	if (job->sortField!=NULL) {
		printf("SORT FIELDS : (");
		for (sortField=job->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
			if (sortField!=job->sortField) {
				printf(",");
			}
			sortField_print(sortField);

		}
		printf(")\n");
	}
	if (job->includeCondField!=NULL) {
		printf("INCLUDE COND : (");
		condField_print(job->includeCondField);
		printf(")\n");
	}
	if (job->omitCondField!=NULL) {
		printf("OMIT COND : (");
		condField_print(job->omitCondField);
		printf(")\n");
	}
	if (job->outrec!=NULL) {
		printf("OUTREC FIELDS : (");
		for (outrec=job->outrec; outrec!=NULL; outrec=outrec_getNext(outrec)) {
			if (outrec!=job->outrec) {
				printf(",");
			}
			outrec_print(outrec);

		}
		printf(")\n");
	}

	if (job->sumFields==1) {
		printf("SUM FIELDS = NONE\n");
	}

	return 0;
}


int job_loadFiles(struct job_t *job) {
	int desc;
	struct file_t *file;
	int byteRead;

	int useRecord;

	job->recordNumber=0;
	job->recordNumberAllocated=OCSORT_ALLOCATE;



	job->recordData=(char *)malloc(job->recordNumberAllocated*job->inputLength);

	for (file=job->inputFile; file!=NULL; file=file_getNext(file)) {
		if ((desc=open(file_getName(file),O_RDONLY))<0) {
			fprintf(stderr,"Cannot open file %s : %s\n",file_getName(file),strerror(errno));
			return -1;
		}
		while ((byteRead=read(desc,job->recordData+job->recordNumber*job->inputLength,file_getRecordLength(file)))==file_getMaxLength(file)) {
			useRecord=1;
			if (useRecord==1 && job->includeCondField!=NULL && condField_test(job->includeCondField,job->recordData+job->recordNumber*job->inputLength)==0) {
				useRecord=0;
			}
			if (useRecord==1 && job->omitCondField!=NULL && condField_test(job->omitCondField,job->recordData+job->recordNumber*job->inputLength)==1) {
				useRecord=0;
			}

			if (useRecord==1) {
				job->recordNumber++;
				if (job->recordNumber==job->recordNumberAllocated) {
					job->recordNumberAllocated+=OCSORT_ALLOCATE;
					job->recordData=realloc(job->recordData,job->recordNumberAllocated*job->inputLength);
				}
			}
		}
		if (byteRead==0) {
			// End of file
			if ((close(desc))<0) {
				fprintf(stderr,"Cannot close file %s : %s\n",file_getName(file),strerror(errno));
				return -1;
			}
		} else if (byteRead==-1) {
			fprintf(stderr,"Cannot read file %s : %s\n",file_getName(file),strerror(errno));
			if ((close(desc))<0) {
				fprintf(stderr,"Cannot close file %s : %s\n",file_getName(file),strerror(errno));
			}
			return -1;
		} else {
			fprintf(stderr,"Wrong record length in file %s\n",file_getName(file));
			if ((close(desc))<0) {
				fprintf(stderr,"Cannot close file %s : %s\n",file_getName(file),strerror(errno));
			}
			return -1;
		}

	}
	return 0;
}

int job_sort(struct job_t *job) {
	globalJob=job;
	if (job->sortField!=NULL) {
		qsort(job->recordData,job->recordNumber,job->inputLength,job_compare);
	}
	return 0;
}
int job_save(struct job_t *job) {
	int desc;
	int i;
	int previousRecord=-1;
	int useRecord;
	char *recordBuffer;
	int recordBufferLength;
	int recordCopyLength;


	recordBufferLength=(job->outputLength>job->inputLength?job->outputLength:job->inputLength);
	recordBuffer=malloc(recordBufferLength);
	recordCopyLength=(job->outputLength>job->inputLength?job->inputLength:job->outputLength);

	if ((desc=open(file_getName(job->outputFile),O_WRONLY | O_CREAT,S_IRUSR | S_IWUSR | S_IRGRP))<0) {
		fprintf(stderr,"Cannot open file %s : %s\n",file_getName(job->outputFile),strerror(errno));
		return -1;
	}

	for(i=0;i<job->recordNumber;i++) {
		useRecord=1;
		if (job->sumFields==1) {
			if (previousRecord!=-1) {
				if (job_compare(job->recordData+previousRecord*job->inputLength,job->recordData+i*job->inputLength)==0) {
					useRecord=0;
				}
			}
			previousRecord=i;
		}
		if (useRecord==1) {
			if (job->outrec==NULL) {
				memcpy(recordBuffer, job->recordData+i*job->inputLength,recordCopyLength);
			} else {
				outrec_copy(job->outrec,recordBuffer,job->recordData+i*job->inputLength,job->outputLength,job->inputLength);
			}
			if (write(desc,recordBuffer,job->outputLength)<0) {
				fprintf(stderr,"Cannot write to file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				if ((close(desc))<0) {
					fprintf(stderr,"Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
				}
				return -1;
			}
		}

	}
	if ((close(desc))<0) {
		fprintf(stderr,"Cannot close file %s : %s\n",file_getName(job->outputFile),strerror(errno));
		return -1;
	}


	return 0;
}



int job_compare(const void *first, const void *second) {
	int result=0;
	struct sortField_t *sortField;
	for (sortField=globalJob->sortField; sortField!=NULL; sortField=sortField_getNext(sortField)) {
		switch (sortField_getType(sortField)) {
			case FIELD_TYPE_CHARACTER:
				result=memcmp(first+sortField_getPosition(sortField)-1, second+sortField_getPosition(sortField)-1, sortField_getLength(sortField));
				break;
			case FIELD_TYPE_BINARY:
				result=memcmp(first+sortField_getPosition(sortField)-1, second+sortField_getPosition(sortField)-1, sortField_getLength(sortField));
				break;
			default:
				break;
		}
		if (result) {
			if (sortField_getDirection(sortField)==SORT_DIRECTION_ASCENDING) {
				return result;
			} else {
				return -result;
			}
		}
	}
	return 0;
}


