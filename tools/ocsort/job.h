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

#ifndef JOB_H_INCLUDED
#define JOB_H_INCLUDED

struct file_t;
struct sortField_t;
struct condField_t;
struct outrec_t;

struct job_t;

struct job_t *job_constructor();
void job_destructor(struct job_t *job);

int job_load(struct job_t *job, int argc, char **argv);
int job_check(struct job_t *job);
int job_loadFiles(struct job_t *job);
int job_sort(struct job_t *job);
int job_save(struct job_t *job);

int job_print(struct job_t *job);

int job_setOutputFile(struct file_t *file);
int job_addInputFile(struct file_t *file);
int job_setSortField(struct sortField_t *sortField);
int job_addSortField(struct sortField_t *sortField);
int job_setIncludeCondField(struct condField_t *condField);
int job_setOmitCondField(struct condField_t *condField);
int job_addOutrec(struct outrec_t *outrec);
int job_setSumFields();


#endif // JOB_H_INCLUDED
