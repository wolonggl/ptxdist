# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Benedikt Spranger
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_HOSTTOOL_FAKEROOT
HOSTTOOLS += hosttool-fakeroot
endif

#
# Paths and names
#
HOSTTOOL_FAKEROOT_VERSION	= 1.3
HOSTTOOL_FAKEROOT		= fakeroot-$(HOSTTOOL_FAKEROOT_VERSION)
HOSTTOOL_FAKEROOT_SUFFIX	= tar.gz
HOSTTOOL_FAKEROOT_URL		= $(PTXCONF_SETUP_DEBMIRROR)/pool/main/f/fakeroot/fakeroot_$(HOSTTOOL_FAKEROOT_VERSION).$(HOSTTOOL_FAKEROOT_SUFFIX)
HOSTTOOL_FAKEROOT_SOURCE	= $(SRCDIR)/fakeroot_$(HOSTTOOL_FAKEROOT_VERSION).$(HOSTTOOL_FAKEROOT_SUFFIX)
HOSTTOOL_FAKEROOT_DIR		= $(HOST_BUILDDIR)/$(HOSTTOOL_FAKEROOT)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

hosttool-fakeroot_get: $(STATEDIR)/hosttool-fakeroot.get

hosttool-fakeroot_get_deps = $(HOSTTOOL_FAKEROOT_SOURCE)

$(STATEDIR)/hosttool-fakeroot.get: $(hosttool-fakeroot_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(HOSTTOOL_FAKEROOT_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(HOSTTOOL_FAKEROOT_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

hosttool-fakeroot_extract: $(STATEDIR)/hosttool-fakeroot.extract

hosttool-fakeroot_extract_deps = $(STATEDIR)/hosttool-fakeroot.get

$(STATEDIR)/hosttool-fakeroot.extract: $(hosttool-fakeroot_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(HOSTTOOL_FAKEROOT_DIR))
	@$(call extract, $(HOSTTOOL_FAKEROOT_SOURCE), $(HOST_BUILDDIR))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

hosttool-fakeroot_prepare: $(STATEDIR)/hosttool-fakeroot.prepare

#
# dependencies
#
hosttool-fakeroot_prepare_deps = \
	$(STATEDIR)/hosttool-fakeroot.extract

HOSTTOOL_FAKEROOT_PATH	=  PATH=$(CROSS_PATH)
HOSTTOOL_FAKEROOT_ENV 	=  $(HOSTCC_ENV)
#HOSTTOOL_FAKEROOT_ENV	+=

#
# autoconf
#
HOSTTOOL_FAKEROOT_AUTOCONF = \
	--prefix=$(PTXCONF_PREFIX) \
	--build=$(GNU_HOST)
	--host=$(GNU_HOST)
	--target=$(GNU_HOST)

$(STATEDIR)/hosttool-fakeroot.prepare: $(hosttool-fakeroot_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(HOSTTOOL_FAKEROOT_DIR)/config.cache)
	cd $(HOSTTOOL_FAKEROOT_DIR) && \
		$(HOSTTOOL_FAKEROOT_PATH) $(HOSTTOOL_FAKEROOT_ENV) \
		./configure $(HOSTTOOL_FAKEROOT_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

hosttool-fakeroot_compile: $(STATEDIR)/hosttool-fakeroot.compile

hosttool-fakeroot_compile_deps = $(STATEDIR)/hosttool-fakeroot.prepare

$(STATEDIR)/hosttool-fakeroot.compile: $(hosttool-fakeroot_compile_deps)
	@$(call targetinfo, $@)
	$(HOSTTOOL_FAKEROOT_PATH) make -C $(HOSTTOOL_FAKEROOT_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

hosttool-fakeroot_install: $(STATEDIR)/hosttool-fakeroot.install

$(STATEDIR)/hosttool-fakeroot.install: $(STATEDIR)/hosttool-fakeroot.compile
	@$(call targetinfo, $@)
	$(HOSTTOOL_FAKEROOT_PATH) make -C $(HOSTTOOL_FAKEROOT_DIR) install
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

hosttool-fakeroot_targetinstall: $(STATEDIR)/hosttool-fakeroot.targetinstall

hosttool-fakeroot_targetinstall_deps = $(STATEDIR)/hosttool-fakeroot.compile

$(STATEDIR)/hosttool-fakeroot.targetinstall: $(hosttool-fakeroot_targetinstall_deps)
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

hosttool-fakeroot_clean:
	rm -rf $(STATEDIR)/hosttool-fakeroot.*
	rm -rf $(HOSTTOOL_FAKEROOT_DIR)

# vim: syntax=make
