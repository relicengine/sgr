
#include <driver/vdp.h>

u8 vdp_registers[VDP_REGISTER_COUNT];

u8 VDPGetRegister(VDPReg vdp_register)
{
    return vdp_registers[vdp_register];
}

void VDPSetRegister(VDPReg vdp_register, VDPRegConfig value)
{
    vdp_registers[vdp_register] = (u8) value;
    *((volatile u16*) VDP_CONTROL) = ((u16) VDP_REGISTER_CMD) + (vdp_register << 8) + value;
}






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
