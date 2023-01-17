
                        .section	.header
/* ------------------------------------------------------------- */
/* ROM HEADER - EXCEPTION HANDLERS */
/* ------------------------------------------------------------- */
HEADER:					DC.L   0x00FFFFFC        				/*INITIAL STACK POINTER POSITION*/
						DC.L   __START      					/*START OF THE PROGRAM*/
						DC.L   IGNORE_HANDLER   				/*BUS ERROR*/
						DC.L   IGNORE_HANDLER   				/*ADDRESS ERROR*/
						DC.L   IGNORE_HANDLER   				/*ILLEGAL INSTRUCTION*/
						DC.L   IGNORE_HANDLER   				/*DIVISION BY ZERO*/
						DC.L   IGNORE_HANDLER   				/*CHK EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAPV EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*PRIVILEDGE EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRACE EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*LINE-A EMULATOR */
						DC.L   IGNORE_HANDLER   				/*LINE-F EMULATOR */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*SPURIOUS EXCEPTION */ 
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 1 */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 2 */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 3 */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 4 (HORIZONTAL RETRACE INT.) */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 5 */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 6 (VERTICAL RETRACE INT.) */
						DC.L   IGNORE_HANDLER   				/*IRQ LEVEL 7 */
						DC.L   IGNORE_HANDLER   				/*TRAP #00 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #01 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #02 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #03 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #04 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #05 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #06 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #07 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #08 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #09 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #10 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #11 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #12 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #13 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #14 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*TRAP #15 EXCEPTION */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						DC.L   IGNORE_HANDLER   				/*UNUSED (RESERVED) */
						
/* ------------------------------------------------------------- */
/* ROM HEADER - GAME INFORMATION */
/* ------------------------------------------------------------- */
						.string "SEGA GENESIS    " 				/*CONSOLE NAME*/
						.string "AGMAT 2022.MAR  " 				/*COPYRIGHT HOLDER*/
						.string "LINKER SCRIPT                                   " /*DOMESTIC NAME*/
						.string "LINKER SCRIPT                                   " /*INTERNATIONAL NAME*/
						.string "AL 00000000-01  " 				/*VERSION NUMBER*/
						DC.W 0x0000              				/*CHECKSUM*/
						.string "J               " 				/*I/O SUPPORT*/
						DC.L 0x00000000          				/*START ADDRESS OF ROM*/
						DC.L 0x00400000              			/*END ADDRESS OF ROM*/
						DC.L 0x00FF0000          				/*START ADDRESS OF RAM*/
						DC.L 0x00FFFFFF          				/*END ADDRESS OF RAM*/
						DC.L 0x00000000          				/*SRAM ENABLED*/
						DC.L 0x00000000          				/*UNUSED*/
						DC.L 0x00000000          				/*START ADDRESS OF SRAM*/
						DC.L 0x00000000          				/*END ADDRESS OF SRAM*/
						DC.L 0x00000000          				/*UNUSED*/
						DC.L 0x00000000          				/*UNUSED*/
						.string "                " 				/*NOTES*/
						.string "JUE             " 				/*COUNTRY CODES*/
