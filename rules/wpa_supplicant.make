# -*-makefile-*-
#
# Copyright (C) 2009 by Markus Rathgeb <rathgeb.markus@googlemail.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WPA_SUPPLICANT) += wpa_supplicant

#
# Paths and names
#
WPA_SUPPLICANT_NAME	:= wpa_supplicant
WPA_SUPPLICANT_VERSION	:= 2.6
WPA_SUPPLICANT_MD5	:= 091569eb4440b7d7f2b4276dbfc03c3c
WPA_SUPPLICANT		:= $(WPA_SUPPLICANT_NAME)-$(WPA_SUPPLICANT_VERSION)
WPA_SUPPLICANT_SUFFIX	:= tar.gz
WPA_SUPPLICANT_URL	:= https://w1.fi/releases/$(WPA_SUPPLICANT).$(WPA_SUPPLICANT_SUFFIX)
WPA_SUPPLICANT_SOURCE	:= $(SRCDIR)/$(WPA_SUPPLICANT).$(WPA_SUPPLICANT_SUFFIX)
WPA_SUPPLICANT_DIR	:= $(BUILDDIR)/$(WPA_SUPPLICANT)
WPA_SUPPLICANT_SUBDIR	:= $(WPA_SUPPLICANT_NAME)
# Use '=' to delay $(shell ...) calls until this is needed
WPA_SUPPLICANT_DEFCONF	 = $(shell ptxd_get_alternative config/wpasupplicant defconfig && echo $$ptxd_reply)
WPA_SUPPLICANT_CONFIG	:= $(BUILDDIR)/$(WPA_SUPPLICANT)/$(WPA_SUPPLICANT_SUBDIR)/.config
WPA_SUPPLICANT_LICENSE	:= GPL-2.0-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

WPA_SUPPLICANT_PATH	:= PATH=$(CROSS_PATH)
WPA_SUPPLICANT_MAKE_ENV	:= \
	$(CROSS_ENV) \
	LIBDIR=/usr/lib \
	BINDIR=/usr/sbin

#
# autoconf
#
WPA_SUPPLICANT_AUTOCONF := $(CROSS_AUTOCONF_USR)

$(STATEDIR)/wpa_supplicant.prepare:
	@$(call targetinfo)

#	# run 'make clean' as wpa_supplicant's build system does not recognize config changes
	@-cd $(WPA_SUPPLICANT_DIR)/$(WPA_SUPPLICANT_SUBDIR) && \
		$(WPA_SUPPLICANT_MAKE_ENV) $(WPA_SUPPLICANT_PATH) $(MAKE) clean

	@cp $(WPA_SUPPLICANT_DEFCONF) $(WPA_SUPPLICANT_CONFIG)
	@$(call enable_sh,$(WPA_SUPPLICANT_CONFIG),CC=$(CROSS_CC))
ifdef PTXCONF_WPA_SUPPLICANT_CTRL_IFACE_DBUS
	@$(call enable_sh,$(WPA_SUPPLICANT_CONFIG),CONFIG_CTRL_IFACE_DBUS=y)
	@$(call enable_sh,$(WPA_SUPPLICANT_CONFIG),CONFIG_CTRL_IFACE_DBUS_NEW=y)
	@$(call enable_sh,$(WPA_SUPPLICANT_CONFIG),CONFIG_CTRL_IFACE_DBUS_INTRO=y)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/wpa_supplicant.install:
	@$(call targetinfo)
	@$(call world/install, WPA_SUPPLICANT)

	@install -vD -m 644 "$(WPA_SUPPLICANT_DIR)/$(WPA_SUPPLICANT_SUBDIR)/dbus/dbus-wpa_supplicant.conf" \
		"$(WPA_SUPPLICANT_PKGDIR)/usr/share/dbus-1/system.d/wpa_supplicant.conf"
	@install -vD -m 644 "$(WPA_SUPPLICANT_DIR)/$(WPA_SUPPLICANT_SUBDIR)/dbus/fi.epitest.hostap.WPASupplicant.service" \
		"$(WPA_SUPPLICANT_PKGDIR)/usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service"
	@install -vD -m 644 "$(WPA_SUPPLICANT_DIR)/$(WPA_SUPPLICANT_SUBDIR)/dbus/fi.w1.wpa_supplicant1.service" \
		"$(WPA_SUPPLICANT_PKGDIR)/usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service"

	@install -vD -m 644 "$(WPA_SUPPLICANT_DIR)/$(WPA_SUPPLICANT_SUBDIR)/systemd/wpa_supplicant.service" \
		"$(WPA_SUPPLICANT_PKGDIR)/usr/lib/systemd/system/wpa_supplicant.service"

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/wpa_supplicant.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  wpa_supplicant)
	@$(call install_fixup, wpa_supplicant,PRIORITY,optional)
	@$(call install_fixup, wpa_supplicant,SECTION,base)
	@$(call install_fixup, wpa_supplicant,AUTHOR,"Markus Rathgeb <rathgeb.markus@googlemail.com>")
	@$(call install_fixup, wpa_supplicant,DESCRIPTION,missing)

	@$(call install_copy, wpa_supplicant, 0, 0, 0755, -, \
		/usr/sbin/wpa_supplicant)

ifdef PTXCONF_WPA_SUPPLICANT_PASSPHRASE
	@$(call install_copy, wpa_supplicant, 0, 0, 0755, -, \
		/usr/sbin/wpa_passphrase)
endif

ifdef PTXCONF_WPA_SUPPLICANT_INSTALL_CLI
	@$(call install_copy, wpa_supplicant, 0, 0, 0755, -, /usr/sbin/wpa_cli)
endif

ifdef PTXCONF_WPA_SUPPLICANT_CTRL_IFACE_DBUS
	@$(call install_alternative, wpa_supplicant, 0, 0, 0644, \
		/usr/share/dbus-1/system.d/wpa_supplicant.conf)
	@$(call install_alternative, wpa_supplicant, 0, 0, 0644, \
		/usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service)
	@$(call install_alternative, wpa_supplicant, 0, 0, 0644, \
		/usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service)
endif
ifdef PTXCONF_INITMETHOD_SYSTEMD
	@$(call install_alternative, wpa_supplicant, 0, 0, 0644, \
		/usr/lib/systemd/system/wpa_supplicant.service)
endif

	@$(call install_alternative, wpa_supplicant, 0, 0, 0644, \
		/etc/wpa_supplicant.conf)

	@$(call install_finish, wpa_supplicant)

	@$(call touch)

# vim: syntax=make
