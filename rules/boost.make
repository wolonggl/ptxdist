# -*-makefile-*-
# $Id: template 5041 2006-03-09 08:45:49Z mkl $
#
# Copyright (C) 2006 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BOOST) += boost

#
# Paths and names
#
BOOST_VERSION	:= 1_33_1
BOOST		:= boost_$(BOOST_VERSION)
BOOST_SUFFIX	:= tar.bz2
BOOST_URL	:= $(PTXCONF_SETUP_SFMIRROR)/boost/$(BOOST).$(BOOST_SUFFIX)
BOOST_SOURCE	:= $(SRCDIR)/$(BOOST).$(BOOST_SUFFIX)
BOOST_DIR	:= $(BUILDDIR)/$(BOOST)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

boost_get: $(STATEDIR)/boost.get

$(STATEDIR)/boost.get: $(boost_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(BOOST_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, BOOST)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

boost_extract: $(STATEDIR)/boost.extract

$(STATEDIR)/boost.extract: $(boost_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(BOOST_DIR))
	@$(call extract, BOOST)
	@$(call patchin, BOOST)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

boost_prepare: $(STATEDIR)/boost.prepare

BOOST_PATH	:=  PATH=$(CROSS_PATH)
BOOST_ENV 	:=  $(CROSS_ENV)

# they reinvent their own wheel^Hmake: jam
# -q: quit on error
# -d: debug level, default=1

BOOST_JAM	:= \
	$(BOOST_DIR)/tools/build/jam_src/bjam \
	-q \
	-sTOOLS=gcc \
	-sGCC=$(COMPILER_PREFIX)gcc \
	-sGXX=$(COMPILER_PREFIX)g++ \
	-sOBJCOPY=$(COMPILER_PREFIX)objcopy

# boost doesn't provide "no library" choice. If the library list is empty, it
# goes for all libraries. We start at least with date_time lib here to avoid
# this
BOOST_LIBRARIES	:= date_time
ifdef PTXCONF_BOOST_FILESYSTEM
BOOST_LIBRARIES += filesystem
endif
ifdef PTXCONF_BOOST_REGEX
BOOST_LIBRARIES += regex
endif
ifdef PTXCONF_BOOST_THREAD
BOOST_LIBRARIES += thread
endif
ifdef PTXCONF_BOOST_PROGRAM_OPTIONS
BOOST_LIBRARIES += program_options
endif
ifdef PTXCONF_BOOST_SERIALIZATION
BOOST_LIBRARIES += serialization
endif
ifdef PTXCONF_BOOST_SIGNALS
BOOST_LIBRARIES += signals
endif
ifdef PTXCONF_BOOST_IOSTREAMS
BOOST_LIBRARIES += iostreams
endif
ifdef PTXCONF_BOOST_WAVE
BOOST_LIBRARIES += wave
endif
ifdef PTXCONF_BOOST_TEST
BOOST_LIBRARIES += test
endif

BOOST_CONF	:= \
	--with-bjam="$(BOOST_JAM)" \
	--prefix="$(SYSROOT)/usr" \
	--with-libraries="$(subst $(space),$(comma),$(BOOST_LIBRARIES))"

$(STATEDIR)/boost.prepare: $(boost_prepare_deps_default)
	@$(call targetinfo, $@)
	cd $(BOOST_DIR)/tools/build/jam_src && \
		sh build.sh gcc && mv bin.*/bjam .
	
	cd $(BOOST_DIR) && \
		$(BOOST_PATH) \
		./configure $(BOOST_CONF)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

boost_compile: $(STATEDIR)/boost.compile

$(STATEDIR)/boost.compile: $(boost_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(BOOST_DIR) && PATH=$(CROSS_PATH) $(MAKE)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

boost_install: $(STATEDIR)/boost.install

$(STATEDIR)/boost.install: $(boost_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, BOOST)
	@find $(SYSROOT) -name boost -type d -exec cp -a {} $(SYSROOT)/usr/include \;;
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

boost_targetinstall: $(STATEDIR)/boost.targetinstall

$(STATEDIR)/boost.targetinstall: $(boost_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, boost)
	@$(call install_fixup,boost,PACKAGE,boost)
	@$(call install_fixup,boost,PRIORITY,optional)
	@$(call install_fixup,boost,VERSION,$(BOOST_VERSION))
	@$(call install_fixup,boost,SECTION,base)
	@$(call install_fixup,boost,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,boost,DEPENDS,)
	@$(call install_fixup,boost,DESCRIPTION,missing)
	
# iterate for selected libraries
# trim whitespaces added by make and go for single .so files depending on which
# kind of binaries we want to install
	@for BOOST_LIB in $(BOOST_LIBRARIES); do \
		read BOOST_LIB <<< $$BOOST_LIB; \
		if [ ! -z $(PTXCONF_BOOST_INST_NOMT_DBG) ]; then \
			for SO_FILE in `find $(BOOST_DIR)/bin/boost/libs/$$BOOST_LIB/ \
				 -name "*.so.*" -type f -path "*debug*" ! -path "*threading*"`; do \
				$(call install_copy, boost, 0, 0, 0644, $$SO_FILE,\
					/usr/lib/$$(basename $$SO_FILE)); \
			        $(call install_link, boost, \
		                	$$(basename $$SO_FILE), \
        		        	/usr/lib/$$(echo `basename $$SO_FILE` | cut -f 1 -d .).so); \
			done; \
		fi; \
		if [ ! -z $(PTXCONF_BOOST_INST_NOMT_RED) ]; then \
			for SO_FILE in `find $(BOOST_DIR)/bin/boost/libs/$$BOOST_LIB/ \
				 -name "*.so.*" -type f -path "*release*" ! -path "*threading*"`; do \
				$(call install_copy, boost, 0, 0, 0644, $$SO_FILE,\
					/usr/lib/$$(basename $$SO_FILE), n); \
			        $(call install_link, boost, \
		                	$$(basename $$SO_FILE), \
        		        	/usr/lib/$$(echo `basename $$SO_FILE` | cut -f 1 -d .).so); \
			done; \
		fi; \
		if [ ! -z $(PTXCONF_BOOST_INST_MT_DBG) ]; then \
			for SO_FILE in `find $(BOOST_DIR)/bin/boost/libs/$$BOOST_LIB/ \
				 -name "*.so.*" -type f -path "*debug*" -path "*threading*"`; do \
				$(call install_copy, boost, 0, 0, 0644, $$SO_FILE,\
					/usr/lib/$$(basename $$SO_FILE)); \
			        $(call install_link, boost, \
		                	$$(basename $$SO_FILE), \
        		        	/usr/lib/$$(echo `basename $$SO_FILE` | cut -f 1 -d .).so); \
			done; \
		fi; \
		if [ ! -z $(PTXCONF_BOOST_INST_MT_RED) ]; then \
			for SO_FILE in `find $(BOOST_DIR)/bin/boost/libs/$$BOOST_LIB/ \
				 -name "*.so.*" -type f -path "*release*" -path "*threading*"`; do \
				$(call install_copy, boost, 0, 0, 0644, $$SO_FILE,\
					/usr/lib/$$(basename $$SO_FILE), n); \
			        $(call install_link, boost, \
		                	$$(basename $$SO_FILE), \
        		        	/usr/lib/$$(echo `basename $$SO_FILE` | cut -f 1 -d .).so); \
			done; \
		fi; \
	done

	@$(call install_finish,boost)

	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

boost_clean:
	rm -rf $(STATEDIR)/boost.*
	rm -rf $(IMAGEDIR)/boost_*
	rm -rf $(BOOST_DIR)

# vim: syntax=make
