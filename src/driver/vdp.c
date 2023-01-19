
#include <driver/vdp.h>

u8 vdp_registers[VDP_REGISTER_COUNT];

u8 VDPGetRegister(VDPReg vdp_register)
{
    return vdp_registers[vdp_register];
}

void VDPSetRegister(VDPReg vdp_register, u16 value)
{
    vdp_registers[vdp_register] = (u8) value;
    *((volatile u16*) VDP_CONTROL) = ((u16) VDP_REGISTER_CMD) + (vdp_register << 8) + value;
}

void VDPConfigure(VDPConfig vdp_configuration, u16 address)
{
    *((volatile u32*) VDP_CONTROL) = vdp_configuration + ((0x3FFF & address) << 16) + (address >> 14);
}

u8  VDPReadByte()                   { return *((volatile u8*)VDP_DATA);  }
u16 VDPReadWord()                   { return *((volatile u16*)VDP_DATA); }
u32 VDPReadLongword()               { return *((volatile u32*)VDP_DATA); }

void VDPWriteByte(u8 value)         { *((volatile u8*)VDP_DATA) = value; }
void VDPWriteWord(u16 value)        { *((volatile u16*)VDP_DATA) = value; }
void VDPWriteLongword(u32 value)    { *((volatile u32*)VDP_DATA) = value; }

void VDPSetAutoInc(u16 increment)    { VDPSetRegister(0xF, increment); }



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
