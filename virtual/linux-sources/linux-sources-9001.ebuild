# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for Linux kernel sources"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
#KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

pkg_postinst() {
# Use case for this ... hack: /usr/src/linux-git and /usr/src/linux-stable-git. That's literally the only thing.
ewarn "By using and installing this profile's virtual version, Portage will no longer bother you about kernel releases or manage them."
ewarn "If you don't know the catastrophic degree of damage possible if you don't know what you are doing, please revert to"
ewarn "virtual/linux-sources-1 or earlier. Don't come crying to me if your system is broken. -- Diskmaster"
ewarn "Three years later, I don't even use this hack anymore."
}
