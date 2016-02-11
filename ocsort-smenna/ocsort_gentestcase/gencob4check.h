/*
 *  Copyright (C) 2016 Sauro Menna
 *
 *	This file is part of ocsort_gentestcase.
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
#ifndef _GENCOB4CHECK_H_
#define _GENCOB4CHECK_H_
//#ifdef _WIN32

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__MINGW64__)
	#include <windows.h>
#endif

int generate_CobfileCheckFile ( struct params_t* params, struct key_t** pKey );

#endif // _GENCOB4CHECK_H_
