ENTRY(START)

MEMORY
{
	rom : ORIGIN = 0x00000000, LENGTH = 0x00400000
	ram : ORIGIN = 0x00FF0000, LENGTH = 0x00010000
}

SECTIONS
{
	.text 0x00000000 : SUBALIGN(2) {
  		KEEP(*(.header))
  		*(.boot)
		*(.text*)
  		*(.vdp)
	} > rom
	_stext = SIZEOF(.text);
	
	.data 0x00FF0000 : AT(ADDR(.text) + SIZEOF(.text)) {
	  *(.data)
	  *(.asmdata)
	  FILL(0x00)
	  . = ALIGN(2);
	} > ram
	_sdata = SIZEOF(.data);
	
	.bss 0xFF0000 + SIZEOF(.data) : {
		*(.bss) 
	} > ram
}
