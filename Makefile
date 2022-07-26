
###################################################################
# Variables
###################################################################
path_sgr		:= $(dir $(lastword $(abspath $(MAKEFILE_LIST))))
path_sgr		:= $(path_sgr:/=)
MAKECMDGOALS 	:= $(filter-out usage, $(MAKECMDGOALS)) #Do not include 'usage' target in the make forwarding process

###################################################################
# Usage Notes
###################################################################
.PHONY: usage
usage:
	@echo "Usage: make release"
	@echo "       make debug"
	@echo "Build a SEGA Genesis ROM with either release or debug configuration."

###################################################################
# Forward Each Target One at a Time
###################################################################
# Export sgr_path for sub-makes
export path_sgr

# Forward targets to makefile-rules.mk
.PHONY: $(MAKECMDGOALS)
$(MAKECMDGOALS):
	@$(MAKE) $@ --file $(path_sgr)/makefile-rules.mk