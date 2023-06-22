/**
 * @file   vdp.h
 * @brief  Constants and functions for operating the SEGA Genesis' VDP.
 *
 * This file contains ...
*/

#ifndef __VDP_H__
#define __VDP_H__

#include <types.h>

typedef u32 VDPRegister;
typedef u32 VDPConfig;

#define VDP_DATA            0x00C00000
#define VDP_CONTROL         0x00C00004

#define VDP_REGISTER_CMD    0x8000
#define VDP_REGISTER_COUNT  24

#define MODE_SET_1          0
#define BIT_HINT            0b00010000
#define BIT_HVCOUNTER       0b00000010

#define MODE_SET_2          1
#define BIT_DISPLAY         0b01000000
#define BIT_VINT            0b00100000
#define BIT_DMA             0b00010000
#define BIT_V30CELL         0b00001000

#define NAMETABLE_SCROLL_A  2
#define NAMETABLE_WINDOW    3
#define NAMETABLE_SCROLL_B  4
#define NAMETABLE_SPRITE    5
#define BACKGROUND_COLOR    7
#define H_INTERRUPT         10

#define MODE_SET_3          11
#define BIT_EXTINT          0b00001000

typedef u8 VDPVScrollMode;
#define VSCROLL_FULL        0b00000000
#define VSCROLL_2CELL       0b00000100

typedef u8 VDPHScrollMode;
#define HSCROLL_FULL        0b00000000
#define HSCROLL_CELL        0b00000010
#define HSCROLL_LINE        0b00000011

#define MODE_SET_4          12
#define BIT_H40             0b10000001

#define NAMETABLE_H_SCROLL  13
#define AUTO_INCREMENT      15
#define SCROLL_SIZE         16
#define WINDOW_POS_X        17
#define WINDOW_POS_Y        18
#define DMA_LENGTH_LOW      19
#define DMA_LENGTH_HIGH     20
#define DMA_SOURCE_LOW      21
#define DMA_SOURCE_MID      22
#define DMA_SOURCE_HIGH     23

enum VDPConfig {
    VRAM_READ               = 0x00000000,
    VRAM_WRITE              = 0x40000000,
    CRAM_READ               = 0x00000020,
    CRAM_WRITE              = 0xC0000000,
    VSRAM_READ              = 0x00000010,
    VSRAM_WRITE             = 0x40000010
};

typedef struct { u8 palette; u8 color; } VDPBackgroundColor;

extern u8 vdp_registers[VDP_REGISTER_COUNT];

u8   VDPGetRegister(VDPRegister vdp_register);
void VDPSetRegister(VDPRegister vdp_register, u16 value);

void VDPGetRegister_ASM(VDPRegister vdp_register);
void VDPSetRegister_ASM(VDPRegister vdp_register, u16 value);

void VDPConfigure(VDPConfig vdp_configuration, u16 address);

u8   VDPReadByte();
u16  VDPReadWord();
u32  VDPReadLongword();

void VDPWriteByte(u8 value);
void VDPWriteWord(u16 value);
void VDPWriteLongword(u32 value);

void VDPEnableHInt();
void VDPDisableHInt();
u8   VDPHIntEnabled();

void VDPEnableHVCounter();
void VDPDisableHVCounter();
u8   VDPHVCounterEnabled();

void VDPEnableDisplay();
void VDPDisableDisplay();
u8   VDPDisplayEnabled();

void VDPEnableVInt();
void VDPDisableVInt();
u8   VDPVIntEnabled();

void VDPEnableDMA();
void VDPDisableDMA();
u8   VDPDMAEnabled();

void VDPEnableV30Mode();
void VDPDisableV30Mode();
u8   VDPV30ModeEnabled();

void VDPSetScrollAAddress(u16 addr);
u16  VDPGetScrollAAddress();

void VDPSetScrollBAddress(u16 addr);
u16  VDPGetScrollBAddress();

void VDPSetWindowAddress(u16 addr);
u16  VDPGetWindowAddress();

void VDPSetSpriteAddress(u16 addr);
u16  VDPGetSpriteAddress();

void VDPSetBackgroundColor(u8 palette, u8 color);
u8   VDPGetBackgroundColor();

void VDPSetHIntFrequency(u8 freq);
u8   VDPGetHIntFrequency();

void VDPEnableExternInt();
void VDPDisableExternInt();
u8   VDPExternIntEnabled();

//void VDPSetVScrollMode(VDPVScrollMode mode);
//void VDPSetHScrollMode(VDPHScrollMode mode);

void VDPSetAutoInc(u16 increment);

void VDPEnableH40Mode();
void VDPDisableH40Mode();
u8   VDPH40ModeEnabled();
u8   VDPH32ModeEnabled();
u8   VDPValidHMode();

#endif // __VDP_H__
