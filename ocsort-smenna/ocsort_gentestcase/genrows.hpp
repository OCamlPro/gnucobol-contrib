/*
 *  Copyright (C) 2016 Sauro Menna
 *
 *	This file is part of ocsortgentestcase.
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

*/// genfield.hpp

	for (i=0; i <= params->nMaxFields; i++) {
		if (nPosAbs < pKey[i]->pos) {
			if ((pKey[i]->pos - nPosAbs) >  1)
				sprintf((char*) pBuf, "999999       03   FILLER-%05d             PIC  X(%05d).\n", nPosAbs, (pKey[i]->pos - nPosAbs));
			else
				sprintf((char*) pBuf, "999999       03   FILLER-%05d             PIC  X.\n", nPosAbs);
			write_line(pFile, (char*) pBuf);
			nPosAbs = nPosAbs + (pKey[i]->pos - nPosAbs);
		}

// special fields
		if (strcmp(pKey[i]->type, "PR") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC S9(%05d).\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  9.\n",       
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "FX") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  X(%05d).\n",	
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  X.\n",       
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}

// standard field
		if (strcmp(pKey[i]->type, "CH") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  X(%05d).\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  X.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "ZD") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC S9(%05d).\n", 
														pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  9.\n", 
														pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "BI") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  9(%05d) COMP.\n", 
														pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len*2);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  9 COMP.\n", 
														pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "FI") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC S9(%05d) COMP.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, pKey[i]->len*2);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC S9 COMP.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}
		if (strcmp(pKey[i]->type, "PD") == 0) {
			if (pKey[i]->len > 1)
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC S9(%05d) COMP-3.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order, (pKey[i]->len*2)-1);
			else
				sprintf((char*) pBuf, "999999       03   F-%s-%05d-%05d-%s         PIC  9 COMP-3.\n", 
														 pKey[i]->type, pKey[i]->pos, pKey[i]->len, pKey[i]->order);
			write_line(pFile, (char*) pBuf);
		}

		nPosAbs = nPosAbs  + (pKey[i]->len);
	}

	//if (strcmp(params->szRec, "F") == 0) {
		if (nPosAbs < params->nLenMax) {
			sprintf((char*) pBuf, "999999       03   FILLER-%05d             PIC  X(%05d).\n", params->nLenMax, (params->nLenMax - nPosAbs + 1));
			write_line(pFile, (char*) pBuf);
		}
	//}
