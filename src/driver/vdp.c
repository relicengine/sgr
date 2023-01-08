
#include <driver/vdp.h>

unsigned char register_values[0x18] = {
    0b00010100  // Register 0 | Mode Set 1: Horizontal Interrupts ON, HV Counter ON
    
};

u8 vdp_get_register(VDPRegister vdp_register)
{
    return register_values[ (unsigned char) vdp_register ];
}

void vdp_set_register(VDPRegister vdp_register, u8 value)
{
    *((unsigned short*) VDP_CONTROL) = (unsigned short) 0x8000 + value;
}



// Assembly Version
//  1. VDPSetRegister   - Function Names Pascal Case
//  2. MY_MACRO         - Macros, all upper case

/*
void SetAllRegisters(char* buffer)
{

}
*/
