# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 Ixia Corporation, by Milan Bobde
#               2005 Pengutronix, Marc Kleine-Budde
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBRN) += librn

#
# Paths and names
#
LIBRN_VERSION	= 0.5.1
LIBRN		= librn-$(LIBRN_VERSION)
LIBRN_SUFFIX	= tar.bz2
LIBRN_URL	= http://www.pengutronix.de/software/librn/download/$(LIBRN).$(LIBRN_SUFFIX)
LIBRN_SOURCE	= $(SRCDIR)/$(LIBRN).$(LIBRN_SUFFIX)
LIBRN_DIR	= $(BUILDDIR)/$(LIBRN)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

librn_get: $(STATEDIR)/librn.get

$(STATEDIR)/librn.get: $(librn_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(LIBRN_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, LIBRN)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

librn_extract: $(STATEDIR)/librn.extract

$(STATEDIR)/librn.extract: $(librn_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBRN_DIR))
	@$(call extract, LIBRN)
	@$(call patchin, $(LIBRN))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

librn_prepare: $(STATEDIR)/librn.prepare

LIBRN_PATH	=  PATH=$(CROSS_PATH)
LIBRN_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
LIBRN_AUTOCONF = \
	$(CROSS_AUTOCONF_USR) \
	--disable-debug

$(STATEDIR)/librn.prepare: $(librn_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBRN_DIR)/config.cache)
	cd $(LIBRN_DIR) && \
		$(LIBRN_PATH) $(LIBRN_ENV) \
		./configure $(LIBRN_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

librn_compile: $(STATEDIR)/librn.compile

$(STATEDIR)/librn.compile: $(librn_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBRN_DIR) && $(LIBRN_ENV) $(LIBRN_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

librn_install: $(STATEDIR)/librn.install

$(STATEDIR)/librn.install: $(librn_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBRN)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

librn_targetinstall: $(STATEDIR)/librn.targetinstall

$(STATEDIR)/librn.targetinstall: $(librn_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, librn)
	@$(call install_fixup, librn,PACKAGE,librn)
	@$(call install_fixup, librn,PRIORITY,optional)
	@$(call install_fixup, librn,VERSION,$(LIBRN_VERSION))
	@$(call install_fixup, librn,SECTION,base)
	@$(call install_fixup, librn,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, librn,DEPENDS,)
	@$(call install_fixup, librn,DESCRIPTION,missing)

	@$(call install_copy, librn, 0, 0, 0644, $(LIBRN_DIR)/src/.libs/librn.so.0.1.1, /usr/lib/librn.so.0.1.1)
	@$(call install_link, librn, librn.so.0.1.1, /usr/lib/librn.so.0)
	@$(call install_link, librn, librn.so.0.1.1, /usr/lib/librn.so)

	@$(call install_finish, librn)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

librn_clean:
	rm -rf $(STATEDIR)/librn.*
	rm -rf $(IMAGEDIR)/librn_*
	rm -rf $(LIBRN_DIR)

# vim: syntax=make
