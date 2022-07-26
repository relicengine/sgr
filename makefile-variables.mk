
###################################################################
# Overridable Variables
###################################################################
LTO_ENABLE						:= yes



###################################################################
# Internal Variables
###################################################################
### SGR Filepath Variables ########################################
# NOTE: path_sgr defined and exported from Makefile
path_build_tools				:= $(path_sgr)/build-tools
path_gcc						:= $(path_build_tools)/m68k-amigaos-toolchain/bin

path_sgr_dependencies			:= $(path_sgr)/dep
path_sgr_sources				:= $(path_sgr)/src
path_sgr_objects				:= $(path_sgr)/obj

path_sgr_objects_lto			:= $(path_sgr_objects)/lto
path_sgr_objects_release		:= $(path_sgr_objects)/release
path_sgr_objects_debug			:= $(path_sgr_objects)/debug
path_sgr_objects_assembly		:= $(path_sgr_objects)/asm

path_sgr_Z80					:= $(path_sgr)/Z80
path_sgr_Z80_dependencies		:= $(path_sgr_Z80)/dep
path_sgr_Z80_sources			:= $(path_sgr_Z80)/src
path_sgr_Z80_objects			:= $(path_sgr_Z80)/obj
path_sgr_Z80_programs			:= $(path_sgr_Z80)/programs

path_sgr_Z80_objects_release	:= $(path_sgr_Z80_objects)/release
path_sgr_Z80_objects_debug		:= $(path_sgr_Z80_objects)/debug
path_sgr_Z80_objects_assembly	:= $(path_sgr_Z80_objects)/asm


### Project Filepath Variables ####################################
path_project_dependencies		:= dep
path_project_sources			:= src
path_project_objects			:= obj

path_project_objects_lto		:= $(path_project_objects)/lto
path_project_objects_release	:= $(path_project_objects)/release
path_project_objects_debug		:= $(path_project_objects)/debug
path_project_objects_assembly	:= $(path_project_objects)/asm

path_project_Z80				:= Z80
path_project_Z80_programs		:= $(path_project_Z80)

path_project_bin				:= bin


### Dependencies ##################################################
dependencies_sgr				:= $(path_sgr_dependencies)/dependencies.d
dependencies_project			:= $(path_project_dependencies)/dependencies.d


### Source Files ##################################################
sources_sgr_C 					:= $(shell find $(path_sgr_sources) -name "*.c")
sources_sgr_assembly			:= $(shell find $(path_sgr_sources) -name "*.s")
sources_sgr_Z80_C 				:= $(shell find $(path_sgr_Z80_sources) -name "*.c")
sources_sgr_Z80_assembly		:= $(shell find $(path_sgr_Z80_sources) -name "*.s")

sources_project_C 				:= $(shell find $(path_project_sources) -name "*.c")
sources_project_assembly 		:= $(shell find $(path_project_sources) -name "*.s")


### Folders #######################################################
folders							:= $(path_sgr_dependencies)
folders							+= $(path_sgr_Z80_dependencies)
folders							+= $(path_project_dependencies)
folders							+= $(path_sgr_objects_lto)
folders							+= $(path_sgr_objects_release)
folders							+= $(path_sgr_objects_debug)
folders							+= $(path_sgr_objects_assembly)
folders							+= $(path_sgr_Z80_objects_release)
folders							+= $(path_sgr_Z80_objects_debug)
folders							+= $(path_sgr_Z80_objects_assembly)
folders							+= $(path_project_objects_lto)
folders							+= $(path_project_objects_release)
folders							+= $(path_project_objects_debug)
folders							+= $(path_project_objects_assembly)
folders							+= $(path_project_bin)



###################################################################
# Common Variables
###################################################################
CC								:= $(path_gcc)/m68k-amigaos-gcc
AS								:= $(path_gcc)/m68k-amigaos-as
AR								:= $(path_gcc)/m68k-amigaos-ar
OBJCPY							:= $(path_gcc)/m68k-amigaos-objcopy



###################################################################
# Target Specific Values
###################################################################
### Filepaths #####################################################
# 68000 object path
path_sgr_objects_target			:= $(path_sgr_objects_debug)
path_project_objects_target		:= $(path_project_objects_debug)
ifeq ($(MAKECMDGOALS),release)

	path_sgr_objects_target		:= $(path_sgr_objects_release)
	path_project_objects_target	:= $(path_project_objects_release)

	ifeq ($(LTO_ENABLE),yes)
		path_sgr_objects_target	:= $(path_sgr_objects_lto)
		path_project_objects_target		:= $(path_project_objects_lto)
	endif

endif

# Z80 object path
path_sgr_Z80_objects_target 	:= $(path_sgr_Z80_objects_debug)
ifeq ($(MAKECMDGOALS),release)

	path_sgr_Z80_objects_target := $(path_sgr_Z80_objects_release)

endif


### Object Files ##################################################
objects_sgr_C					:= $(addprefix $(path_sgr_objects_debug)/, $(notdir $(sources_sgr_C:.c=.o)))
objects_sgr_Z80_C				:= $(addprefix $(path_sgr_Z80_objects_debug)/, $(notdir $(sources_sgr_Z80_C:.c=.o)))
objects_sgr_assembly			:= $(addprefix $(path_sgr_objects_assembly)/, $(notdir $(sources_sgr_assembly:.s=.o)))
objects_sgr_Z80_assembly		:= $(addprefix $(path_sgr_Z80_objects_assembly)/, $(notdir $(sources_sgr_Z80_assembly:.s=.o)))

objects_project_assembly		:= $(addprefix $(path_project_objects_assembly)/, $(notdir $(sources_project_assembly:.s=.o)))

ifeq ($(MAKECMDGOALS),release)
	
	objects_sgr_C				:= $(addprefix $(path_sgr_objects_release)/, $(notdir $(sources_sgr_C:.c=.o)))
	objects_sgr_Z80_C			:= $(addprefix $(path_sgr_Z80_objects_release)/, $(notdir $(sources_sgr_Z80_C:.c=.o)))
	
	ifeq ($(LTO_ENABLE),yes)
		objects_sgr_C			:= $(addprefix $(path_sgr_objects_lto)/, $(notdir $(sources_sgr_C:.c=.o)))
	endif
	
endif


### Configuration Type ############################################
configuration_type				:= debug
ifeq ($(MAKECMDGOALS),release)

	configuration_type			:= release
	ifeq ($(LTO_ENABLE),yes)
		configuration_type		:= lto
	endif
	
endif

### Folder Dependencies ###########################################
folder_dependencies			:= $(path_sgr_dependencies) $(path_project_dependencies) $(path_sgr_Z80_dependencies)\
							$(path_sgr_objects_target) $(path_sgr_objects_assembly) $(path_sgr_Z80_objects_target)\
							$(path_sgr_Z80_objects_assembly) $(path_project_objects_target) $(path_project_objects_assembly)\
							$(path_project_bin)