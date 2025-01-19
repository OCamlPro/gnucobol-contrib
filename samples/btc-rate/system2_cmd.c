/*
*>******************************************************************************
*>  system2_cmd.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  system2_cmd.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with system2_cmd.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      system2_cmd.c
*>
*> Purpose:      It reads the command output after execution in Async mode
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2025-01-01
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2025-01-01 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************
*/

#if SYSTEM2_USE_SOURCE
    #define SYSTEM2_DECLARATION_ONLY 1
#endif

#include "System2.h"
#include <stdio.h>

#define EXIT_IF_FAILED(result) \
if(result != SYSTEM2_RESULT_SUCCESS) \
{\
    printf("Error at %d: %d", __LINE__, result);\
    exit(-1);\
}


int system2_cmd(char* cmd_in, int cmd_out_max_len, char* cmd_out, int* cmd_out_len)
{
    System2CommandInfo commandInfo;
    memset(&commandInfo, 0, sizeof(System2CommandInfo));
    commandInfo.RedirectInput = true;
    commandInfo.RedirectOutput = true;

    SYSTEM2_RESULT result;
    int returnCode;
    char outputBuffer[1000];
    uint32_t bytesRead;

    // init output
    *cmd_out_len = 0;
    memset(cmd_out, 0, cmd_out_max_len);

    result = System2Run(cmd_in, &commandInfo);
    EXIT_IF_FAILED(result);
    
    returnCode = -1;
    //True to perform manual cleanup
    result = System2GetCommandReturnValueAsync(&commandInfo, &returnCode, true);
       
    if(result == SYSTEM2_RESULT_SUCCESS || result == SYSTEM2_RESULT_COMMAND_NOT_FINISHED)
    {
        do
        {
            bytesRead = 0;
            memset(outputBuffer, 0, 1000);
            result = System2ReadFromOutput(&commandInfo, outputBuffer, 1000, &bytesRead);

            if(*cmd_out_len + bytesRead >= cmd_out_max_len)
            {
                printf("cmd_out_len >= cmd_out_max_len error at line: %d, cmd_out_max_len: %d\n", __LINE__, cmd_out_max_len);
                exit(-1);
            }
            else
            {
                memcpy(cmd_out + (*cmd_out_len), outputBuffer, bytesRead);
                *cmd_out_len = *cmd_out_len + bytesRead;
            }
        }
        while(result == SYSTEM2_RESULT_READ_NOT_FINISHED);

        returnCode = -1;
        //True to perform manual cleanup
        result = System2GetCommandReturnValueAsync(&commandInfo, &returnCode, true);
        EXIT_IF_FAILED(result);
    }
    else
    {
        EXIT_IF_FAILED(result);
    }
       
    result = System2CleanupCommand(&commandInfo);
    EXIT_IF_FAILED(result);

    return returnCode;
}
