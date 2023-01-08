ENTRY(__START)

MEMORY
{
	rom (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00400000
	ram (rwx) : ORIGIN = 0x00FF0000, LENGTH = 0x00010000
}

SECTIONS
{
	.text 0x00000000 : SUBALIGN(2) {
		KEEP(*(.header))
		*(.boot)
		KEEP(*(.text.startup.main))
		KEEP(*(.text.main))
		*(.text*)
		*(.vdp)
		*(.rodata .rodata.*)
	} > rom
	__stext = SIZEOF(.text);
	
	.data 0x00FF0000 : AT( ADDR(.text) + SIZEOF(.text) ) {
		*(.data*)
		*(.asmdata)
		FILL(0x00)
		. = ALIGN(2);
	} > ram
	__sdata = SIZEOF(.data);

	.bss 0x00FF0000 + SIZEOF(.data) : {
		*(.bss) 
	} > ram
}
