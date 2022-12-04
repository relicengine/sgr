
###################################################################
# Variables
###################################################################
include makefile-variables.mk


###################################################################
# Rules
###################################################################
.PHONY: usage release debug

usage:
	@echo Usage: make release
	@echo        make debug
	@echo Build a SEGA Genesis ROM with either release or debug configuration.

release:

debug: 