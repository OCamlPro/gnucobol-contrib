/*
 *  Copyright (C) 2016 Sauro Menna
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
#ifndef LIBOCSORT_H_INCLUDED
#define LIBOCSORT_H_INCLUDED


#ifdef	_WIN32
	#ifdef	_MSC_VER
	#pragma warning(disable: 4800)
	#endif

	#if defined (__cplusplus)
		#include <mpirxx.h>
		#else
		#include <mpir.h>
	#endif

	#include <libcob/common.h>

#else

#include <gmp.h>
#ifdef __cplusplus
extern "C" {
#endif

#include <libcob/common.h>

#ifdef __cplusplus
}
#endif
#endif 

#endif // LIBOCSORT_H_INCLUDED
