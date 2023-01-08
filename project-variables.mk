
include $(path_sgr)/variables.mk

###################################################################
# SGR Project Dependency, Source and Object Files
###################################################################
# Copy the boot files from SGR into project source without
# overwriting files of the same name already in there.
ifeq ($(MAKECMDGOALS),$(filter $(MAKECMDGOALS),lto release debug))
$(shell mkdir $(path_project_68k_sources)/boot 2> /dev/null && cp -n $(path_sgr_68k_sources)/boot/* $(path_project_68k_sources)/boot)
endif

# These two variables find all .c and .asm files in the
# project source folder. Then it replaces any spaces in the filepaths
# with a replacement character so it may be processed by
# Make's string functions later. The can't handle spaces. Not
# even escaped ones.
sources_project_68k_C				:= $(shell \
											find $(path_project_68k_sources) -type f -regex ".*.c" | \
											sed "s, ,$(space_character_delimiter),g" \
										)
sources_project_68k_ASM				:= $(shell \
											find $(path_project_68k_sources) -type f -regex ".*.asm" | \
											sed "s, ,$(space_character_delimiter),g" \
										)

# Similarly, these two variables take the source file
# names and transform them into object file paths with
# replacement characters for any spaces in the path.
objects_project_68k_C				:= $(addprefix $(shell \
												echo $(path_project_68k_objects) | \
												sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_project_68k_C:.c=.c.o) \
											) \
										)
objects_project_68k_ASM				:= $(addprefix $(shell \
												echo $(path_project_68k_objects) | \
												sed "s, ,$(space_character_delimiter),g")/, $(notdir $(sources_project_68k_ASM:.asm=.asm.o) \
											) \
										)
objects_project_68k					:= $(subst $(space_character_delimiter),\ ,$(objects_project_68k_C)) $(subst $(space_character_delimiter),\ ,$(objects_project_68k_ASM))

# Find all dependency files to be included in the
# file containing the SGR library build rules.
dependencies_project_68k			:= $(shell find $(path_project_68k_dependencies) -type f -regex ".*.d" 2> /dev/null | sed "s, ,\\\ ,g")


###################################################################
# SGR Library Dependency, Source and Object Files
###################################################################
objects_sgr_68k						:= $(shell find $(path_sgr_68k_objects) -type f -regex ".*.o" 2> /dev/null | sed "s, ,\\\ ,g")


###################################################################
# SGR Project Binary Path
###################################################################
# The proper binary depending on build configuration
ifeq ($(MAKECMDGOALS),lto)
	path_project_bin				:= bin/lto
else ifeq ($(MAKECMDGOALS),clean-lto)
	path_project_bin				:= bin/lto
else ifeq ($(MAKECMDGOALS),release)
	path_project_bin				:= bin/release
else ifeq ($(MAKECMDGOALS),clean-release)
	path_project_bin				:= bin/release
else ifeq ($(MAKECMDGOALS),debug)
	path_project_bin				:= bin/debug
else ifeq ($(MAKECMDGOALS),clean-debug)
	path_project_bin				:= bin/debug
endif


###################################################################
# SGR Folder Dependencies
###################################################################
folder_prerequisites				:= $(path_project_68k_dependencies)
folder_prerequisites				+= $(path_project_68k_objects)
folder_prerequisites				+= $(path_project_bin)