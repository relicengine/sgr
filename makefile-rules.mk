
###################################################################
# Variable Definitions
###################################################################
include $(path_sgr)/makefile-variables.mk

###################################################################
# .PHONY Rules
###################################################################
.PHONY: release debug god clean


### Build Configurations ##########################################
# Configuration specific variables
release: CFLAGS := -I $(path_sgr)/include -I include

debug: CFLAGS := -I $(path_sgr)/include -I include

# Configuration recipies
release debug: $(folder_dependencies)\
               $(path_build_tools)/m68k-amigaos-toolchain\
               $(path_project_bin_release)/rom.bin

god: /home/Matthew/RetroRevivalGames/sgr/obj/debug/otherfolder/main.o
	@echo $(info $(call TEMPLATE_RULE_,/home/Matthew/RetroRevivalGames/sgr/obj/debug/otherfolder/main.o))

/home/Matthew/RetroRevivalGames/sgr/obj/%.o:
	@echo Stem is: $*

### Cleanup #######################################################
clean:
	rm -rf $(path_sgr_dependencies)
	rm -rf $(path_sgr_Z80_dependencies)
	rm -rf $(path_project_dependencies)
	rm -rf $(path_sgr_objects)
	rm -rf $(path_sgr_Z80_objects)
	rm -rf $(path_project_objects)
	rm -rf $(path_project_bin)
	rm -rf $(path_build_tools)



###################################################################
# Explicit Rules
###################################################################
### Project Rules #################################################
$(path_project_bin_lto)/rom.bin: $(path_project_bin_lto)/rom.out
	$(OBJCPY) -O binary $< $@

$(path_project_bin_lto)/rom.out: $(objects_sgr_lto_68k) $(objects_project_lto_68k)
	$(CC) -nostdlib -o $@ $(objects_sgr_lto) $(objects_project_lto)


### SGR Rules #####################################################
$(path_sgr)/build-tools/m68k-amigaos-toolchain:
	wget -P $(path_sgr)/build-tools https://rrgamescdn.github.io/sgr-bucket/build-tools/windows/64-bit/m68k-amigaos-toolchain.tar.xz
	tar -xf $(path_sgr)/build-tools/m68k-amigaos-toolchain.tar.xz -C $(path_sgr)/build-tools
	rm -f $(path_sgr)/build-tools/m68k-amigaos-toolchain.tar.xz


### Setup Rules ###################################################
$(folders):
	mkdir -p $@



###################################################################
# Template Rules
###################################################################
define TEMPLATE_RULE_
$(1): $(subst obj/$(configuration_type),src, $(1:.o=.c))
	$(CC) -c $(CFLAGS) -o $$@ $$<
endef



###################################################################
# Pattern Rules
###################################################################
### Compile Project Sources #######################################
# TODO: FIGURE OUT HOW TO HANDLE MULTIPLE SRCS MAPPING TO OBJECTS
#$(path_project_objects_target)/%.o: $(path_project_sources)/%.c
#	$(CC) -c $(CFLAGS) -o $@ $<

#$(path_project_objects_lto_68k)/%.s.o $(path_project_objects_release_68k)/%.s.o $(path_project_objects_debug_68k)/%.s.o: $(path_project_sources_68k)/%.s
#	$(AS) $(ASFLAGS) -o $@ $<


### Compile SGR Sources ###########################################
#$(path_sgr_objects_lto_68k)/%.o $(path_sgr_objects_release_68k)/%.o $(path_sgr_objects_debug_68k)/%.o: $(path_sgr_sources_68k)/%.c
#	$(CC) -c $(CFLAGS) -o $@ $<

#$(path_sgr_objects_lto_68k)/%.s.o $(path_sgr_objects_release_68k)/%.s.o $(path_sgr_objects_debug_68k)/%.s.o: $(path_sgr_sources_68k)/%.s
#	$(AS) $(ASFLAGS) -o $@ $<



###################################################################
# Dependency Rules
###################################################################
-include $(dependencies_sgr)
-include $(dependencies_project)