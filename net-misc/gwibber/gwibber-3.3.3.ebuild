# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gwibber/gwibber-3.1.0.ebuild,v 1.3 2011/07/07 18:14:12 hwoarang Exp $

EAPI="3"
PYTHON_USE_WITH="sqlite"

inherit eutils

DESCRIPTION="Gwibber is an open source microblogging client for GNOME developed
with Python and GTK."
HOMEPAGE="https://launchpad.net/gwibber"
SRC_URI="http://launchpad.net/${PN}/3.4/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/dbus-python-0.80.2
	>=dev-python/gconf-python-2.18.0
	dev-python/gnome-keyring-python
	>=dev-python/imaging-1.1.6
	>=dev-python/notify-python-0.1.1
	>=dev-python/pywebkitgtk-1.0.1
	>=dev-python/simplejson-1.9.1
	>=dev-python/egenix-mx-base-3.0.0
	>=dev-python/python-distutils-extra-2.15
	>=dev-python/pycurl-7.19.0
	>=dev-python/libwnck-python-2.26.0
	>=dev-python/feedparser-4.1
	>=dev-python/pyxdg-0.15
	>=dev-python/mako-0.2.4
	>=dev-python/pygtk-2.16
	dev-python/oauth
	>=gnome-base/librsvg-2.22.2
	>=dev-libs/dee-1.0
	net-misc/curl
	>=dev-lang/vala-1.15
	app-text/gtkspell:3
	"

DOC="AUTHORS README"

src_prepare() {
	epatch "$FILESDIR"/gwibber-twitter-api-key.patch
	epatch "$FILESDIR"/gwibber-fix-uuid-import.patch
	epatch "$FILESDIR"/gtkspell-pc-path.patch
}

src_configure() {
	# we have no unity to build against
	econf  --disable-unity
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install
	elog "A new Twitter API is used. If your old accounts fail to work, try to"
	elog "re-add them."
}
