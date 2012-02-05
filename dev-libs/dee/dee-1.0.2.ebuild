
# $Header: $

EAPI=3

DESCRIPTION="Libdee is a library using DBus to provide objects allowing you
to create MVC programs across DBus."
HOMEPAGE="https://launchpad.net/dee"
SRC_URI="http://launchpad.net/${PN}/1.0/${PV}/+download/${P}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-util/gtk-doc
        dev-libs/gobject-introspection"

RDEPEND="${DEPEND}"

src_install (){
	dodoc README LICENSE
	emake DESTDIR="${D}" install
}
