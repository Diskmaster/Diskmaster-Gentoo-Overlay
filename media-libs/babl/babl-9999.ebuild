# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git autotools

DESCRIPTION="Dynamic, any to any, pixel format conversion library"
HOMEPAGE="http://www.gegl.org/babl/"

EGIT_REPO_URI="git://git.gnome.org/babl"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sse mmx"

DEPEND="
	gnome-base/librsvg
"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	eautoreconf || die "eautoreconf failed" 
}

src_configure() {
	econf $(use_enable mmx) \
		$(use_enable sse) \
		|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	find "${D}" -name '*.la' -delete
	dodoc AUTHORS NEWS || die "dodoc failed"
}
