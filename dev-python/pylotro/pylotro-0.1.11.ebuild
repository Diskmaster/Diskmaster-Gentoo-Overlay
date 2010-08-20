# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: kardasa $

EAPI="2"

inherit games distutils

DESCRIPTION="Lord of the Rings Online and Dungeons & Dragons Online Luncher"
HOMEPAGE="http://www.lotrolinux.com/"
SRC_URI="http://www.lotrolinux.com/PyLotRO-${PV}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND=">=dev-lang/python-2.5
	dev-python/PyQt4
	dev-python/4suite"

RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	rm "${D}"/usr/bin/pylotro
	dogamesbin ${PN} || die "dogamesbin failed"
	prepgamesdirs
}

pkg_postinst() {
	elog "You will need a proper wine or crossover-game"
	elog "installation to lunch the game"
	elog "more information how to run the games in linux you will find by visiting:"
	elog "http://www.codeweavers.com/compatibility/browse/group/?app_parent=4029"
	elog "or http://appdb.winehq.org/objectManager.php?sClass=version&iId=14566"
}
