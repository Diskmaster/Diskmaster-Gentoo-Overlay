# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-4.26.00.ebuild,v 1.3 2009/11/25 14:26:31 maekke Exp $

inherit versionator

MY_P=fmodapi$(delete_all_version_separators)linux

DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org"
X86_URI="http://www.fmod.org/index.php/release/version/${MY_P}.tar.gz"
SRC_URI="
	x86? ( ${X86_URI} )
	amd64? (
		http://www.fmod.org/index.php/release/version/${MY_P}64.tar.gz
		multilib? ( ${X86_URI} )
	)"

LICENSE="fmod"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="examples multilib"

RDEPEND=""
DEPEND=""

RESTRICT="strip test"

QA_TEXTRELS="opt/fmodex/fmoddesignerapi/api/lib/*
opt/fmodex/api/lib/*
opt/fmodex/api/plugins/*"

do_install() {
	local fdest="/opt/fmodex${1:+-$1}"
	dodir "${fdest}"

	local fbits
	[[ "$1" == "64" ]] && fbits="64"
	fsource="${WORKDIR}/${MY_P}${fbits}"

	cd "${fsource}"/api/lib

	cp -f libfmodex${fbits}-${PV}.so libfmodex.so.${PV} || die
	cp -f libfmodexp${fbits}-${PV}.so libfmodexp.so.${PV} || die
	cp -f libfmodex${fbits}L-${PV}.so libfmodexL.so.${PV} || die

	ln -sf libfmodex.so.${PV} libfmodex.so || die
	ln -sf libfmodex.so.${PV} libfmodex.so.4 || die
	ln -sf libfmodexp.so.${PV} libfmodexp.so || die
	ln -sf libfmodexp.so.${PV} libfmodexp.so.4 || die
	ln -sf libfmodexL.so.${PV} libfmodexL.so || die
	ln -sf libfmodexL.so.${PV} libfmodexL.so.4 || die

	cp -dpR "${fsource}"/* "${D}"/"${fdest}" || die

	ldpath+=( "${fdest}/api/lib" )

	use examples || rm -rf "${D}"/"${fdest}"/{,fmoddesignerapi}/examples
}

src_install() {
	local fsource ldpath
	declare -a ldpath
	if use x86; then
		do_install
	elif use amd64; then
		use multilib && do_install 32
		rm -rf "${D}"/"${fdest}"/{documentation,fmoddesignerapi/*.TXT}
		do_install 64
		dosym /opt/fmodex-64 /opt/fmodex
	else
		die
	fi
	local oldIFS="$IFS" IFS=":"
	echo "LDPATH=\"${ldpath[*]}\"" >> "${T}"/65fmodex
	IFS="$oldIFS"

	dodir /usr/include
	dosym /opt/fmodex/api/inc /usr/include/fmodex || die

	insinto /usr/share/doc/${PF}/pdf
	doins "${fsource}"/documentation/*.pdf
	dodoc "${fsource}"/{documentation/*.txt,fmoddesignerapi/*.TXT}
	rm -rf "${D}"/"${fdest}"/{documentation,fmoddesignerapi/*.TXT}

	doenvd "${T}"/65fmodex
}
