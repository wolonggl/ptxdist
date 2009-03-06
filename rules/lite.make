# -*-makefile-*-
# $Id: template 6655 2007-01-02 12:55:21Z rsc $
#
# Copyright (C) 2007 by Denis Oliver Kropp
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LITE) += lite

#
# Paths and names
#
LITE_VERSION	:= 0.8.10
LITE		:= LiTE-$(LITE_VERSION)
LITE_SUFFIX	:= tar.gz
LITE_URL	:= http://www.directfb.org/downloads/Libs/$(LITE).$(LITE_SUFFIX)
LITE_SOURCE	:= $(SRCDIR)/$(LITE).$(LITE_SUFFIX)
LITE_DIR	:= $(BUILDDIR)/$(LITE)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(LITE_SOURCE):
	@$(call targetinfo)
	@$(call get, LITE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LITE_PATH	:= PATH=$(CROSS_PATH)
LITE_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
LITE_AUTOCONF := $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/lite.targetinstall:
	@$(call targetinfo)

	@$(call install_init, lite)
	@$(call install_fixup, lite,PACKAGE,lite)
	@$(call install_fixup, lite,PRIORITY,optional)
	@$(call install_fixup, lite,VERSION,$(LITE_VERSION))
	@$(call install_fixup, lite,SECTION,base)
	@$(call install_fixup, lite,AUTHOR,"Denis Oliver Kropp <dok\@directfb.org>")
	@$(call install_fixup, lite,DEPENDS,)
	@$(call install_fixup, lite,DESCRIPTION,missing)

	@$(call install_copy, lite, 0, 0, 0755, \
		$(LITE_DIR)/lite/.libs/liblite.so.3.0.5, \
		/usr/lib/liblite.so.3.0.5)

	@$(call install_link, lite, liblite.so.3.0.5, /usr/lib/liblite.so.3)

	@$(call install_copy, lite, 0, 0, 0755, \
		$(LITE_DIR)/leck/.libs/libleck.so.3.0.5, \
		/usr/lib/libleck.so.3.0.5)

	@$(call install_link, lite, libleck.so.3.0.5, /usr/lib/libleck.so.3)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/cursor.png, \
		/usr/share/LiTE/cursor.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/links.png, \
		/usr/share/LiTE/links.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/obenlinks.png, \
		/usr/share/LiTE/obenlinks.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/oben.png, \
		/usr/share/LiTE/oben.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/obenrechts.png, \
		/usr/share/LiTE/obenrechts.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/rechts.png, \
		/usr/share/LiTE/rechts.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/untenlinks.png, \
		/usr/share/LiTE/untenlinks.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/unten.png, \
		/usr/share/LiTE/unten.png, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/data/untenrechts.png, \
		/usr/share/LiTE/untenrechts.png, n)


	@for i in \
		lite_bench		\
		lite_checktest		\
		lite_dfbspy		\
		lite_listtest		\
		lite_msgbox		\
		lite_progressbar	\
		lite_run		\
		lite_scrollbartest	\
		lite_simple		\
		lite_slider		\
		lite_textbuttontest	\
		lite_textlinetest	\
		lite_textlisttest;	\
			do		\
					\
		$(call install_copy, lite, 0, 0, 0755, \
			$(LITE_DIR)/examples/$$i, \
			/usr/bin/$$i) \
	done


	@for i in \
		checkbox_images.png		\
		D.png				\
		stop.png			\
		stop_disabled.png		\
		stop_highlighted.png		\
		stop_pressed.png		\
		textbuttonbgnd.png		\
		toggle.png			\
		toggle_disabled.png		\
		toggle_highlighted.png		\
		toggle_pressed.png		\
		toggle_highlighted_on.png	\
		toggle_disabled_on.png		\
		progress.png			\
		progress_bg.png			\
		scrollbar.png;			\
			do			\
						\
		$(call install_copy, lite, 0, 0, 0644, \
			$(LITE_DIR)/examples/$$i, \
			/usr/share/LiTE/examples/$$i, n) \
	done


	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/vera.ttf, \
		/usr/share/fonts/truetype/vera.ttf, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/verabd.ttf, \
		/usr/share/fonts/truetype/verabd.ttf, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/verabi.ttf, \
		/usr/share/fonts/truetype/verabi.ttf, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/verai.ttf, \
		/usr/share/fonts/truetype/verai.ttf, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/decker.ttf, \
		/usr/share/fonts/truetype/decker.ttf, n)

	@$(call install_copy, lite, 0, 0, 0644, \
		$(LITE_DIR)/fonts/whiterabbit.ttf, \
		/usr/share/fonts/truetype/whiterabbit.ttf, n)


	@$(call install_finish, lite)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

lite_clean:
	rm -rf $(STATEDIR)/lite.*
	rm -rf $(PKGDIR)/lite_*
	rm -rf $(LITE_DIR)

# vim: syntax=make
