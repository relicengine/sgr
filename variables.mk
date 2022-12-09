
space_character_delimiter		:= ?
#PRINT = @echo -e "\e[1;34mBuilding $<\e[0m"

###################################################################
# SGR Library Filepath Variables
###################################################################
path_build_tools				:= ~/rrengine-build-tools
path_68k_toolchain				:= $(path_build_tools)/m68k-amigaos-toolchain

path_sgr_68k_dependencies		:= $(path_sgr)/dep
path_sgr_68k_sources			:= $(path_sgr)/src
path_sgr_68k_include			:= $(path_sgr)/include

path_sgr_68k_objects_debug		:= $(path_sgr)/obj/debug
path_sgr_68k_objects_release	:= $(path_sgr)/obj/release
path_sgr_68k_objects_lto		:= $(path_sgr)/obj/lto
path_sgr_68k_objects			:= $(path_sgr_68k_objects_debug)
ifeq ($(MAKECMDGOALS),lto)
	path_sgr_68k_objects		:= $(path_sgr_68k_objects_lto)
else ifeq ($(MAKECMDGOALS),release)
	path_sgr_68k_objects		:= $(path_sgr_68k_objects_release)
endif


###################################################################
# SGR Project Filepath Variables
###################################################################
path_project_68k_dependencies	:= dep
path_project_68k_sources		:= src
path_project_68k_include		:= include

path_project_68k_objects_debug	:= obj/debug
path_project_68k_objects_release:= obj/release
path_project_68k_objects_lto	:= obj/lto
path_project_68k_objects		:= $(path_project_68k_objects_debug)
ifeq ($(MAKECMDGOALS),lto)
		path_project_68k_objects := $(path_project_68k_objects_lto)
else ifeq ($(MAKECMDGOALS),release)
		path_project_68k_objects := $(path_project_68k_objects_release)
endif

###################################################################
# Externally Overridable Variables
###################################################################
CC								:= $(path_68k_toolchain)/bin/m68k-amigaos-gcc
CPP								:= $(path_68k_toolchain)/bin/m68k-amigaos-cpp
AS								:= $(path_68k_toolchain)/bin/m68k-amigaos-as
AR								:= $(path_68k_toolchain)/bin/m68k-amigaos-ar
OBJCPY							:= $(path_68k_toolchain)/bin/m68k-amigaos-objcopy
OBJDUMP							:= $(path_68k_toolchain)/bin/m68k-amigaos-objdump
RM								:= rm

DEFAULT_CFLAGS_68K				:= $(USER_CFLAGS) -mregparm=4 -m68000 -ffunction-sections -fomit-frame-pointer -fno-leading-underscore -nostdlib -Wall -Wextra -Wno-shift-negative-value -Wno-unused-parameter -fno-builtin
ifeq ($(MAKECMDGOALS),lto)
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O3 -flto
else ifeq ($(MAKECMDGOALS),release)
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O3
else
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O1
endif

DEFAULT_ASFLAGS_68K				:= $(USER_ASFLAGS) --register-prefix-optional
ifeq ($(MAKECMDGOALS),lto)
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
else ifeq ($(MAKECMDGOALS),release)
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
else
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
endif