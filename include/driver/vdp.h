
#ifndef __VDP_H__
#define __VDP_H__

#include <types.h>

#define VDP_DATA            0x00C00000
#define VDP_CONTROL         0x00C00004
#define VDP_REGISTER_CMD    0x8000
#define VDP_REGISTER_COUNT  24

#define BIT0                0b00000001
#define BIT1                0b00000010
#define BIT2                0b00000100
#define BIT3                0b00001000
#define BIT4                0b00010000
#define BIT5                0b00100000
#define BIT6                0b01000000
#define BIT7                0b10000000

typedef u32 VDPReg;
typedef u32 VDPConfig;

enum VDPReg {
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

enum VDPConfig {
    VRAM_READ               = 0x00000000,
    VRAM_WRITE              = 0x40000000,
    CRAM_READ               = 0x00000020,
    CRAM_WRITE              = 0xC0000000,
    VSRAM_READ              = 0x00000010,
    VSRAM_WRITE             = 0x40000010
};

extern u8 vdp_registers[VDP_REGISTER_COUNT];

u8 VDPGetRegister(VDPReg vdp_register);
void VDPSetRegister(VDPReg vdp_register, u16 value);

void VDPGetRegister_ASM(VDPReg vdp_register);
void VDPSetRegister_ASM(VDPReg vdp_register, u16 value);

void VDPConfigure(VDPConfig vdp_configuration, u16 address);

u8  VDPReadByte();
u16 VDPReadWord();
u32 VDPReadLongword();

void VDPWriteByte(u8 value);
void VDPWriteWord(u16 value);
void VDPWriteLongword(u32 value);

void VDPSetAutoInc(u16 increment);

#endif // __VDP_H__
