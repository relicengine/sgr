
#include <driver/vdp.asm>

.global     VDPGetRegister_ASM
.section    .text.VDPGetRegister_ASM
//D0.W - REG NUM
VDPGetRegister_ASM:         LEA.L   vdp_registers,A0
                            MOVE.B  (A0,D0.W),D0
                            RTS

.global     VDPSetRegister_ASM
.section    .text.VDPSetRegister_ASM
//D0.W - REG_NUM
//D1.W - VALUE
VDPSetRegister_ASM:         LEA.L   vdp_registers,A0
                            MOVE.B  D1,(A0,D0.W)
                            LSL.W   #8,D0
                            ADDI.W  #VDP_REGISTER_CMD,D0
                            ADD.B   D1,D0
                            MOVE.W  D0,VDP_CONTROL
                            RTS

.global     VDP_REGISTERS
.section    .vdp_regs
VDP_REGISTERS:
VDP_REG0:                   DC.B 0x14
VDP_REG1:   			    DC.B 0x64
VDP_REG2:   		        DC.B 0x28
VDP_REG3:   			    DC.B 0x3C
VDP_REG4:   			    DC.B 0x07
VDP_REG5:   			    DC.B 0x7C
VDP_REG6:   			    DC.B 0x00
VDP_REG7:   			    DC.B 0x00
VDP_REG8:   			    DC.B 0x00
VDP_REG9:   			    DC.B 0x00
VDP_REGA:   			    DC.B 0xFF
VDP_REGB:   			    DC.B 0x00
VDP_REGC:   			    DC.B 0x81
VDP_REGD:   			    DC.B 0x3F
VDP_REGE:   			    DC.B 0x00
VDP_REGF:   			    DC.B 0x02
VDP_REG10:  			    DC.B 0x01
VDP_REG11:  			    DC.B 0x00
VDP_REG12:  			    DC.B 0x00
VDP_REG13:  			    DC.B 0xFF
VDP_REG14:  			    DC.B 0xFF
VDP_REG15:  			    DC.B 0x00
VDP_REG16:  			    DC.B 0x00
VDP_REG17:  			    DC.B 0x80