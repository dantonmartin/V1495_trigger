#include <stdio.h>

#include "V1495lib.h"

int main(int argc, char* argv[])
{
    int handle;
    uint32_t data;
    printf("Open Error Code: %d\n", OpenDevice(CAENComm_OpticalLink, 1, 0, 0x76540000, &handle));
    printf("Write Error Code: %d\n", Write32(handle, 0x1010, 0x14));
    printf("Read Error Code: %d\n", Read32(handle, 0x1010, &data));
    printf("Data: %d\n", data);
    printf("Close Error Code: %d\n", CloseDevice(handle));

    return 0;
}
