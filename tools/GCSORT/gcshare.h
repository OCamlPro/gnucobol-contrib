// 
// Shared variables
// 
#include "gcsort.h"
#include "job.h"
#ifndef SHAREFILE_INCLUDED
	#define SHAREFILE_INCLUDED
	#ifdef  MAIN_FILE
		char	szMexToken[260]; 
		char	cob_tmp_buff[COB_MEDIUM_BUFF];
		char	cob_tmp_temp[FILENAME_MAX];
		struct job_t* globalJob;
		char	cob_tmp_buff[COB_MEDIUM_BUFF];
		char	cob_tmp_temp[FILENAME_MAX];

	#else
		extern char szMexToken[260];
		extern char	cob_tmp_buff[COB_MEDIUM_BUFF];
		extern char	cob_tmp_temp[FILENAME_MAX];
		extern struct job_t* globalJob;
		extern char	cob_tmp_buff[COB_MEDIUM_BUFF];
		extern char	cob_tmp_temp[FILENAME_MAX];

	#endif
#endif