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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libcob.h>
#include <time.h>
#include "gcsort.h"
#include "libgcsort.h"
#include "utils.h"      
#include "datediff.h"      

 /* ======================================================================================== 
  Add (+/-) months to date. 
  1° - IN - Parameter First date  - YYYYMMDD
  2° - OUT- Parameter Second date - YYYYMMDD
  3° - IN - Parameter Number of months 
  Return code 0 = OK, 8 Date wrong
    ======================================================================================== 
 */
 int gcDateAddMonths(int sDate1, int* sDate2, int nMonths)
 {
     time_t t = time(NULL);
     struct tm tm = *localtime(&t);
     tm.tm_year = (sDate1 / 10000) - 1900;
     tm.tm_mon = (sDate1 / 100) - ((sDate1 / 10000) * 100) - 1;
     tm.tm_mday = sDate1 - ((sDate1 / 100) * 100);
     tm.tm_mon += nMonths;
     mktime(&tm);
     *sDate2 = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
#ifdef GCSDEBUG
     printf("-gcDateAddMonths- In: %d  Months: %d   Out: %d            \n", sDate1, nMonths, (int)*sDate2); /* prints: Sun Mar 16 00:00:00 1980 */
#endif
     return 0;
 }

 /* ======================================================================================== 
    Add (+/-) years to date. 
    1° - IN - Parameter First date  - YYYYMMDD
    2° - OUT- Parameter Second date - YYYYMMDD
    3° - IN - Parameter Number of months 
    Return code 0 = OK, 8 Date wrong
    ======================================================================================== 
 */  
 int gcDateAddYears(int sDate1, int* sDate2, int nYears)
 {
     int rtCode = checkparams(&sDate1);
     if (rtCode != 0)
         return 8;
     *sDate2 = sDate1 + (nYears * 10000);
     return 0;
 }

/* ======================================================================================== 
   Calculate the difference between (+/-) dates. 
   1° - IN - Parameter First date
   2° - IN - Parameter Second date
   3° - OUT- Parameter Number of days 
                  (Result negative indicate first date is minor of second date, 
                   Result positive indicate first date is major of second date)
   Return code 0 = OK, 8 Date wrong
   ======================================================================================== 
*/  
int gcDateDiff( int sDate1,  int sDate2,  int* psDays)
{
    int retcode = 0;
    double seconds;
    *psDays = 0;
    if (sDate1 == sDate2)
        return retcode;
    retcode = checkparams(&sDate1);
    if (retcode != 0)
        return retcode;
    retcode = checkparams(&sDate2);
    if (retcode != 0)
        return retcode;

    time_t t = time(NULL);
    struct tm tm1 = *localtime(&t);
    tm1.tm_year = (sDate1 / 10000) - 1900;
    tm1.tm_mon  = (sDate1 / 100) - ((sDate1 / 10000) * 100) - 1;
    tm1.tm_mday = sDate1 - ((sDate1 / 100) * 100);

    t = time(NULL);
    struct tm tm2 = *localtime(&t);
    tm2.tm_year = (sDate2 / 10000) - 1900;
    tm2.tm_mon  = (sDate2 / 100) - ((sDate2 / 10000) * 100) - 1;
    tm2.tm_mday = sDate2 - ((sDate2 / 100) * 100);

    seconds = difftime(mktime(&tm1), mktime(&tm2));
    *psDays = (int)(seconds / (24.0 * 3600.0)) ;
    
#ifdef GCSDEBUG
    printf("-gcDateDiff- dt1:%d  dt2:%d  %d days \n", sDate1, sDate2, *psDays);
#endif


    return 0;
}
int checkparams( int* sDate)
{
    int sYear, sMonth;
   sYear = *sDate /10000;
   if ((sYear < 1600) || (sYear > 2999))
       return 8;
   
   sMonth = (((*sDate/100)*100)- ((*sDate/10000)*10000))/100;
   if ((sMonth < 1) || (sMonth > 12))
       return 8;
   return 0;
   
}
      
 /*
    ======================================================================================== 
    Convert date to format ordinal.   [hhday30]
    1° - IN - Parameter First date     format 'YYYYMMDD'
    2° - OUT- Parameter Second date    format 'YYYYDDD'
    Return code 0 = OK, 8 Date wrong
    ======================================================================================== 
 */  
 int gcDate2Ord(int sDate1, int* sDate2)
 {
     int retcode = 0;
     retcode = checkparams(&sDate1);
     if (retcode != 0)
         return retcode;

     time_t t = time(NULL);
     struct tm tm1 = *localtime(&t);
     tm1.tm_year = (sDate1 / 10000) - 1900;
     tm1.tm_mon = (sDate1 / 100) - ((sDate1 / 10000) * 100) - 1;
     tm1.tm_mday = sDate1 - ((sDate1 / 100) * 100);
     mktime(&tm1);
     *sDate2 = (tm1.tm_year + 1900) * 1000 + tm1.tm_yday;
#ifdef GCSDEBUG
     printf("-gcDate2Ord- In:%d   Out:%d\n", sDate1, (int)*sDate2); /* prints: Sun Mar 16 00:00:00 1980 */
#endif
     return 0;
 }


 
/* ======================================================================================== 
    Add/subtract days from dates. [hhday20]
    1° - IN - Parameter First date
    2° - OUT- Parameter Second date
    3° - IN - Parameter Number of days 
    Return code 0 = OK, 8 Date wrong
   ======================================================================================== 
*/
 int gcDateAddDays(int sDate, int* sDateOut, int nDays)
 {
     int retcode = 0;
     retcode = checkparams(&sDate);
     if (retcode != 0)
         return retcode;
     time_t t = time(NULL);
     struct tm tm = *localtime(&t);
     tm.tm_year = (sDate / 10000) - 1900;
     tm.tm_mon =  (sDate / 100) - ((sDate / 10000) * 100) - 1;
     tm.tm_mday = sDate - ((sDate / 100)*100);

     tm.tm_mday += nDays;
     mktime(&tm);
     *sDateOut = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;

#ifdef GCSDEBUG
     printf("-gcDateAddDays- In:%d  Days:%d Out:%d            \n", sDate, nDays, (int)*sDateOut);
#endif

     return retcode;
 }

 /* ========================================================================================
     Convert date format ordinal to date.
     1° - IN - Parameter First date     format 'YYYYDDD'
     2° - OUT- Parameter Second date    format 'YYYYMMDD'
     Return code 0 = OK, 8 Date wrong
     ========================================================================================
 */
 int gcOrd2Date(int sDate, int* sDateOut)
 {
     int retcode = 0;
     time_t t = time(NULL);
     struct tm tm1 = *localtime(&t);
     tm1.tm_year = (sDate / 1000) - 1900;
     tm1.tm_mday = (sDate - ((sDate / 1000) * 1000)) + 1;  /* tm_yday (0-365) */
     mktime(&tm1);
     *sDateOut = (tm1.tm_year + 1900) * 10000 + (tm1.tm_mon + 1) * 100 + tm1.tm_mday;
#ifdef GCSDEBUG
     printf("-gcOrd2Date- In:%d    Out:%d\n", sDate, (int)*sDateOut);
#endif
     return retcode;
 }

