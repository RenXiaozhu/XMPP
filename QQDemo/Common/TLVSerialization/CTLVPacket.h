//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#ifndef SMARTBASCKETBALL_CTLVPACKET_H
#define SMARTBASCKETBALL_CTLVPACKET_H


class CTLVPacket
{
private:
    char *m_pData;
    char *m_pEndData;
    char *m_pReadPtr;

public:
    CTLVPacket(char *pBuf, NSUInteger len);

    bool readInt(uint8_t *data);//读TAG或Length

    bool read(void *pDst, uint8_t uiCount);

    bool skipReadPtr(uint8_t count);

    char *getReadPtr();

};


#endif //SMARTBASCKETBALL_CTLVPACKET_H
