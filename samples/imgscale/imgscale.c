/*
*>******************************************************************************
*>  imgscale.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  imgscale.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with imgscale.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      imgscale.c
*>
*> Purpose:      Converts and scales images in formats BMP, GIF, JPG, PNG, TIFF
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-02-22
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-02-22 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************
*/

#include "gd.h"
#include <stdio.h>

int imgscale(char *img_in, int *img_in_type, char *img_out, int *img_out_type, int *width_out) {
  gdImagePtr image, new_image;
  FILE *infile; FILE *outfile;
  int height, width, orig_width, orig_height, quality, compression, retval;
  
  width = *width_out;
  retval = 0;
  
  if ((*img_in_type < 0) || (*img_in_type > 4)) {
      retval = -1;
      return(retval);
  }
  if ((*img_out_type < 0) || (*img_out_type > 4)) {
      retval = -1;
      return(retval);
  }
  
  infile = fopen (img_in, "rb");
  if(infile == NULL) {  
      retval = -1;
      return(retval);
  }
  
  outfile = fopen (img_out, "wb");
  if(outfile == NULL) {  
      retval = -1;
      return(retval);
  }
  
  switch (*img_in_type) {
      case 0: 
         image = gdImageCreateFromBmp(infile); 
         break;
      case 1: 
         image = gdImageCreateFromGif(infile); 
         break;
      case 2: 
         image = gdImageCreateFromJpeg(infile);
         break;
      case 3: 
         image = gdImageCreateFromPng(infile);
         break;
      case 4: 
         image = gdImageCreateFromTiff(infile);  
         break;
  }

  orig_width = gdImageSX (image);
  orig_height = gdImageSY (image);
  height = ((orig_height * width) / orig_width);
  
  new_image = gdImageCreateTrueColor (width, height);
  
  gdImageCopyResized (new_image, image, 0, 0, 0, 0, width, height, orig_width, orig_height);

  switch (*img_out_type) {
      case 0: 
         /* 0 is no compression at all */
         compression = 0;
         gdImageBmp (new_image, outfile, compression);    
         break;
      case 1: 
         gdImageGif (new_image, outfile);
         break;
      case 2: 
         /* 100 is highest quality 0 is lowest */
         quality = 100;
         gdImageJpeg (new_image, outfile, quality);
         break;
      case 3: 
         gdImagePng (new_image, outfile);
         break;
      case 4: 
         gdImageTiff (new_image, outfile);
         break;
  }
  
  gdImageDestroy (image);
  gdImageDestroy (new_image);
  
  fclose (infile);  
  fclose (outfile);  
  
  return (retval);
}