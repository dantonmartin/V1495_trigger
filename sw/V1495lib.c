#include <stdio.h>

#include "V1495lib.h"

CAENComm_ErrorCode OpenDevice(CAENComm_ConnectionType LinkType,
                              int                     LinkNum,
                              int                     ConetNode,
                              uint32_t                VMEBaseAddress,
                              int*                    handle)
{
     return CAENComm_OpenDevice(LinkType,
                                LinkNum,
                                ConetNode,
                                VMEBaseAddress,
                                handle);
}

CAENComm_ErrorCode Write32(int      handle,
                           uint32_t Address,
                           uint32_t Data)
{
    return CAENComm_Write32(handle,
                            Address,
                            Data);
}

CAENComm_ErrorCode Read32(int       handle,
                          uint32_t  Address,
                          uint32_t* Data)
{
    return CAENComm_Read32(handle,
                           Address,
                           Data);
}

CAENComm_ErrorCode CloseDevice(int handle)
{
    return CAENComm_CloseDevice(handle);
}
