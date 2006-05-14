# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#                       Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBPNG) += libpng

#
# Paths and names
#
LIBPNG_VERSION	:= 1.2.8
LIBPNG		:= libpng-$(LIBPNG_VERSION)-config
LIBPNG_SUFFIX	:= tar.gz
LIBPNG_URL	:= $(PTXCONF_SETUP_SFMIRROR)/libpng/$(LIBPNG).$(LIBPNG_SUFFIX)
LIBPNG_SOURCE	:= $(SRCDIR)/$(LIBPNG).$(LIBPNG_SUFFIX)
LIBPNG_DIR	:= $(BUILDDIR)/$(LIBPNG)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libpng_get: $(STATEDIR)/libpng.get

$(STATEDIR)/libpng.get: $(libpng_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(LIBPNG_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, LIBPNG)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libpng_extract: $(STATEDIR)/libpng.extract

$(STATEDIR)/libpng.extract: $(libpng_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPNG_DIR))
	@$(call extract, LIBPNG)
	@$(call patchin, $(LIBPNG))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libpng_prepare: $(STATEDIR)/libpng.prepare

LIBPNG_PATH	:= PATH=$(CROSS_PATH)
LIBPNG_ENV	:= $(CROSS_ENV)
LIBPNG_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libpng.prepare: $(libpng_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBPNG_BUILDDIR))
	cd $(LIBPNG_DIR) && \
		$(LIBPNG_PATH) $(LIBPNG_ENV) \
		./configure $(LIBPNG_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libpng_compile: $(STATEDIR)/libpng.compile

$(STATEDIR)/libpng.compile: $(libpng_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBPNG_DIR) && $(LIBPNG_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libpng_install: $(STATEDIR)/libpng.install

$(STATEDIR)/libpng.install: $(libpng_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBPNG)
	$(INSTALL) -m 755 -D $(LIBPNG_DIR)/libpng-config $(PTXCONF_PREFIX)/bin/libpng-config
	$(INSTALL) -m 755 -D $(LIBPNG_DIR)/libpng12-config $(PTXCONF_PREFIX)/bin/libpng-config
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libpng_targetinstall: $(STATEDIR)/libpng.targetinstall

$(STATEDIR)/libpng.targetinstall: $(libpng_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, libpng)
	@$(call install_fixup, libpng,PACKAGE,libpng)
	@$(call install_fixup, libpng,PRIORITY,optional)
	@$(call install_fixup, libpng,VERSION,$(LIBPNG_VERSION))
	@$(call install_fixup, libpng,SECTION,base)
	@$(call install_fixup, libpng,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, libpng,DEPENDS,)
	@$(call install_fixup, libpng,DESCRIPTION,missing)

	@$(call install_copy, libpng, 0, 0, 0644, \
		$(LIBPNG_DIR)/.libs/libpng12.so.0.0.0, \
		/usr/lib/libpng12.so.0.0.0)
	@$(call install_link, libpng, libpng12.so.0.0.0, /usr/lib/libpng12.so.0.0)
	@$(call install_link, libpng, libpng12.so.0.0.0, /usr/lib/libpng12.so.0)

	@$(call install_copy, libpng, 0, 0, 0644, \
		$(LIBPNG_DIR)/.libs/libpng.so.3.0.0, \
		/usr/lib/libpng.so.3.0.0)
	@$(call install_link, libpng, libpng.so.3.0.0, /usr/lib/libpng.so.3.0)
	@$(call install_link, libpng, libpng.so.3.0.0, /usr/lib/libpng.so.3)

	@$(call install_finish, libpng)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libpng_clean:
	rm -rf $(STATEDIR)/libpng.*
	rm -rf $(IMAGEDIR)/libpng_*
	rm -rf $(LIBPNG_DIR)

# vim: syntax=make
