
###################################################################
# Variables
###################################################################
# This little snippet here gets the filepath to SGR. Since SGR projects are built
# from inside the project folder, there needs to be a reference to where this makefile
# is located on the system. So, we use the MAKEFILE_LIST variable which should contain
# the name of this makefile. Then a series of other bash commands build the absolute path.
# Works with spaces too.
# Steps:
#	1. Echo the path to this makefile via the value passed to -f / --file option.
# 	2. Replace any spaces in the file path with escaped spaces "\ ".
#	3. Use realpath, using the piped in text as arguments, to find the absolute filepath.
#	4. Once again replace and spaces in the output of realpath with escaped spaces.
#	5. Using the dirname command, take the piped output to get the filpath only, omitting the makefile name.
#	6. Replace spaces once more from the dirname output.
path_sgr		:= $(shell  echo $(MAKEFILE_LIST) | \
							sed "s, ,\\\ ,g" | \
							xargs realpath | \
							sed "s, ,\\\ ,g" | \
							xargs dirname | \
							sed "s, ,\\\ ,g")
export 			path_sgr #Export path_sgr for all other .mk files to use.

MAKECMDGOALS 	:= $(filter-out usage, $(MAKECMDGOALS)) #Do not use 'usage' target in the make forwarding process.


###################################################################
# Rules
###################################################################
.PHONY: usage $(MAKECMDGOALS)

usage:
	@echo "Usage: make release"
	@echo "       make debug"
	@echo "Build the SGR library using either release or debug configurations."

# Forward each goal to library-rules.mk one at a time.
$(MAKECMDGOALS):
	@$(MAKE) --file $(path_sgr)/library-rules.mk $@
