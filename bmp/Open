#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "A3_provided_functions.h"

unsigned char*
bmp_open( char* bmp_filename,        unsigned int *width,
          unsigned int *height,      unsigned int *bits_per_pixel,
          unsigned int *padding,     unsigned int *data_size,
          unsigned int *data_offset                                  )
{
  unsigned char *img_data=NULL;
  // REPLACE EVERYTHING FROM HERE
        //open file
        printf("File name is %s \n", bmp_filename);
        FILE* bmpfile =fopen (bmp_filename, "rb");
        if( bmpfile == NULL ){
          printf( "I was unable to open the file.\n" );
          return NULL;
        }
        char b, m;
        fread( &b, 1, 1, bmpfile );
        fread( &m, 1, 1, bmpfile );
           // Read the overall file size
        fread(data_size, 1, sizeof(unsigned int), bmpfile);

        // Rewind file pointer to the beginning and read the entire contents.
        rewind(bmpfile);

        //make image_data
        img_data = (unsigned char*) malloc(sizeof(char)*(*data_size));
          if (fread (img_data, 1, *data_size, bmpfile) != *data_size){
		printf("Something is wrooong :(");
	}
	*data_offset=*(unsigned int*)(img_data+10);
        // width
        *width = *(unsigned int*)(img_data+18);
        //height
        *height = *(unsigned int*)(img_data+22);
        //bits per pixel
        *bits_per_pixel = *(unsigned short int*)(img_data+28);
        //padding
        int nColours= (*bits_per_pixel/8); //4
        *padding =  ((4-(*width * nColours)%4)%4);

  // TO HERE!
  return img_data;
} 
void
bmp_close( unsigned char **img_data )
{
  // REPLACE EVERYTHING FROM HERE
  free(*img_data);
  *img_data = NULL;
  // TO HERE!
}
