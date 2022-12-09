                        .section .vdp
                        .global VDP_REGISTERS, IGNORE_HANDLER, END, GLOBAL_VAR
/* ------------------------------------------------------------- */
/* EXCEPTION AND INTERRUPT HANDLERS */
/* ------------------------------------------------------------- */
/* ------------------------------------------------------------- */	
/* --- IGNORE HANDLER ------------------------------------------ */
						align 2 								/*WORD ALIGN*/
IGNORE_HANDLER:			RTE 									/*RETURN FROM EXCEPTION*/


 /*                       section .asmdata*/
/*GLOBAL_VAR:             DC.W    4*/
/*                        section .vdp*/


/* ------------------------------------------------------------- */
/* VDP REGISTERS */
/* ------------------------------------------------------------- */
						align 2									/*WORD ALIGN*/
VDP_REGISTERS:
VDP_REG0:   			DC.B 0x14 								/*0:  H INTURRUPT ON PALETTES ON*/
VDP_REG1:   			DC.B 0x74 								/*1:  V INTURRUPT ON PALETTES ON*/
VDP_REG2:   			DC.B 0x30 								/*2:  PATTERN TABLE FOR SCROLL PLANE A AT VRAM ADDRESS 0xC000*/
VDP_REG3:   			DC.B 0x3E 								/*3:  PATTERN TABLE FOR WINDOW PLANE AT VRAM ADDRESS 0xF000*/
VDP_REG4:   			DC.B 0x07 								/*4:  PATTERN TABLE FOR SCROLL PLANE B AT VRAM ADDRESS 0xE000*/
VDP_REG5:   			DC.B 0x6C 								/*5:  SPRITE TABLE AT VRAM 0xD800*/
VDP_REG6:   			DC.B 0x00 								/*6:  UNUSED*/
VDP_REG7:   			DC.B 0x00 								/*7:  BACKGROUND COLOR*/
VDP_REG8:   			DC.B 0x00 								/*8:  UNUSED*/
VDP_REG9:   			DC.B 0x00 								/*9:  UNUSED*/
VDP_REGA:   			DC.B 0xFF 								/*10: FREQUENXY OF HORIZONTAL INTERRUPT IN RASTERS*/
VDP_REGB:   			DC.B 0x00 								/*11: EXTERNAL INTERRUPTS*/
VDP_REGC:   			DC.B 0x81 								/*12: SHADOWS AND HIGHLIGHTS OFF, INTERLACE OFF, H40 MODE (320 X 224)*/
VDP_REGD:   			DC.B 0x3F 								/*13: HORIZONTAL SCROLL TABLE AT VRAM ADDRESS 0xFC00*/
VDP_REGE:   			DC.B 0x00 								/*14: UNUSED*/
VDP_REGF:   			DC.B 0x02 								/*15: AUTOINCREMENT 2-BYTES*/
VDP_REG10:  			DC.B 0x01 								/*16: VERTICAL SCROLL 32, HORIZONTAL SCROLL 64*/
VDP_REG11:  			DC.B 0x00 								/*17: WINDOW PLANE X POS - LEFT*/
VDP_REG12:  			DC.B 0x00 								/*18: WINDOW PLANE Y POS 0 UP*/
VDP_REG13:  			DC.B 0xFF 								/*19: DMA LENGTH LOW BYTE*/
VDP_REG14:  			DC.B 0xFF 								/*20: DMA LENGTH HIGH BYTE*/
VDP_REG15:  			DC.B 0x00 								/*21: DMA SOURCE ADDRESS LOW BYTE*/
VDP_REG16:  			DC.B 0x00 								/*22: DMA SOURCE ADDRESS MID BYTE*/
VDP_REG17:  			DC.B 0x80 								/*23: DMA SOURCE ADDRESS HIGH BYTE*/
END: