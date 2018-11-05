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
        FILE* bmpfile =fopen (bmp_filename, "rb");
        if( bmpfile == NULL ){
          printf( "I was unable to open the file.\n" );
          return NULL;
        }
           // Read the overall file size
	char b, m;
	fread( &b, 1, 1, bmpfile );
	fread( &m, 1, 1, bmpfile );
        fread(data_size, 1, sizeof(unsigned int), bmpfile);

        // Rewind file pointer to the beginning and read the entire contents.
        rewind(bmpfile);
	//printf("data size is %d.\n", (*data_size));
        //make image_data
        img_data = (unsigned char*) malloc(sizeof(char)*(*data_size));

	if (fread (img_data, 1, *data_size, bmpfile) != *data_size){
		printf("Data size is %d.\n", *data_size);
	}
	*data_offset=*(unsigned int*)(img_data+10);
        // width
        *width = *(unsigned int*)(img_data+18);
        //height
        *height = *(unsigned int*)(img_data+22);
        //bits per pixel
       	*bits_per_pixel = *(unsigned short int*)(img_data+28);
        //padding
        int nColours= (*bits_per_pixel/8); 
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

unsigned char***  
bmp_scale( unsigned char*** pixel_array, unsigned char* header_data, unsigned int header_size,
           unsigned int* width, unsigned int* height, unsigned int num_colors,
           float scale )
{
  unsigned char*** new_pixel_array = NULL; 
  // REPLACE EVERYTHING FROM HERE
//update width and height
	int newWidth = (*width)*scale;
	int newHeight = (*height)*scale;
	*((unsigned int*)(header_data +18))= newWidth;
	*((unsigned int*)(header_data+22))= newHeight;
	*width = newWidth;
	*height= newHeight;

//add some space
	new_pixel_array = (unsigned char***) malloc(sizeof(unsigned char**)*(*height));
	if (new_pixel_array == NULL){
		printf("Sorry, memory could not be allocated.\n");
		return NULL;
	}
	
	for(int r = 0; r < *height; r++){
		new_pixel_array[r]= (unsigned char **) malloc (sizeof(unsigned char*)*(*width));
		for (int c = 0; c < *width; c++){
			new_pixel_array[r][c]= (unsigned char*) malloc (sizeof(unsigned char)*(num_colors));
		}
	}

//next up is actually populating the array
	for (int r = 0; r< *height; r++){
		for (int c = 0; c < *width; c++){
			for (int colour = 0; colour < num_colors; colour++){
				int newr= r/scale;
				int newc = c/scale;
				new_pixel_array[r][c][colour]= pixel_array[newr][newc][colour];
			}
		}
	}




  // TO HERE! 
  return new_pixel_array;
}         

int 
bmp_collage( char* background_image_filename,     char* foreground_image_filename, 
             char* output_collage_image_filename, int row_offset,                  
             int col_offset,                      float scale )
{
  // REPLACE EVERYTHING FROM HERE

// open bg, and bmp to 3D
//bmp to 3D calls bmpopen itself

unsigned char* bgheaderdata;
unsigned int bghsize;
unsigned int bgwidth;
unsigned int bgheight;
unsigned int bgnumc;
unsigned char***bgarray= bmp_to_3D_array( background_image_filename, &bgheaderdata, &bghsize, &bgwidth, &bgheight, &bgnumc);

//open fg, bmp  to 3D
unsigned char* fgheaderdata;
unsigned int fghsize;
unsigned int fgwidth;
unsigned int fgheight;
unsigned int fgnumc;
unsigned char***fgarray= bmp_to_3D_array( foreground_image_filename, &fgheaderdata, &fghsize, &fgwidth, &fgheight, &fgnumc);

//check colours
if( bgnumc != 4 || fgnumc != 4){
	printf("ERROR: The image(s) have an incorrect amound of colours\n");	
	return -1;
}
//and scale fg
unsigned char*** scaledfg = bmp_scale(fgarray, fgheaderdata, fghsize, &fgwidth, &fgheight, fgnumc, scale); 

	//and check that foreground is smaller
	if (*fgheaderdata >= bghsize){
		printf("ERROR: The foreground image should be smaller than the background\n");
		return -1;
	}
//now overlay the pixels
	for (int r = row_offset; r < (fgheight +row_offset); r++){
		for (int c = col_offset; c< (fgwidth + col_offset); c++){
			for(int colour = 0; colour <fgnumc; colour++){
			if ( scaledfg[r-row_offset][c-col_offset][colour] != 0){
				bgarray[r][c][colour]= scaledfg[r-row_offset][c-col_offset][colour];
				}
			}
		}
	}

//write result in output image
int write= bmp_from_3D_array(output_collage_image_filename, bgheaderdata, bghsize, bgarray, bgwidth, bgheight, bgnumc);

if(write ==-1){
 printf("Image could not be written\n");
	return -1;
}
  // TO HERE! 
  return 0;
}              

