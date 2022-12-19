/*
*>******************************************************************************
*>  win_sound.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  win_sound.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with win_sound.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      win_sound.c
*>
*> Purpose:      It calls the Windows PlaySound function
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022.12.18
*>
*> Tectonics:    cobc -c win_sound.c -o win_sound.o
*>
*> Usage:        This module implements the call of Windows PlaySound functions.
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2022.12.18 Laszlo Erdos: 
*>            First version created.
*>******************************************************************************
*/

#include <windows.h>
#include <mmsystem.h>

/*  
   The sound is played synchronously, and PlaySound returns after the sound event 
   completes. This is the default behavior.
*/
int win_play_sound_sync(char * wav_file)
{
    int ret = 0;
    ret = PlaySound(TEXT(wav_file), NULL, SND_FILENAME);
    return(ret);
}

/*  
   The sound is played asynchronously and PlaySound returns immediately after 
   beginning the sound. To terminate an asynchronously played waveform sound, 
   call PlaySound with pszSound set to NULL.
*/
int win_play_sound_async(char * wav_file)
{
    int ret = 0;
    ret = PlaySound(TEXT(wav_file), NULL, SND_FILENAME | SND_ASYNC);
    return(ret);
}

/*
   The sound plays repeatedly until PlaySound is called again with the pszSound 
   parameter set to NULL. If this flag is set, you must also set the SND_ASYNC 
   flag.
*/
int win_play_sound_loop(char * wav_file)
{
    int ret = 0;
    ret = PlaySound(TEXT(wav_file), NULL, SND_FILENAME | SND_ASYNC | SND_LOOP);
    return(ret);
}

/*
   Stops playback of a sound that is playing asynchronously.
*/
int win_play_sound_stop()
{
    int ret = 0;
    ret = PlaySound(NULL, 0, 0);
    return(ret);
}
