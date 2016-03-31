//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#include "CTLVPacket.h"

CTLVPacket::CTLVPacket(char *pBuf,NSUInteger len):m_pData(pBuf),
                                        m_pEndData(m_pData+len),
                                        m_pReadPtr(m_pData)
{
   assert(len);
}


bool CTLVPacket::readInt(uint8_t *data)
{
    return read(data,sizeof(uint8_t));
}

bool CTLVPacket::read(void *pDst,uint8_t uiCount)
{
    ::memcpy(pDst,m_pReadPtr,uiCount);
    m_pReadPtr += uiCount;
    return m_pReadPtr<m_pEndData;
}

bool CTLVPacket::skipReadPtr(uint8_t count)
{
    m_pReadPtr += count;

    return m_pReadPtr < m_pEndData;
}

char *CTLVPacket::getReadPtr()
{
    return m_pReadPtr;
}

