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
//
// Structure for Key definition Indexed File
// Input and Output
//

#ifndef EXITROUTINES_H_INCLUDED
#define EXITROUTINES_H_INCLUDED

#include <stdint.h>
#include <libcob.h>

/* Global variables */
// #include "M1.c.h"
// START
/* Module path */
static const char		*cob_module_path2 = NULL;

/* Number of call parameters */
static int		cob_call_params = 0;

/* Attributes */
/*
static const cob_field_attr cobfattr_1 =	{0x11,   8,   0, 0x0820, NULL};
static const cob_field_attr cobfattr_2 =	{0x01,   0,   0, 0x0000, NULL};
static const cob_field_attr cobfattr_3 =	{0x21,   0,   0, 0x0000, NULL};
static const cob_field_attr cobfattr_4 =	{0x21,   0,   0, 0x1000, NULL};
*/

/* Constants */
//static const cob_field c_1	= {18, (cob_u8_ptr)" returne-code = 16", &cobfattr_4};


struct E15Call_t {
	cob_field* pCallE15;		// Call Name
	cob_field* pRecFlag;		// Record Flag			PIC 9(8) BINARY
	cob_field* pSendRec;		// Record Send			PIC X(n)
	cob_field* pReceiveRec;		// Record Receive		PIC X(n)
	cob_field* pUnused1;		// UNUSED1				PIC 9(8) BINARY
	cob_field* pUnused2;		// UNUSED2				PIC 9(8) BINARY
	cob_field* pNewRecLen;		// NEW-REC-LEN			PIC 9(8) BINARY	(Fixed / Variable Length)
	cob_field* pReturnRecLen;	// RETURN-REC-LEN		PIC 9(8) BINARY (Fixed / Variable Length)
	cob_field* pUnused5;		// UNUSED5				PIC 9(8) BINARY
	cob_field* pExitAreaLen;	// pEXITAREA_LEN		PIC 9(4) COMP
	cob_field* pExitArea;		// pEXITAREA			PIC X(n)
	int		   nRekID;


};

struct E35Call_t {
	cob_field* pCallE35;		// Call Name
	cob_field* pRecFlag;		// Record Flag			PIC 9(8) BINARY
	cob_field* pSendRec;		// Record Send			PIC X(n)
	cob_field* pReceiveRec;		// Record Receive		PIC X(n)
	cob_field* pOutputRec;		// Record Output		PIC X(n)
	cob_field* pUnused1;		// UNUSED2				PIC 9(8) BINARY
	cob_field* pNewRecLen;		// NEW-REC-LEN			PIC 9(8) BINARY	(Fixed / Variable Length)
	cob_field* pReturnRecLen;	// RETURN-REC-LEN		PIC 9(8) BINARY (Fixed / Variable Length)
	cob_field* pOutputRecLen;	// OUTPUT-REC-LEN		PIC 9(8) BINARY
	cob_field* pExitAreaLen;	// pEXITAREA_LEN		PIC 9(4) COMP
	cob_field* pExitArea;		// pEXITAREA			PIC X(n)
	int		   nRekID;


};


struct E15Call_t*  E15Call_constructor(int nLenRecSize);
void E15Call_destructor(struct E15Call_t* pE15C);
int E15Call_SetCallName(struct E15Call_t* pE15C, char* szCallName);
int	E15Run(const int entry, struct E15Call_t* pE15C, int nRecFlag, int nLen, unsigned char* pSendRec, unsigned char* pReceiveRec, int* newLen, int nIsFileVariable);
void E15ResetParams(int* nrekE15, int* nrekFlagE15, int nLastRecord);

struct E35Call_t* E35Call_constructor(int nLenRecSize);
void E35Call_destructor(struct E35Call_t* pE35C);
int E35Call_SetCallName(struct E35Call_t* pE35C, char* szCallName);
int	E35Run(const int entry, struct E35Call_t* pE35C, int nRecFlag, int nLen, unsigned char* pSendRec, unsigned char* pReceiveRec, unsigned char* pOutRec, int* newLen, int* nOutLen, int nIsFileVariable);
void E35ResetParams(int* nrekE35, int* nrekFlagE35, int nLastRecord);


#endif // EXITROUTINES_H_INCLUDED
