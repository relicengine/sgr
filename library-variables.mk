
include $(path_sgr)/variables.mk


###################################################################
# SGR Library Dependency, Source and Object Files
###################################################################
# These two variables find all .c and .asm files in the
# source folder. Then it replaces any spaces in the filepaths
# with a replacement character so it may be processed by
# Make's string functions later. The can't handle spaces. Not
# even escaped ones.
sources_sgr_68k_C				:= $(shell find $(path_sgr_68k_sources) -type d -name boot -prune \
											-o -type f -regex ".*.c" -print | \
											sed "s, ,$(space_character_delimiter),g" \
									)
sources_sgr_68k_ASM				:= $(shell find $(path_sgr_68k_sources) -type d -name boot -prune \
											-o  -type f -regex ".*.asm" -print | \
											sed "s, ,$(space_character_delimiter),g" \
									)

# Similarly, these two variables take the source file
# names and transform them into object file paths with
# replacement characters for any spaces in the path.
objects_sgr_68k_C				:= $(addprefix $(shell \
										echo $(path_sgr_68k_objects) | \
										sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_sgr_68k_C:.c=.c.o) \
										) \
									)
objects_sgr_68k_ASM				:= $(addprefix $(shell \
										echo $(path_sgr_68k_objects) | \
										sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_sgr_68k_ASM:.asm=.asm.o) \
										) \
									)

# Find all dependency files to be included in the
# file containing the SGR library build rules.
dependencies_sgr_68k			:= $(shell find $(path_sgr_68k_dependencies) -type f -regex ".*.d" 2> /dev/null | sed "s, ,\\\ ,g")


###################################################################
# SGR Folder Dependencies
###################################################################
folder_prerequisites			:= $(path_sgr_68k_dependencies)
folder_prerequisites			+= $(path_sgr_68k_objects)

