# -*-makefile-*-
# $Id: template 2922 2005-07-11 19:17:53Z rsc $
#
# Copyright (C) 2005 by Robert Schwebel
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBPV) += libpv

#
# Paths and names
#
#LIBPV_VERSION	= 1.1.6.1
LIBPV_VERSION	= 1.2.1
LIBPV		= libpv-$(LIBPV_VERSION)
LIBPV_SUFFIX	= tar.bz2
LIBPV_URL	= http://www.pengutronix.de/software/libpv/download/$(LIBPV).$(LIBPV_SUFFIX)
LIBPV_SOURCE	= $(SRCDIR)/$(LIBPV).$(LIBPV_SUFFIX)
LIBPV_DIR	= $(BUILDDIR)/$(LIBPV)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libpv_get: $(STATEDIR)/libpv.get

$(STATEDIR)/libpv.get: $(LIBPV_SOURCE)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(LIBPV_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(LIBPV_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libpv_extract: $(STATEDIR)/libpv.extract

$(STATEDIR)/libpv.extract: $(libpv_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPV_DIR))
	@$(call extract, $(LIBPV_SOURCE))
	@$(call patchin, $(LIBPV))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libpv_prepare: $(STATEDIR)/libpv.prepare

LIBPV_PATH	=  PATH=$(CROSS_PATH)
LIBPV_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
LIBPV_AUTOCONF =  $(CROSS_AUTOCONF_USR)
LIBPV_AUTOCONF += --disable-debug
ifdef PTXCONF_LIBPV_EVENT
LIBPV_AUTOCONF += --enable-event
else
LIBPV_AUTOCONF += --disable-event
endif

$(STATEDIR)/libpv.prepare: $(libpv_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPV_DIR)/config.cache)
	cd $(LIBPV_DIR) && \
		$(LIBPV_PATH) $(LIBPV_ENV) \
		./configure $(LIBPV_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libpv_compile: $(STATEDIR)/libpv.compile

$(STATEDIR)/libpv.compile: $(libpv_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBPV_DIR) && $(LIBPV_ENV) $(LIBPV_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libpv_install: $(STATEDIR)/libpv.install

$(STATEDIR)/libpv.install: $(libpv_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBPV)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libpv_targetinstall: $(STATEDIR)/libpv.targetinstall

$(STATEDIR)/libpv.targetinstall: $(libpv_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,libpv)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(LIBPV_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

ifdef PTXCONF_LIBPV_PVTOOL
	@$(call install_copy, 0, 0, 0755, $(LIBPV_DIR)/src/.libs/pvtool, /usr/bin/pvtool)
endif

	@$(call install_copy, 0, 0, 0644, $(LIBPV_DIR)/src/.libs/libpv.so.5.2.2, /usr/lib/libpv.so.5.2.2)
	@$(call install_link, libpv.so.5.2.2, /usr/lib/libpv.so.5)
	@$(call install_link, libpv.so.5.2.2, /usr/lib/libpv.so)

	@$(call install_finish)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libpv_clean:
	rm -rf $(STATEDIR)/libpv.*
	rm -rf $(IMAGEDIR)/libpv_*
	rm -rf $(LIBPV_DIR)

# vim: syntax=make
