
#ifndef __VDP_H__
#define __VDP_H__

#include <types.h>

#define VDP_DATA        0x00C00000
#define VDP_CONTROL     0x00C00004
#define VDP_REG_CMD     0x8000

enum VDPRegister {
    MODE_SET_1              = 0,
    MODE_SET_2              = 1,
    NAMETABLE_SCROLL_A      = 2,
    NAMETABLE_WINDOW        = 3,
    NAMETABLE_SCROLL_B      = 4,
    NAMETABLE_SPRITE        = 5,
    BACKGROUND_COLOR        = 7,
    H_INTERRUPT             = 10,
    MODE_SET_3              = 11,
    MODE_SET_4              = 12,
    NAMETABLE_H_SCROLL      = 13,
    AUTO_INCREMENT          = 15,
    SCROLL_SIZE             = 16,
    WINDOW_POS_X            = 17,
    WINDOW_POS_Y            = 18,
    DMA_LENGTH_LOW          = 19,
    DMA_LENGTH_HIGH         = 20,
    DMA_SOURCE_LOW          = 21,
    DMA_SOURCE_MID          = 22,
    DMA_SOURCE_HIGH         = 23
};

typedef enum VDPRegister VDPRegister;

u8 vdp_get_register(VDPRegister vdp_register);
void vdp_set_register(VDPRegister vdp_register, u8 value);
//void VDPSetAllRegisters(char* buffer);

#endif // __VDP_H__