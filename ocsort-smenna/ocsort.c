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

#include <stdio.h>
#include "ocsort.h"
#include "job.h"

extern int yydebug;


int main_prod(int argc, char **argv);
int main_test(int argc, char **argv);

int main(int argc, char **argv) {
	return main_prod(argc,argv);
}

int main_prod(int argc, char **argv) {

	struct job_t *job;
	yydebug=0;
	job=job_constructor();
	if (job_load(job, argc, argv)) {
		return -1;
	}
	job_print(job);
	if (job_check(job)) {
		return -1;
	}

	if (job_loadFiles(job)) {
		return -1;
	}
	if (job_sort(job)) {
		return -1;
	}
	if (job_save(job)) {
		return -1;
	}
	printf("Sort OK\n");
	return 0;
}

#define BUFFER_SIZE 4096
int main_test(int argc, char **argv) {
	char buffer[BUFFER_SIZE+1];
	char *fbuffer[2];
	fbuffer[1]=buffer;
	FILE *f;
	struct job_t *job;
	int i=0;

	if (argc!=2) {
		printf("parameter error\n");
		return 0;
	}

	if ((f=fopen(argv[1],"r"))==NULL) {
		perror("Cannot open file");
		return 0;
	}
	yydebug=0;
	while (fgets(buffer,BUFFER_SIZE, f)!=NULL) {

		job=job_constructor();
		printf("Trying line %d : '%s'\n",i++,buffer);
		if (job_load(job, 2, fbuffer)) {
			printf("Error on load\n");
		} else {
			job_print(job);
		}
		if (job_check(job)) {
			printf("Error on check\n");
		}
	}
	fclose(f);
	return 0;
}
