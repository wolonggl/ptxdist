# -*-makefile-*-
# $Id: memtest.make,v 1.1 2004/06/07 18:29:07 rsc Exp $
#
# Copyright (C) 2004 by Robert Schwebel
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_MEMTEST
PACKAGES += memtest
endif

#
# Paths and names
#
MEMTEST_VERSION		= 0.0.4
MEMTEST			= memtest-$(MEMTEST_VERSION)
MEMTEST_SUFFIX		= tar.bz2
MEMTEST_URL		= http://carpanta.dc.fi.udc.es/~quintela/memtest/$(MEMTEST).$(MEMTEST_SUFFIX)
MEMTEST_SOURCE		= $(SRCDIR)/$(MEMTEST).$(MEMTEST_SUFFIX)
MEMTEST_DIR		= $(BUILDDIR)/$(MEMTEST)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

memtest_get: $(STATEDIR)/memtest.get

memtest_get_deps = $(MEMTEST_SOURCE)

$(STATEDIR)/memtest.get: $(memtest_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(MEMTEST))
	touch $@

$(MEMTEST_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(MEMTEST_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

memtest_extract: $(STATEDIR)/memtest.extract

memtest_extract_deps = $(STATEDIR)/memtest.get

$(STATEDIR)/memtest.extract: $(memtest_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(MEMTEST_DIR))
	@$(call extract, $(MEMTEST_SOURCE))
	@$(call patchin, $(MEMTEST))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

memtest_prepare: $(STATEDIR)/memtest.prepare

#
# dependencies
#
memtest_prepare_deps = \
	$(STATEDIR)/memtest.extract \
	$(STATEDIR)/virtual-xchain.install

MEMTEST_PATH	=  PATH=$(CROSS_PATH)
MEMTEST_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
MEMTEST_AUTOCONF = \
	--build=$(GNU_HOST) \
	--host=$(PTXCONF_GNU_TARGET) \
	--prefix=$(CROSS_LIB_DIR)

$(STATEDIR)/memtest.prepare: $(memtest_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(MEMTEST_DIR)/config.cache)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

memtest_compile: $(STATEDIR)/memtest.compile

memtest_compile_deps = $(STATEDIR)/memtest.prepare

$(STATEDIR)/memtest.compile: $(memtest_compile_deps)
	@$(call targetinfo, $@)
	cd $(MEMTEST_DIR) && $(MEMTEST_ENV) $(MEMTEST_PATH) make mtest
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

memtest_install: $(STATEDIR)/memtest.install

$(STATEDIR)/memtest.install: $(STATEDIR)/memtest.compile
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

memtest_targetinstall: $(STATEDIR)/memtest.targetinstall

memtest_targetinstall_deps = $(STATEDIR)/memtest.compile

$(STATEDIR)/memtest.targetinstall: $(memtest_targetinstall_deps)
	@$(call targetinfo, $@)
	cp $(MEMTEST_DIR)/mtest $(ROOTDIR)/usr/bin
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

memtest_clean:
	rm -rf $(STATEDIR)/memtest.*
	rm -rf $(MEMTEST_DIR)

# vim: syntax=make
