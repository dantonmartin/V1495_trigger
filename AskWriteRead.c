#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "V1495lib.h"

int main(int argc, char* argv[])
{	
	int v, handle;
	uint32_t Address, Data;
	
	printf("This program writes and reads registers.\nChoose write(0) or read(1):   ");
	scanf("%d", &v);
	
	while ( (v < 0) || (v > 1) ) {
		printf("Invalid entry, try again:     ");
		scanf("%d", &v);
	};
	
	OpenDevice(CAENComm_OpticalLink, 1, 0, 0x76540000, &handle);

	printf("Open Error Code: %d\n", OpenDevice(CAENComm_OpticalLink, 1, 0, 0x7654000, &handle));
	
	if ( v == 0 ) {
		printf("Writing.\nEnter the Address:   ");
		scanf("%" SCNd32, &Address);
		printf("Enter the Data:   ");
		scanf("%" SCNd32, &Data);
	
		Write32 (handle,
				 Address,
				 Data);

		printf("Write Error Code: %d\n", Write32(handle, Address, Data));
	};
	
	if ( v ==  1) {
		printf("Reading.\nEnter the Address:   ");
		scanf("%" SCNd32, &Address);
	
		Read32 (handle,
				Address,
				&Data);
	
		printf("Read Error Code: %d\n", Read32(handle, Address, &Data));
		printf("Data = %" SCNd32, Data);
	}
	
	CloseDevice(handle);
    printf("Close Error Code: %d\n", CloseDevice(handle));
	
	return 0;
}