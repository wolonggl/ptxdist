# -*-makefile-*-
# $Id: glib22.make,v 1.4 2003/08/17 00:32:04 robert Exp $
#
# (c) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#             Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXDIST project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_GLIB22
PACKAGES += glib22
endif

#
# Paths and names
#
GLIB22_VERSION		= 2.2.2
GLIB22			= glib-$(GLIB22_VERSION)
GLIB22_SUFFIX		= tar.gz
GLIB22_URL		= ftp://ftp.gtk.org/pub/gtk/v2.2/$(GLIB22).$(GLIB22_SUFFIX)
GLIB22_SOURCE		= $(SRCDIR)/$(GLIB22).$(GLIB22_SUFFIX)
GLIB22_DIR		= $(BUILDDIR)/$(GLIB22)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

glib22_get: $(STATEDIR)/glib22.get

glib22_get_deps	=  $(GLIB22_SOURCE)

$(STATEDIR)/glib22.get: $(glib22_get_deps)
	@$(call targetinfo, glib22.get)
	touch $@

$(GLIB22_SOURCE):
	@$(call targetinfo, $(GLIB22_SOURCE))
	@$(call get, $(GLIB22_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

glib22_extract: $(STATEDIR)/glib22.extract

glib22_extract_deps	=  $(STATEDIR)/glib22.get

$(STATEDIR)/glib22.extract: $(glib22_extract_deps)
	@$(call targetinfo, glib22.extract)
	@$(call clean, $(GLIB22_DIR))
	@$(call extract, $(GLIB22_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

glib22_prepare: $(STATEDIR)/glib22.prepare

#
# dependencies
#
glib22_prepare_deps =  \
	$(STATEDIR)/glib22.extract \
#	$(STATEDIR)/virtual-xchain.install

GLIB22_PATH	=  PATH=$(CROSS_PATH)
GLIB22_ENV 	=  $(CROSS_ENV)
GLIB22_ENV	+= PKG_CONFIG_PATH=../$(GLIB22):../$(ATK124):../$(PANGO12):../$(GTK22)

GLIB22_ENV	+= glib_cv_use_pid_surrogate=no
GLIB22_ENV	+= ac_cv_func_posix_getpwuid_r=yes 
ifeq (y, $G(PTXCONF_GLIBC_DL))
GLIB22_ENV	+= glib_cv_uscore=yes
else
GLIB22_ENV	+= glib_cv_uscore=no
endif
GLIB22_ENV	+= glib_cv_stack_grows=no

#
# autoconf
#
GLIB22_AUTOCONF	=  --prefix=/usr
GLIB22_AUTOCONF	+= --build=$(GNU_HOST)
GLIB22_AUTOCONF	+= --host=$(PTXCONF_GNU_TARGET)

GLIB22_AUTOCONF	+= --with-threads=posix

$(STATEDIR)/glib22.prepare: $(glib22_prepare_deps)
	@$(call targetinfo, glib22.prepare)
	@$(call clean, $(GLIB22_BUILDDIR))
	cd $(GLIB22_DIR) && \
		$(GLIB22_PATH) $(GLIB22_ENV) \
		./configure $(GLIB22_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

glib22_compile: $(STATEDIR)/glib22.compile

glib22_compile_deps =  $(STATEDIR)/glib22.prepare

$(STATEDIR)/glib22.compile: $(glib22_compile_deps)
	@$(call targetinfo, glib22.compile)
	$(GLIB22_PATH) $(GLIB22_ENV) make -C $(GLIB22_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

glib22_install: $(STATEDIR)/glib22.install

$(STATEDIR)/glib22.install: $(STATEDIR)/glib22.compile
	@$(call targetinfo, glib22.install)
	
	install -d $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib/libglib-2.0.so*
	install $(GLIB22_DIR)/glib/.libs/libglib-2.0.so.0.200.2 $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib/
	ln -s libglib-2.0.so.0.200.2 $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib/libglib-2.0.so.0
	ln -s libglib-2.0.so.0.200.2 $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/lib/libglib-2.0.so
	install -d $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/glib
	cp -a $(GLIB22_DIR)/glib/*.h $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/glib/
	install -d $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/gobject
	cp -a $(GLIB22_DIR)/gobject/*.h $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/gobject/
	install -d $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/gmodule
	cp -a $(GLIB22_DIR)/gmodule/*.h $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/include/

	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

glib22_targetinstall: $(STATEDIR)/glib22.targetinstall

glib22_targetinstall_deps	=  $(STATEDIR)/glib22.compile

$(STATEDIR)/glib22.targetinstall: $(glib22_targetinstall_deps)
	@$(call targetinfo, glib22.targetinstall)
	install -d $(ROOTDIR)
	rm -f $(ROOTDIR)/lib/libglib-2.0.so*
	install $(GLIB22_DIR)/glib/.libs/libglib-2.0.so.0.200.2 $(ROOTDIR)/lib/
	ln -s libglib-2.0.so.0.200.2 $(ROOTDIR)/lib/libglib-2.0.so.0
	ln -s libglib-2.0.so.0.200.2 $(ROOTDIR)/lib/libglib-2.0.so
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

glib22_clean:
	rm -rf $(STATEDIR)/glib22.*
	rm -rf $(GLIB22_DIR)
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/share/pkg-config/glib-2.0*.pc
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/share/pkg-config/gmodule-2.0*.pc
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/share/pkg-config/gobject-2.0*.pc
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/share/pkg-config/gthread-2.0*.pc

# vim: syntax=make
