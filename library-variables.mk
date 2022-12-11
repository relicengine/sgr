
include $(path_sgr)/variables.mk


###################################################################
# SGR Library Dependency, Source and Object Files
###################################################################
# These two variables find all .c and .asm files in the
# source folder. Then it replaces any spaces in the filepaths
# with a replacement character so it may be processed by
# Make's string functions later. The can't handle spaces. Not
# even escaped ones.
sources_sgr_68k_C				:= $(shell find $(path_sgr_68k_sources) -type f -regex ".*.c" | sed "s, ,$(space_character_delimiter),g")
sources_sgr_68k_ASM				:= $(shell find $(path_sgr_68k_sources) -type f -regex ".*.asm" | sed "s, ,$(space_character_delimiter),g")

# Similarly, these two variables take the source file
# names and transform them into object file paths with
# replacement characters for any spaces in the path.
objects_sgr_68k_C				:= $(addprefix $(shell echo $(path_sgr_68k_objects) | sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_sgr_68k_C:.c=.c.o)))
objects_sgr_68k_ASM				:= $(addprefix $(shell echo $(path_sgr_68k_objects) | sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_sgr_68k_ASM:.asm=.asm.o)))

# Find all dependency files to be included in the
# file containing the SGR library build rules.
dependencies_sgr_68k			:= $(shell find $(path_sgr_68k_dependencies) -type f -regex ".*.d" 2> /dev/null | sed "s, ,\\\ ,g")


###################################################################
# Operating System and Processor Architecture
###################################################################
ifeq ($(shell echo $$OSTYPE | grep -o cygwin),cygwin)
	OS							:= windows
else ifeq ($(shell echo $$OSTYPE | grep -o darwin),darwin)
	OS							:= macOS
else ifeq ($(shell echo $$OSTYPE | grep -o linux),linux)
	OS							:= linux
else
	OS							:= unsupported-os
endif

ifeq ($(shell arch),x86_64)
	ARCH						:= 64-bit
else ifeq ($(shell arch),i686)
	ARCH						:= 32-bit
else
	ARCH						:= unsupported-arch
endif


###################################################################
# SGR Folder Dependencies
###################################################################
folder_prerequisites			:= $(path_sgr_68k_dependencies)
folder_prerequisites			+= $(path_sgr_68k_objects)

