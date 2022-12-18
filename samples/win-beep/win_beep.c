/*
*>******************************************************************************
*>  win_beep.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  win_beep.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with win_beep.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      win_beep.c
*>
*> Purpose:      It calls the Windows Beep function
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2022.12.18
*>
*> Tectonics:    cobc -c win_beep.c -o win_beep.o
*>
*> Usage:        This module implements the call of Windows Beep functions.
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2022.12.18 Laszlo Erdos: 
*>            First version created.
*>******************************************************************************
*/

#include <windows.h>

/*
   The Beep generates simple tones on the speaker. The function is synchronous; it performs 
   an alertable wait and does not return control to its caller until the sound finishes.
   
   Parameters:
   - freq:     The frequency of the sound, in hertz. This parameter must be in the range 
               37 through 32,767 (0x25 through 0x7FFF).
   - duration: The duration of the sound, in milliseconds.

   Return value:
   - If the function succeeds, the return value is nonzero.
   - If the function fails, the return value is zero. 
*/   
int win_beep(unsigned long freq, unsigned long duration)
{
    int ret = 0;
    ret = Beep(freq, duration);
    return(ret);
}

/*
   The MessageBeep plays a waveform sound. The waveform sound for each sound type is identified 
   by an entry in the registry. After queuing the sound, the MessageBeep function 
   returns control to the calling function and plays the sound asynchronously.
   
   The parameter can be one of the following values:
   Value                           Meaning

                      0xFFFFFFFF   A simple beep. If the sound card is not available, the sound is generated using the speaker.

   MB_ICONASTERISK    0x00000040L  See MB_ICONINFORMATION.

   MB_ICONEXCLAMATION 0x00000030L  See MB_ICONWARNING.

   MB_ICONERROR       0x00000010L  The sound specified as the Windows Critical Stop sound.

   MB_ICONHAND        0x00000010L  See MB_ICONERROR.

   MB_ICONINFORMATION 0x00000040L  The sound specified as the Windows Asterisk sound.

   MB_ICONQUESTION    0x00000020L  The sound specified as the Windows Question sound.

   MB_ICONSTOP        0x00000010L  See MB_ICONERROR.

   MB_ICONWARNING     0x00000030L  The sound specified as the Windows Exclamation sound.

   MB_OK              0x00000000L  The sound specified as the Windows Default Beep sound.

   Return value:
   - If the function succeeds, the return value is nonzero.
   - If the function fails, the return value is zero.
*/
int win_msg_beep(unsigned int sound_type)
{
    int ret = 0;
    ret = MessageBeep(sound_type);
    return(ret);
}
