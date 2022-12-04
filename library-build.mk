
###################################################################
# Variables
###################################################################
path_sgr		:= $(shell echo $(MAKEFILE_LIST) | sed "s, ,\\\ ,g" | xargs realpath | sed "s, ,\\\ ,g" | xargs dirname | sed "s, ,\\\ ,g")
path_sgr		:= $(path_sgr:/=)

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
	echo $(path_sgr)

$(MAKECMDGOALS):
	@$(MAKE) --file $(path_sgr)/library-rules.mk $@




#TODO:
#	1. Spaces in folder / file names.