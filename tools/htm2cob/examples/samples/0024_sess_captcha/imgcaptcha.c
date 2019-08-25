/*
*>******************************************************************************
*>  imgcaptcha.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  imgcaptcha.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with imgcaptcha.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      imgcaptcha.c
*>
*> Purpose:      Creates a PNG image captcha file
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-06-17
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-06-17 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************
*/

#include "gd.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

/* TODO: set your true type font with full path */
#define ttf "/home/laszlo.erdoes/imgcaptcha/FreeSerifItalic.ttf"

int imgcaptcha(char *captcha_file_name, int *captcha_char_type, char *captcha_text) {
  gdImagePtr image;
  FILE *captcha;
  int i, white, black, line_color, pixel_color;
  double ptsize, angle;
  int brect[8];
  char *err;
  struct timespec tp;
  char letter[2] = "";
  char text[7] = "";

  /* char sets */  
  char numbers[10] = "0123456789";
  char uppercase_letters[26] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  char lowercase_letters[26] = "abcdefghijklmnopqrstuvwxyz";
  char letters[52] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  char letters_numbers[62] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  char uppercase_letters_numbers[36] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  char lowercase_letters_numbers[36] = "abcdefghijklmnopqrstuvwxyz0123456789";
    
  /* intializes random number generator */
  clock_gettime(CLOCK_MONOTONIC, &tp);
  srand((unsigned) tp.tv_nsec);
   
  /* create an image 200x50 */
  image = gdImageCreate(200, 50);
  /* background color is first allocated */
  white = gdImageColorResolve(image, 255, 255, 255);
  black = gdImageColorResolve(image,   0,   0,   0);  

  /* generate random lines */
  line_color = gdImageColorAllocate(image, 64, 64, 64); 
  for(i = 0; i < 15; i++) {
     gdImageLine(image, 0, rand()%50, 200, rand()%50, line_color);
  }  
  
  /* generate random dots */
  pixel_color = gdImageColorAllocate(image, rand()%256, rand()%256, rand()%256);
  for(i = 0; i < 3000; i++) {
     gdImageSetPixel(image, rand()%200, rand()%50, pixel_color);
  }  
  
  ptsize = 25.0;
  memset(text, 0, sizeof(text));
  
  /* write captcha text on image */
  for(i = 0; i < 6; i++) {
     memset(letter, 0, sizeof(letter));
     
     switch (*captcha_char_type) {
         case 0: 
            strncpy(letter, &numbers[rand() % 10], 1); 
            break;
         case 1: 
            strncpy(letter, &uppercase_letters[rand() % 26], 1); 
            break;
         case 2: 
            strncpy(letter, &lowercase_letters[rand() % 26], 1); 
            break;
         case 3: 
            strncpy(letter, &letters[rand() % 52], 1); 
            break;
         case 4: 
            strncpy(letter, &letters_numbers[rand() % 62], 1); 
            break;
         case 5: 
            strncpy(letter, &uppercase_letters_numbers[rand() % 36], 1); 
            break;
         case 6: 
            strncpy(letter, &lowercase_letters_numbers[rand() % 36], 1); 
            break;
     }
     text[i] = letter[0]; 
     
     angle = (float)rand() / (float)(RAND_MAX / 0.5);
     err = gdImageStringFT(image, &brect[0], black, ttf, ptsize, angle, 15 + (i * 30), 40, letter);
     if(err) {
        printf("error in gdImageStringFT:%s\n", err);
        return(-1);
     }
  }  
  
  /* copy captcha text */
  strncpy(captcha_text, text, 6);
  
  /* write captcha file */
  captcha = fopen (captcha_file_name, "wb");
  if(captcha == NULL) {  
     return(-1);
  }

  gdImagePng (image, captcha);
  gdImageDestroy (image);
  
  fclose (captcha);  
  
  return (0);
}

