/*
    Copyright (C) 2016-2021 Sauro Menna
 *
 *	This file is part of GCSORT.
 *
 *  GCSORT is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GCSORT is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GCSORT.  If not, see <http://www.gnu.org/licenses/>.

*/

#ifndef DATEDIFF_H_INCLUDED
#define DATEDIFF_H_INCLUDED

#include <libcob.h>

int gcDateDiff(int sDate1,  int sDate2,  int* sNumDays);
int checkparams(int* sDate);
int gcDate2Ord(int sDate1, int* sDate2);
int gcDateAddDays(int sDate, int* sDateOut, int nDays);
int gcOrd2Date(int sDate, int* sDateOut);
int gcDateAddMonths(int sDate1, int* sDate2, int nMonths);
int gcDateAddYears(int sDate1, int* sDate2, int nYears);

#endif /* DATEDIFF_H_INCLUDED */

