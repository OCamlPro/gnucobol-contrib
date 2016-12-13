/*
 *  Copyright (C) 2016 Sauro Menna
 *
 *	This file is part of gcsort_gentestcase.
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
#ifndef _GENCFG_H_
#define _GENCFG_H_
	char szscripthead[50][256];		// 50 rows, 256 characters for rows
	int b_scripthead;
	int n_scripthead;

	char szgcsort_top[50][256];		// 50 rows, 256 characters for rows
	int b_gcsort_top;
	int n_gcsort_top;

	char szgcsort_bottom[50][256];		// 50 rows, 256 characters for rows
	int b_gcsort_bottom;
	int n_gcsort_bottom;
#endif // _GENCFG_H_
