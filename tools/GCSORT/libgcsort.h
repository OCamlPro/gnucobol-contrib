/*
    Copyright (C) 2016-2020 Sauro Menna
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
#ifndef LIBGCSORT_H_INCLUDED
#define LIBGCSORT_H_INCLUDED

#define  COB_SOURCE_FILE		"gcsort.c"
#define  COB_MODULE_FORMATTED_DATE	"gen 04 2021 18:46:15"
#define  COB_MODULE_DATE		20210104
#define  COB_MODULE_TIME		184615

static int g_cb_ebcdic_sign = 0;

#include <libcob.h>

#if __LIBCOB_RELEASE >= 30200

enum cb_colseq {
	CB_COLSEQ_NATIVE = 0,
	CB_COLSEQ_ASCII = 1,
	CB_COLSEQ_EBCDIC = 2
};

static enum cb_colseq g_cb_colseq = CB_COLSEQ_NATIVE;

static cob_u8_t g_cb_coltab[256]; 

#endif /* __LIBCOB_RELEASE >= 30200 */

static const cob_u8_t *g_cb_coltab_ptr = NULL;

#endif /* LIBGCSORT_H_INCLUDED  */
