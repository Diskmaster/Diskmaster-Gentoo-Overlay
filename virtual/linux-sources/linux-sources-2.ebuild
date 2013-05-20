# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/linux-sources/linux-sources-1.ebuild,v 1.2 2013/02/14 15:21:59 jer Exp $

EAPI=2

DESCRIPTION="Virtual for Linux kernel sources"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="firmware"

DEPEND="firmware? ( sys-kernel/linux-firmware )"
RDEPEND=""
#RDEPEND="|| (
#		sys-kernel/gentoo-sources
#		sys-kernel/vanilla-sources
#		sys-kernel/ck-sources
#		sys-kernel/git-sources
#		sys-kernel/hardened-sources
#		sys-kernel/mips-sources
#		sys-kernel/openvz-sources
#		sys-kernel/pf-sources
#		sys-kernel/rsbac-sources
#		sys-kernel/rt-sources
#		sys-kernel/tuxonice-sources
#		sys-kernel/usermode-sources
#		sys-kernel/vserver-sources
#		sys-kernel/xbox-sources
#		sys-kernel/zen-sources
#		sys-kernel/aufs-sources
#	)"
 pkg_postinst() {
	ewarn "BE CAREFUL WHAT YOU ARE DOING. THIS VERSION OF THE VIRTUAL SPECIFICALLY REMOVES PORTAGE'S NEED"
	ewarn "TO INSTALL ANY SORT OF KERNEL SOURCES. IF YOU HAVE DONE THIS WITHOUT ANY THOUGHT TO WHAT"
	ewarn "THIS COULD DO TO YOUR SYSTEM, PLEASE DOWNGRADE TO AN EARLIER VERSION OF THE VIRTUAL."
}
