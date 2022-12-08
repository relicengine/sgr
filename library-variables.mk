
include $(path_sgr)/variables.mk

###################################################################
# Filepath Variables
###################################################################
path_build_tools				:= ~/rrengine-build-tools
path_68k_toolchain				:= $(path_build_tools)/m68k-amigaos-toolchain

path_sgr_68k_dependencies		:= $(path_sgr)/dep
path_sgr_68k_sources			:= $(path_sgr)/src
path_sgr_68k_include			:= $(path_sgr)/include

path_sgr_68k_objects_debug		:= $(path_sgr)/obj/debug
path_sgr_68k_objects_release	:= $(path_sgr)/obj/release
path_sgr_68k_objects_lto		:= $(path_sgr)/obj/release/lto
path_sgr_68k_objects			:= $(path_sgr_68k_objects_debug)
ifeq ($(MAKECMDGOALS),release)
	ifneq ($(USE_LTO),false)
		path_sgr_68k_objects	:= $(path_sgr_68k_objects_lto)
	else
		path_sgr_68k_objects	:= $(path_sgr_68k_objects_release)
	endif
endif


###################################################################
# SGR Dependency, Source and Object Files
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
# SGR Folder Dependencies
###################################################################
folder_prerequisites			:= $(path_sgr_68k_dependencies)
folder_prerequisites			+= $(path_sgr_68k_objects)


###################################################################
# Externally Overridable Variables
###################################################################
CC								:= $(path_68k_toolchain)/bin/m68k-amigaos-gcc
CPP								:= $(path_68k_toolchain)/bin/m68k-amigaos-cpp
AS								:= $(path_68k_toolchain)/bin/m68k-amigaos-as
AR								:= $(path_68k_toolchain)/bin/m68k-amigaos-ar
OBJCPY							:= $(path_68k_toolchain)/bin/m68k-amigaos-objcopy
USE_LTO							:= true
