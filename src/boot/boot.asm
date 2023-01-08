
                        .section .boot
                        .global __START

VDP_CONTROL				=		0x00C00004 						/*VDP CONTROL ADDRESS */
VDP_DATA				= 		0x00C00000 						/*VDP DATA ADDRESS */
VERSION					= 		0x00A10001						/*ADDRESS OF GENESIS VERSION*/
TMSS					=		0x00A14000						/*ADDRESS OF TMSS SIGNATURE*/
Z80BUS					=		0x00A11100						/*ADDRESS FOR REQUESTING ACCESS TO Z80 BUS*/
Z80RESET				= 		0x00A11200						/*ADDRESS FOR RESETING Z80*/
Z80_ADDR_SPACE			=		0x00A00000						/*Z80 ADDRESSING SPACE*/
VDP_REG_BASE			=		0x00008000						/*THE BASE ADDRESS OF THE VDP*/

/* -------------------------------------------------------------*/
/* HARDWARE INITIALIZATION*/
/* -------------------------------------------------------------*/
__START:				MOVE.W 	#0x2700,SR     					/*DISABLE INTURUPTS*/
						MOVEA.L	SP,A6							/*SET BASE POINTER TO SAME A STACK POINTER*/
/* --- TMSS ----------------------------------------------------*/
						MOVE.B 	VERSION,D0  					/*MOVE GENESIS HARDWARE VERSION TO D0 (***TAKE A LOOK AT THIS***)*/
						ANDI.B 	#0x0F,D0       					/*MASK OFF THE VERSION WHICH IS STORED IN THE LOWER 4 BITS*/
						BEQ     SKIP_TMSS      	 				/*IF THE VERSION IS 0, SKIP THE TMSS SIGNATURE*/
						MOVE.L  #0,TMSS					/*OTHERWISE, MOVE STRING "SEGA" TO 0xA14000*/
/* --- Z80 INIT ------------------------------------------------*/
SKIP_TMSS:				MOVE.W  #0x0100,Z80BUS 					/*REQUEST ACCESS TO Z80 BUS*/
						MOVE.W  #0x0100,Z80RESET					/*HOLD Z80 IN A RESET STATE*/
Z80WAIT:				BTST    #0x0,Z80BUS+1   					/*CHECK IF WE HAVE ACCESS TO Z80 BUS YET*/
						BNE     Z80WAIT         				/*WAIT FOR BUS TO GRANT ACCESS*/
						MOVEA.L #Z80_ADDR_SPACE,A1 				/*COPY Z80 RAM ADDRESS TO A1*/
						MOVE.L  #0x00C30000,(A1) 				/*COPY DATA AND INCREMENT A1*/
						MOVE.W  #0x0000,Z80RESET 				/*RELEASE RESET STATE*/
						MOVE.W  #0x0000,Z80BUS 					/*RELEASE CONTROL OF BUS*/
/* --- VDP INIT ------------------------------------------------*/
						MOVEA.L #VDP_REGISTERS,A0 				/*LOAD THE ADDRESS OF THE FIRST VDP REGISTER*/
						MOVEQ.L #0x18,D0         				/*24 REGISTERS TO INITIALIZE USED IN LOOP BELOW*/
						MOVE.L  #VDP_REG_BASE,D1 				/*PUT REFERENCE TO VDP REGISTER 0 IN D1*/
VDP_INIT:				MOVE.B  (A0)+,D1        				/*COPY REGISTER VALUES TO D1*/
						MOVE.W  D1,VDP_CONTROL  				/*INIT REGISTER*/
						ADDI.W  #0x0100,D1       				/*INCREMENT REGISTER NUMBER*/
						DBRA    D0,VDP_INIT						/*LOOP THROUGH ALL REGISTERS*/
/* --- CLEAR VRAM (REMOVE LISENCING SCREEN) --------------------*/
						MOVE.L	#0x40000000,VDP_CONTROL 			/*SET VDP TO VRAM WRITE*/
						MOVE.L	#0x00007FFF,D0					/*USE D0 AS INDEX VARIABLE*/
