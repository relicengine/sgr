
#include <driver/vdp.h>

u8 vdp_registers[VDP_REGISTER_COUNT];

u8   VDPGetRegister(VDPRegister vdp_register) { return vdp_registers[vdp_register]; }
void VDPSetRegister(VDPRegister vdp_register, u16 value)
{
    vdp_registers[vdp_register] = (u8) value;
    *((u16*) VDP_CONTROL) = ((u16) VDP_REGISTER_CMD) + (vdp_register << 8) + value;
}

void VDPConfigure(VDPConfig vdp_config, u16 address)
{
    *((u32*) VDP_CONTROL) = vdp_config + ((0x3FFF & address) << 16) + (address >> 14);
}

u8   VDPReadByte()                  { return *((u8*)  VDP_DATA); }
u16  VDPReadWord()                  { return *((u16*) VDP_DATA); }
u32  VDPReadLongword()              { return *((u32*) VDP_DATA); }

void VDPWriteByte(u8 value)         { *((u8*)  VDP_DATA) = value; }
void VDPWriteWord(u16 value)        { *((u16*) VDP_DATA) = value; }
void VDPWriteLongword(u32 value)    { *((u32*) VDP_DATA) = value; }

void VDPEnableHInt()                { VDPSetRegister(MODE_SET_1, VDPGetRegister(MODE_SET_1) | BIT_HINT); }
void VDPDisableHInt()               { VDPSetRegister(MODE_SET_1, VDPGetRegister(MODE_SET_1) & ~BIT_HINT); }
u8   VDPHIntEnabled()               { return VDPGetRegister(MODE_SET_1) & BIT_HINT; }

void VDPEnableHVCounter()           { VDPSetRegister(MODE_SET_1, VDPGetRegister(MODE_SET_1) & ~BIT_HVCOUNTER); }
void VDPDisableHVCounter()          { VDPSetRegister(MODE_SET_1, VDPGetRegister(MODE_SET_1) | BIT_HVCOUNTER); }
u8   VDPHVCounterEnabled()          { return !(VDPGetRegister(MODE_SET_1) & BIT_HVCOUNTER); }

void VDPEnableDisplay()             { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) | BIT_DISPLAY); }
void VDPDisableDisplay()            { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) & ~BIT_DISPLAY); }
u8   VDPDisplayEnabled()            { return VDPGetRegister(MODE_SET_2) & BIT_DISPLAY; }

void VDPEnableVInt()                { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) | BIT_VINT); }
void VDPDisableVInt()               { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) & ~BIT_VINT); }
u8   VDPVIntEnabled()               { return VDPGetRegister(MODE_SET_2) & BIT_VINT; }

void VDPEnableDMA()                 { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) | BIT_DMA); }
void VDPDisableDMA()                { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) & ~BIT_DMA); }
u8   VDPDMAEnabled()                { return VDPGetRegister(MODE_SET_2) & BIT_DMA; }

void VDPEnableV30Mode()             { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) | BIT_V30CELL); }
void VDPDisableV30Mode()            { VDPSetRegister(MODE_SET_2, VDPGetRegister(MODE_SET_2) & ~BIT_V30CELL); }
u8   VDPV30ModeEnabled()            { return VDPGetRegister(MODE_SET_2) & BIT_V30CELL; }

void VDPSetScrollAAddress(u16 addr) { VDPSetRegister(NAMETABLE_SCROLL_A, (addr & 0xE000) >> 10); }
u16  VDPGetScrollAAddress()         { return ((u16) VDPGetRegister(NAMETABLE_SCROLL_A)) << 10; }

void VDPSetScrollBAddress(u16 addr) { VDPSetRegister(NAMETABLE_SCROLL_B, (addr & 0xE000) >> 13); }
u16  VDPGetScrollBAddress()         { return ((u16) VDPGetRegister(NAMETABLE_SCROLL_B)) << 13; }

void VDPSetWindowAddress(u16 addr)  { VDPSetRegister(NAMETABLE_WINDOW, (VDPH40ModeEnabled() ? addr & 0xF000 : addr & 0xF800) >> 10); }
u16  VDPGetWindowAddress()          { return ((u16) VDPGetRegister(NAMETABLE_WINDOW)) << 10; }

void VDPSetSpriteAddress(u16 addr)  { VDPSetRegister(NAMETABLE_SPRITE, (VDPH40ModeEnabled() ? addr & 0xFC00 : addr & 0xFE00) >> 9); }
u16  VDPGetSpriteAddress()          { return ((u16) VDPGetRegister(NAMETABLE_SPRITE)) << 9; }

void VDPSetBackgroundColor(u8 palette, u8 color)
{
    VDPSetRegister(BACKGROUND_COLOR, (palette << 4) | color);
}

u8   VDPGetBackgroundColor() { return VDPGetRegister(BACKGROUND_COLOR); }

void VDPSetHIntFrequency(u8 freq)   { VDPSetRegister(H_INTERRUPT, freq); }
u8   VDPGetHIntFrequency()          { return VDPGetRegister(H_INTERRUPT); }

void VDPEnableExternInt()           { VDPSetRegister(MODE_SET_3, VDPGetRegister(MODE_SET_3) | BIT_EXTINT); }
void VDPDisableExternInt()          { VDPSetRegister(MODE_SET_3, VDPGetRegister(MODE_SET_3) & ~BIT_EXTINT); }
u8   VDPExternIntEnabled()          { return VDPGetRegister(MODE_SET_3) & BIT_EXTINT; }

// void VDPSetVScrollMode(VDPVScrollMode mode)
// {

//}

void VDPSetAutoInc(u16 increment)   { VDPSetRegister(0x0F, increment); }

void VDPEnableH40Mode()             { VDPSetRegister(MODE_SET_4, VDPGetRegister(MODE_SET_4) | BIT_H40); }
void VDPDisableH40Mode()            { VDPSetRegister(MODE_SET_4, VDPGetRegister(MODE_SET_4) & ~BIT_H40); }
u8   VDPH40ModeEnabled()            { return (VDPGetRegister(MODE_SET_4) & BIT_H40) == BIT_H40; }
u8   VDPH32ModeEnabled()            { return (VDPGetRegister(MODE_SET_4) & BIT_H40) == 0; }
u8   VDPValidHMode()                { return VDPH40ModeEnabled() || VDPH32ModeEnabled(); }


/*
    Junk Comments
*/

// Assembly Version
//  1. VDPSetRegister   - Function Names Pascal Case
//  2. MY_MACRO         - Macros, all upper case
//asm("MOVE.B %[val],%[reg]" : [reg] "=mQU" (register_values[vdp_register]) : [val] "id" (value));
/*
asm(    "LEA %[reg],%%A0 \n"
            "MOVE.B %%D1,(%%A0,%%D0.W)"
     : 
     : [reg] "m" (register_values), [val] "id" (value)
     : "a0");
*/
/*
void SetAllRegisters(char* buffer)
{

}
*/
