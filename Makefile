
###################################################################
# Variables
###################################################################
MAKECMDGOALS 	:= $(filter-out usage, $(MAKECMDGOALS)) #Do not use 'usage' target in the make forwarding process


###################################################################
# Rules
###################################################################
.PHONY: usage $(MAKECMDGOALS)

usage:
	make -f ./RetroRevivalGames/sgr/library-build.mk

#$(MAKECMDGOALS):
#	@$(MAKE) --file ./makefile-rules.mk BUILD_CONFIG=$@
# DO NOT DELETE