VRAM_CLEAR:				MOVE.W	#0,VDP_DATA						/*WRITE 0 TO CURRENT VRAM ADDRESS*/
						DBRA	D0,VRAM_CLEAR					/*LOOP UNTIL ALL 64K OF MEMORY IS CLEARED*/
/* --- CLEAR RAM -----------------------------------------------*/
						MOVE.W	#0x3FFF,D0						/*USE D0 TO COUNT NUMBER OF LONGWORDS TO CLEAR (64K = 16,384 = 0x3FF LONGWORDS)*/
						MOVEQ.L	#0x00000000,D1					/*USE D1 TO WRITE 0s TO RAM*/
						LEA		0xFF0000,A0						/*USE A0 TO POINT TO START OF GLOBAL DATA SECTION IN RAM*/
RAM_CLEAR:				MOVE.L	D1,(A0)+						/*SET EACH MEMORY ADDRESS TO 0*/
						DBRA	D0,RAM_CLEAR					/*CONTINUE CLEARING MEMORY*/
/* --- COPY GLOBAL VARIABLES TO RAM ----------------------------*/
						MOVE.W	#__sdata,D0						/*STORE NUMBER OF BYTES TO COPY IN D0*/
						BEQ		SKIP_COPY						/*IF NO GLOBAL VARIABLES THEN DON'T COPY*/
						LEA		__stext,A0						/*LOAD ROM ADDRESS WHERE .data SECTION STARTS INTO A0*/
						LEA		0xFF0000,A1						/*LOAD RAM ADDRESS WHERE GLOBAL VARIABLES START INTO A1*/
						LSR.W	#1,D0							/*TURN D0 INTO WORD COUNT INSTEAD OF BYTE COUNT*/
						SUBQ.W	#1,D0							/*SUBTRACT 1 FROM D0 FOR DBRA INSTRUCTION BELOW*/
COPY_GLOBALS:			MOVE.W	(A0)+,(A1)+						/*COPY WORD TO RAM*/
						DBRA	D0,COPY_GLOBALS					/*CONTINUE UNTIL ALL WORDS ARE COPIED*/
SKIP_COPY:
						JMP		main
						
/*
/////////////////////////////////////////////////////////////////
/// INCLUDES                                                    /
/////////////////////////////////////////////////////////////////
#include <driver/System.asm>


/////////////////////////////////////////////////////////////////
/// ASSEMBLER DIRECTIVES                                        /
/////////////////////////////////////////////////////////////////
.section .boot
.global  __START


/////////////////////////////////////////////////////////////////
/// BOOT CODE                                                   /
/////////////////////////////////////////////////////////////////
__START:                DISABLE_INTERRUPTS

                        LEA.L   __SYSTEM_POINTERS(PC),A6
                        MOVEM.L (A6)+,A0-A5/D6-D7

                        TST.L   1(A0)
                        BNE.B     __VDP_INIT
                        TST.W   5(A0)
                        BNE.B     __VDP_INIT

                        MOVE.B  (A0),D0
                        ANDI.B  #0x0F,D0
                        BEQ.B   __VDP_INIT
                        MOVE.L  #0x53454741,(A3)

__VDP_INIT:
__Z80_INIT:
__RAM_INIT:
__GLOBAL_VAR_INIT:
__JOYPAD_INIT:


/////////////////////////////////////////////////////////////////
/// HARDWARE INITIALIZATION VALUES                              /
/////////////////////////////////////////////////////////////////
__SYSTEM_POINTERS:
__VERSION:              DC.L    VERSION+1
__Z80_BUS_REQUEST:      DC.L    Z80_BUS_REQUEST
__Z80_RESET:            DC.L    Z80_RESET
__TMSS:                 DC.L    TMSS
__VDP_DATA:             DC.L    VDP_DATA
__VDP_CONTROL:          DC.L    VDP_CONTROL
__VDP_REG_COMMAND:      DC.L    0x00008000
__VDP_REG_INCREMENT:    DC.L    0x00000100
*/