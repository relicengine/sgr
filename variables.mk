
SHELL 							:= /bin/bash
space_character_delimiter		:= ?
#PRINT = @echo -e "\e[1;34mBuilding $<\e[0m"


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

ifeq ($(shell uname -m),x86_64)
	ARCH						:= 64-bit
else ifeq ($(shell uname -m),i686)
	ARCH						:= 32-bit
else ifeq ($(shell uname -m),i386)
	ARCH						:= 32-bit
else
	ARCH						:= unsupported-arch
endif


###################################################################
# SGR Library Filepath Variables
###################################################################
path_build_tools				:= /home/$(shell whoami)/rrengine-build-tools
ifeq ($(OS),macOS) 
	path_build_tools 			:= /Users/$(shell whoami)/rrengine-build-tools
endif
path_68k_toolchain				:= $(path_build_tools)/m68k-elf-toolchain

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

ifeq ($(MAKECMDGOALS),lto)
	path_project_68k_objects 	:= $(path_project_68k_objects_lto)
else ifeq ($(MAKECMDGOALS),clean-lto)
	path_project_68k_objects 	:= $(path_project_68k_objects_lto)
else ifeq ($(MAKECMDGOALS),release)
	path_project_68k_objects 	:= $(path_project_68k_objects_release)
else ifeq ($(MAKECMDGOALS),clean-release)
	path_project_68k_objects 	:= $(path_project_68k_objects_release)
else ifeq ($(MAKECMDGOALS),debug)
	path_project_68k_objects	:= $(path_project_68k_objects_debug)
else ifeq ($(MAKECMDGOALS),clean-debug)
	path_project_68k_objects	:= $(path_project_68k_objects_debug)
endif


###################################################################
# Externally Overridable Variables
###################################################################
# Programs for building SGR sources
CC								:= $(path_68k_toolchain)/bin/m68k-elf-gcc
CPP								:= $(path_68k_toolchain)/bin/m68k-elf-cpp
AS								:= $(path_68k_toolchain)/bin/m68k-elf-as
AR								:= $(path_68k_toolchain)/bin/m68k-elf-gcc-ar
OBJCPY							:= $(path_68k_toolchain)/bin/m68k-elf-objcopy
OBJDUMP							:= $(path_68k_toolchain)/bin/m68k-elf-objdump
RM								:= rm
MKDIR							:= mkdir
MAKEDEPEND						:= makedepend
AWK								:= awk
TAR								:= tar
WGET							:= wget
SED								:= sed
ifeq ($(OS),macOS)
	SED							:= gsed
endif

# C compiler flags to use with gcc when building sources
DEFAULT_CFLAGS_68K				:= $(USER_CFLAGS) -m68000 -fno-leading-underscore -mregparm=4 -fdata-sections -ffunction-sections -fomit-frame-pointer -nostdlib -Wall -Wextra -Wno-shift-negative-value -Wno-unused-parameter -fno-builtin
ifeq ($(MAKECMDGOALS),lto)
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O3 -flto
else ifeq ($(MAKECMDGOALS),release)
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O3
else
	CFLAGS_68K 					:= $(DEFAULT_CFLAGS_68K) -O1
endif

# ASM compiler flags to use with as when building sources
DEFAULT_ASFLAGS_68K				:= $(USER_ASFLAGS) --register-prefix-optional
ifeq ($(MAKECMDGOALS),lto)
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
else ifeq ($(MAKECMDGOALS),release)
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
else
	ASFLAGS_68K 				:= $(DEFAULT_ASFLAGS_68K)
endif
