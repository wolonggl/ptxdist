# -*-makefile-*-
# $Id: abbcc.make,v 1.5 2004/08/17 13:10:54 sha Exp $
#
# Copyright (C) 2004 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

VENDORTWEAKS = abbcc

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

abbcc_targetinstall: $(STATEDIR)/abbcc.targetinstall

$(STATEDIR)/abbcc.targetinstall:
	@$(call targetinfo, vendor-tweaks.targetinstall)

#	copy /etc template and do some changes
	cp -a $(TOPDIR)/etc/generic/. $(ROOTDIR)/etc
	perl -i -p -e "s,\@HOSTNAME@,cc1,g" $(ROOTDIR)/etc/hostname
	cp -a $(TOPDIR)/etc/generic/inittab $(ROOTDIR)/etc/
	perl -i -p -e "s,\@SPEED@,19200,g" $(ROOTDIR)/etc/inittab
	perl -i -p -e "s,\@CONSOLE@,tts/0,g" $(ROOTDIR)/etc/inittab
	perl -i -p -e "s,\@PS1@,\"\`hostname\`> \",g" $(ROOTDIR)/etc/profile
	perl -i -p -e "s,\@PS2@,\"\",g" $(ROOTDIR)/etc/profile
	perl -i -p -e "s,\@PS4@,\"\",g" $(ROOTDIR)/etc/profile

#	remove CVS stuff
	find $(ROOTDIR) -name "CVS" | xargs rm -fr 
	rm -f $(ROOTDIR)/JUST_FOR_CVS

#	make scripts executable
	chmod 755 $(ROOTDIR)/etc/init.d/*

#	generate version stamps
	perl -i -p -e "s,\@VERSION@,$(VERSION),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@PATCHLEVEL@,$(PATCHLEVEL),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@SUBLEVEL@,$(SUBLEVEL),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@PROJECT@,$(PROJECT),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@EXTRAVERSION@,$(EXTRAVERSION),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@DATE@,$(shell date -Iseconds),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@VENDOR@,ABB ,g" $(ROOTDIR)/etc/init.d/banner

	install -d $(ROOTDIR)/var/run
	install -d $(ROOTDIR)/var/log
	install -d $(ROOTDIR)/var/lock
	
#	create /etc/rc.d links
	mkdir -p $(ROOTDIR)/etc/rc.d
	ln -sf ../init.d/banner $(ROOTDIR)/etc/rc.d/S00_banner
	ln -sf ../init.d/networking $(ROOTDIR)/etc/rc.d/S01_networking
	ln -sf ../init.d/utelnetd $(ROOTDIR)/etc/rc.d/S02_utelnetd

	# we need to fix owner / permissions at first startup 
	# FIXME: this will be done with fakeroot later...
	install -m 755 -D $(MISCDIR)/ptx-init-permissions.sh $(ROOTDIR)/sbin/ptx-init-permissions.sh
	chmod a+x $(ROOTDIR)/etc/init.d/*
	chmod a+x $(ROOTDIR)/etc/rc.d/*

	# maintenance mode helper script
	install -m 755 -D $(MISCDIR)/maintenance $(ROOTDIR)/sbin/maintenance

	# grub configuration 
	install -d $(ROOTDIR)/boot/grub/
	cp $(TOPDIR)/etc/abbcc/menu.lst $(ROOTDIR)/boot/grub/menu.lst

	# RTAI scripts
	install -d $(ROOTDIR)/etc/init.d
	cp $(TOPDIR)/etc/abbcc/init.d/rtai $(ROOTDIR)/etc/init.d
	cp $(TOPDIR)/etc/abbcc/init.d/latency $(ROOTDIR)/etc/init.d

	touch $@
# vim: syntax=make
