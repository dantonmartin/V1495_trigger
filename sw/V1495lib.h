#include "CAENComm.h"

CAENComm_ErrorCode OpenDevice(CAENComm_ConnectionType LinkType,
                              int                     LinkNum,
                              int                     ConetNode,
                              uint32_t                VMEBaseAddress,
                              int*                    handle);

CAENComm_ErrorCode Write32(int      handle,
                           uint32_t Address,
                           uint32_t Data);

CAENComm_ErrorCode Read32(int       handle,
                          uint32_t  Address,
                          uint32_t* Data);

CAENComm_ErrorCode CloseDevice(int handle);

