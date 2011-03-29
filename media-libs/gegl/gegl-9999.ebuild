# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git autotools 

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"
EGIT_REPO_URI="git://git.gnome.org/gegl"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cairo debug doc ffmpeg jpeg mmx openexr png raw sdl sse svg v4l"

DEPEND=">=media-libs/babl-0.1.0
	media-libs/libpng
	>=x11-libs/gtk+-2.18.0
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	doc? ( app-text/asciidoc
		dev-lang/ruby
		>=dev-lang/lua-5.1.0
		app-text/enscript
		media-gfx/graphviz
		media-gfx/imagemagick )
	ffmpeg? ( virtual/ffmpeg )
	jpeg? ( media-libs/jpeg )
	openexr? ( media-libs/openexr )
	raw? ( >=media-libs/libopenraw-0.0.5 )
	sdl? ( media-libs/libsdl )
	svg? ( >=gnome-base/librsvg-2.14.0 )"

pkg_setup() {
	if use doc && ! built_with_use 'media-gfx/imagemagick' 'png'; then
		eerror "You must build imagemagick with png support"
		die "media-gfx/imagemagick built without png"
	fi
}

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf --with-gtk --with-pango --with-gdk-pixbuf \
		$(use_enable debug) \
		$(use_with cairo) \
		$(use_with cairo pangocairo) \
		$(use_with v4l libv4l) \
		$(use_enable doc docs) \
		$(use_with doc graphviz) \
		$(use_with doc lua) \
		$(use_enable doc workshop) \
		$(use_with ffmpeg libavformat) \
		$(use_with jpeg libjpeg) \
		$(use_enable mmx) \
		$(use_with openexr) \
		$(use_with png libpng) \
		$(use_with raw libopenraw) \
		$(use_with sdl) \
		$(use_with svg librsvg) \
		$(use_enable sse) \
		|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "einstall failed"
	find "${D}" -name '*.la' -delete
	dodoc AUTHORS NEWS || die "dodoc failed"
}
