# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBART) += libart

#
# Paths and names
#
LIBART_VERSION		= 2.3.16
LIBART			= libart_lgpl-$(LIBART_VERSION)
LIBART_SUFFIX		= tar.bz2
LIBART_URL		= ftp://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/$(LIBART).$(LIBART_SUFFIX)
LIBART_SOURCE		= $(SRCDIR)/$(LIBART).$(LIBART_SUFFIX)
LIBART_DIR		= $(BUILDDIR)/$(LIBART)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libart_get: $(STATEDIR)/libart.get

$(STATEDIR)/libart.get: $(libart_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(LIBART_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, LIBART)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libart_extract: $(STATEDIR)/libart.extract

$(STATEDIR)/libart.extract: $(libart_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBART_DIR))
	@$(call extract, LIBART)
	@$(call patchin, $(LIBART))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libart_prepare: $(STATEDIR)/libart.prepare

LIBART_PATH	=  PATH=$(CROSS_PATH)
LIBART_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
LIBART_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libart.prepare: $(libart_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBART_DIR)/config.cache)
	cd $(LIBART_DIR) && \
		$(LIBART_PATH) $(LIBART_ENV) \
		./configure $(LIBART_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libart_compile: $(STATEDIR)/libart.compile

$(STATEDIR)/libart.compile: $(libart_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(LIBART_DIR) && $(LIBART_PATH) $(LIBART_ENV) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libart_install: $(STATEDIR)/libart.install

$(STATEDIR)/libart.install: $(libart_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, LIBART)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libart_targetinstall: $(STATEDIR)/libart.targetinstall

$(STATEDIR)/libart.targetinstall: $(libart_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, libart)
	@$(call install_fixup, libart,PACKAGE,libart)
	@$(call install_fixup, libart,PRIORITY,optional)
	@$(call install_fixup, libart,VERSION,$(LIBART_VERSION))
	@$(call install_fixup, libart,SECTION,base)
	@$(call install_fixup, libart,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, libart,DEPENDS,)
	@$(call install_fixup, libart,DESCRIPTION,missing)

	@$(call install_copy, libart, 0, 0, 0644, \
		$(LIBART_DIR)/.libs/libart_lgpl_2.so.2.3.16, \
		/usr/lib/libart_lgpl_2.so.2.3.16)
	@$(call install_link, libart, libart_lgpl_2.so.2.3.16, /usr/lib/libart_lgpl_2.so.2.3)
	@$(call install_link, libart, libart_lgpl_2.so.2.3.16, /usr/lib/libart_lgpl_2.so.2)
	@$(call install_link, libart, libart_lgpl_2.so.2.3.16, /usr/lib/libart_lgpl_2.so)

	@$(call install_finish, libart)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libart_clean:
	rm -rf $(STATEDIR)/libart.*
	rm -rf $(IMAGEDIR)/libart_*
	rm -rf $(LIBART_DIR)

# vim: syntax=make
