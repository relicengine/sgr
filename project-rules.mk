
include 	$(path_sgr)/project-variables.mk
-include 	$(dependencies_project_68k)

###################################################################
# Rules - Build Configurations
###################################################################
.PHONY: 	release debug build

lto:		build
release: 	build
debug: 		build

build: 		$(folder_prerequisites) \
			$(subst $(space_character_delimiter),\ ,$(objects_project_68k_C)) \
			$(subst $(space_character_delimiter),\ ,$(objects_project_68k_ASM)) \
			$(path_project_bin)/rom.bin


###################################################################
# Rules - Build Binary
###################################################################
$(path_project_bin)/rom.bin: $(path_project_bin)/rom.out
	$(OBJCPY) -O binary $< $@

$(path_project_bin)/rom.out: $(objects_sgr_68k) $(objects_project_68k)
	$(CC) $(LTO_FLAG) -nostdlib -Wl,-T $(path_sgr)/link.lds -Wl,--gc-sections,-Map=$(path_project_bin)/rom.map -o $(path_project_bin)/rom.out $(objects_sgr_68k) $(objects_project_68k)
	$(OBJDUMP) -d $(path_project_bin)/rom.out > $(path_project_bin)/rom.dump


###################################################################
# Rules - Setup Prerequisite Folders
###################################################################
$(folder_prerequisites):
	mkdir -p "$@"


###################################################################
# Rules - Template Rules
###################################################################

# Generate Rule for Each 68k C Source file
# $(1) = The 68k object file to compile from C source.
# $(2) = The corresponding C source file the object depends on.
# $(3) = The resulting dependency file. In the dependency folder.
define OBJECT_PROJECT_68K_C_TEMPLATE

$(path_project_68k_objects)/$(1): $(2)
	$(CC) -c $(CFLAGS_68K) -I $(path_project_68k_include) -I $(path_sgr_68k_include) -o "$$@" "$$<"
	makedepend -f- -o .c -I $(path_project_68k_include) -I $(path_sgr_68k_include) "$$<" > $(3)
	sed -i'' "s,$(2),$(path_project_68k_objects_debug)/$(1)," $(3)
	awk "NR>=3 && NR<=3" $(3) | sed "s,$(path_project_68k_objects_debug)/$(1),$(path_project_68k_objects_release)/$(1)," >> $(3)
	awk "NR>=3 && NR<=3" $(3) | sed "s,$(path_project_68k_objects_debug)/$(1),$(path_project_68k_objects_lto)/$(1)," >> $(3)
	sed -i'' "s, ,\\\ ,g" $(3)
	sed -i'' "s,:\\\ ,: ,g" $(3)

endef
$(eval $(foreach object_index, \
                 $(shell seq $(words $(objects_project_68k_C))), \
				 $(call OBJECT_PROJECT_68K_C_TEMPLATE,$(subst $(space_character_delimiter),\ ,$(notdir $(word $(object_index), $(objects_project_68k_C)))),$(subst $(space_character_delimiter),\ ,$(word $(object_index), $(sources_project_68k_C))),$(subst $(space_character_delimiter),\ ,$(path_project_68k_dependencies)/$(notdir $(word $(object_index),$(sources_project_68k_C:.c=.c.d))))\
				  )\
		)\
)

# Generate Rule for Each 68k Assembly Source file
# $(1) = The 68k object file to compile from assembler source.
# $(2) = The corresponding assembler source file the object depends on.
# $(3) = The resulting dependency file. In the dependency folder.
define OBJECT_PROJECT_68K_ASM_TEMPLATE

$(path_project_68k_objects)/$(1): $(2)
	$(CPP) -P -I $(path_project_68k_include) -I $(path_sgr_68k_include) "$$<" | $(AS) $(ASFLAGS_68K) -I $(path_project_68k_include) -I $(path_sgr_68k_include) -o "$$@" -
	makedepend -f- -o .asm -I $(path_project_68k_include) -I $(path_sgr_68k_include) "$$<" > $(3)
	sed -i='' "s,$(2),$(path_project_68k_objects_debug)/$(1)," $(3)
	awk "NR>=3 && NR<=3" $(3) | sed "s,$(path_project_68k_objects_debug)/$(1),$(path_project_68k_objects_release)/$(1)," >> $(3)
	awk "NR>=3 && NR<=3" $(3) | sed "s,$(path_project_68k_objects_debug)/$(1),$(path_project_68k_objects_lto)/$(1)," >> $(3)
	sed -i'' "s, ,\\\ ,g" $(3)
	sed -i'' "s,:\\\ ,: ,g" $(3)

endef
$(eval $(foreach object_index, \
                 $(shell seq $(words $(objects_project_68k_ASM))), \
				 $(call OBJECT_PROJECT_68K_ASM_TEMPLATE,$(subst $(space_character_delimiter),\ ,$(notdir $(word $(object_index), $(objects_project_68k_ASM)))),$(subst $(space_character_delimiter),\ ,$(word $(object_index), $(sources_project_68k_ASM))),$(subst $(space_character_delimiter),\ ,$(path_project_68k_dependencies)/$(notdir $(word $(object_index),$(sources_project_68k_ASM:.asm=.asm.d))))\
				  )\
		)\
)

#-Wa,$(shell echo $(ASFLAGS_68K) | sed "s/ /,/g")