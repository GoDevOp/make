#
#   Master/subproject.make
#
#   Master Makefile rules to build subprojects in GNUstep projects.
#
#   Copyright (C) 1998, 2001 Free Software Foundation, Inc.
#
#   Author:  Jonathan Gapen <jagapen@whitewater.chem.wisc.edu>
#   Author:  Nicola Pero <nicola@brainstorm.co.uk>
#
#   This file is part of the GNUstep Makefile Package.
#
#   This library is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation; either version 2
#   of the License, or (at your option) any later version.
#   
#   You should have received a copy of the GNU General Public
#   License along with this library; see the file COPYING.LIB.
#   If not, write to the Free Software Foundation,
#   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

ifeq ($(RULES_MAKE_LOADED),)
include $(GNUSTEP_MAKEFILES)/rules.make
endif

#
# The names of the subproject is in the SUBPROJECT_NAME variable.
#

SUBPROJECT_NAME := $(strip $(SUBPROJECT_NAME))

ifneq ($(FRAMEWORK_NAME),)
.PHONY: build-headers
build-headers:: $(SUBPROJECT_NAME:=.build-headers.subproject.variables)
endif

internal-all:: $(SUBPROJECT_NAME:=.all.subproject.variables)

# for frameworks, headers are copied by build-headers into the
# framework directory, and are automatically installed when you
# install the framework; for other projects, we need to install each
# subproject's headers separately
ifeq ($(FRAMEWORK_NAME),)
# WARNING - if you type `make install' in a framework's subproject dir
# you are going to install the headers in the wrong place - can't fix
# that - but you can prevent it by adding `FRAMEWORK_NAME = xxx' to
# your subprojects' GNUmakefiles.
internal-install:: $(SUBPROJECT_NAME:=.install.subproject.variables)

internal-uninstall:: $(SUBPROJECT_NAME:=.uninstall.subproject.variables)

endif

_PSWRAP_C_FILES = $(foreach subproject,$(SUBPROJECT_NAME),$($(subproject)_PSWRAP_FILES:.psw=.c))
_PSWRAP_H_FILES = $(foreach subproject,$(SUBPROJECT_NAME),$($(subproject)_PSWRAP_FILES:.psw=.h))

internal-clean:: $(SUBPROJECT_NAME:=.clean.subproject.subprojects)
	rm -rf $(GNUSTEP_OBJ_DIR) $(_PSWRAP_C_FILES) $(_PSWRAP_H_FILES)

internal-distclean:: $(SUBPROJECT_NAME:=.distclean.subproject.subprojects)
	rm -rf shared_obj static_obj shared_debug_obj shared_profile_obj \
	  static_debug_obj static_profile_obj shared_profile_debug_obj \
	  static_profile_debug_obj

$(SUBPROJECT_NAME):
	@$(MAKE) -f $(MAKEFILE_NAME) --no-print-directory \
		$@.all.subproject.variables

## Local variables:
## mode: makefile
## End: