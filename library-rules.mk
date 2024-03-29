
include $(path_sgr)/library-variables.mk
-include $(dependencies_sgr_68k)


###################################################################
# Rules - Build Configurations
###################################################################
.PHONY: 	lto release debug build clean clean-lto clean-release clean-debug

lto:		build
release:	build
debug: 		build

build: 		$(folder_prerequisites) \
			$(path_build_tools) \
			$(subst $(space_character_delimiter),\ ,$(objects_sgr_68k_C)) \
			$(subst $(space_character_delimiter),\ ,$(objects_sgr_68k_ASM))

clean:
	$(RM) -rf $(path_sgr)/obj $(path_sgr)/dep

clean-lto clean-release clean-debug:
	$(RM) -rf $(path_sgr_68k_objects)


###################################################################
# Rules - Download Build Tools & Prerequisites
###################################################################
$(path_build_tools): $(path_68k_toolchain)

$(path_68k_toolchain):
	$(WGET) -P $(path_build_tools) https://rrgamescdn.github.io/sgr-bucket/build-tools/$(OS)/$(ARCH)/m68k-elf-toolchain.tar.xz
	$(TAR) -xf $(path_build_tools)/m68k-elf-toolchain.tar.xz -C $(path_build_tools)
	$(RM) -f $(path_build_tools)/m68k-elf-toolchain.tar.xz


###################################################################
# Rules - Setup Prerequisite Folders
###################################################################
$(folder_prerequisites):
	$(MKDIR) -p "$@"


###################################################################
# Rules - Template Rules
###################################################################
# Generate Rule for Each 68k C Source file
# $(1) = The 68k object file to compile from C source.
# $(2) = The corresponding C source file the object depends on.
# $(3) = The resulting dependency file. In the dependency folder.
define OBJECT_SGR_68K_C_TEMPLATE

$(path_sgr_68k_objects)/$(1): $(2)
	$(CC) -c $(CFLAGS_68K) -Wa,--register-prefix-optional -I $(path_sgr_68k_include) -o "$$@" "$$<"
	$(MAKEDEPEND) -f- -o .c -I $(path_sgr_68k_include) "$$<" > $(3)
	$(SED) -i "s,$(2),$(path_sgr_68k_objects_debug)/$(1)," $(3)
	$(AWK) "NR>=3 && NR<=3" $(3) | $(SED) "s,$(path_sgr_68k_objects_debug)/$(1),$(path_sgr_68k_objects_release)/$(1)," >> $(3)
	$(AWK) "NR>=3 && NR<=3" $(3) | $(SED) "s,$(path_sgr_68k_objects_debug)/$(1),$(path_sgr_68k_objects_lto)/$(1)," >> $(3)
	$(SED) -i "s, ,\\\ ,g" $(3)
	$(SED) -i "s,:\\\ ,: ,g" $(3)

endef

ifneq ($(words $(objects_sgr_68k_C)),0)
$(eval $(foreach object_index, \
                 $(shell seq $(words $(objects_sgr_68k_C))), \
				 $(call OBJECT_SGR_68K_C_TEMPLATE,$(subst $(space_character_delimiter),\ ,$(notdir $(word $(object_index), $(objects_sgr_68k_C)))),$(subst $(space_character_delimiter),\ ,$(word $(object_index), $(sources_sgr_68k_C))),$(subst $(space_character_delimiter),\ ,$(path_sgr_68k_dependencies)/$(notdir $(word $(object_index),$(sources_sgr_68k_C:.c=.c.d))))\
				  )\
		)\
)
endif

# Generate Rule for Each 68k Assembly Source file
# $(1) = The 68k object file to compile from assembler source.
# $(2) = The corresponding assembler source file the object depends on.
# $(3) = The resulting dependency file. In the dependency folder.
define OBJECT_SGR_68K_ASM_TEMPLATE

$(path_sgr_68k_objects)/$(1): $(2)
	$(CPP) -P -I $(path_sgr_68k_include) "$$<" | $(AS) $(ASFLAGS_68K) -I $(path_sgr_68k_include) -o "$$@" -
	$(MAKEDEPEND) -f- -o .asm -I $(path_sgr_68k_include) "$$<" > $(3)
	$(SED) -i "s,$(2),$(path_sgr_68k_objects_debug)/$(1)," $(3)
	$(AWK) "NR>=3 && NR<=3" $(3) | $(SED) "s,$(path_sgr_68k_objects_debug)/$(1),$(path_sgr_68k_objects_release)/$(1)," >> $(3)
	$(AWK) "NR>=3 && NR<=3" $(3) | $(SED) "s,$(path_sgr_68k_objects_debug)/$(1),$(path_sgr_68k_objects_lto)/$(1)," >> $(3)
	$(SED) -i "s, ,\\\ ,g" $(3)
	$(SED) -i "s,:\\\ ,: ,g" $(3)

endef

ifneq ($(words $(objects_sgr_68k_ASM)),0)
$(eval $(foreach object_index, \
                 $(shell seq $(words $(objects_sgr_68k_ASM))), \
				 $(call OBJECT_SGR_68K_ASM_TEMPLATE,$(subst $(space_character_delimiter),\ ,$(notdir $(word $(object_index), $(objects_sgr_68k_ASM)))),$(subst $(space_character_delimiter),\ ,$(word $(object_index), $(sources_sgr_68k_ASM))),$(subst $(space_character_delimiter),\ ,$(path_sgr_68k_dependencies)/$(notdir $(word $(object_index),$(sources_sgr_68k_ASM:.asm=.asm.d))))\
				  )\
		)\
)
endif
