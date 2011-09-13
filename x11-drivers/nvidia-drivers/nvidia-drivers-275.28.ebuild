# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils versionator linux-mod flag-o-matic nvidia-driver

X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${PV}"
X86_FBSD_NV_PACKAGE="NVIDIA-FreeBSD-x86-${PV}"

DESCRIPTION="NVIDIA GPUs kernel drivers"
HOMEPAGE="http://www.nvidia.com/"
SRC_URI="x86? ( http://download.nvidia.com/XFree86/Linux-x86/${PV}/${X86_NV_PACKAGE}.run )
	 amd64? ( http://download.nvidia.com/XFree86/Linux-x86_64/${PV}/${AMD64_NV_PACKAGE}.run )
	 x86-fbsd? ( http://download.nvidia.com/XFree86/FreeBSD-x86/${PV}/${X86_FBSD_NV_PACKAGE}.tar.gz )"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
IUSE="acpi custom-cflags multilib kernel_linux"
RESTRICT="strip"

DEPEND="kernel_linux? ( virtual/linux-sources )"
RDEPEND="~x11-drivers/nvidia-userspace-${PV}
	multilib? ( ~x11-drivers/nvidia-userspace-${PV}[multilib] )
	x11-libs/libXvMC
	acpi? ( sys-power/acpid )"
PDEPEND=">=x11-libs/libvdpau-0.3-r1"

S="${WORKDIR}/"

mtrr_check() {
	ebegin "Checking for MTRR support"
	linux_chkconfig_present MTRR
	eend $?

	if [[ $? -ne 0 ]] ; then
		eerror "Please enable MTRR support in your kernel config, found at:"
		eerror
		eerror "  Processor type and features"
		eerror "    [*] MTRR (Memory Type Range Register) support"
		eerror
		eerror "and recompile your kernel ..."
		die "MTRR support not detected!"
	fi
}

lockdep_check() {
	if linux_chkconfig_present LOCKDEP; then
		eerror "You've enabled LOCKDEP -- lock tracking -- in the kernel."
		eerror "Unfortunately, this option exports the symbol "
		eerror "'lockdep_init_map' as GPL-only which will prevent "
		eerror "${P} from compiling."
		eerror "Please make sure the following options have been unset:"
		eerror
		eerror "    Kernel hacking  --->"
		eerror "        [ ] Lock debugging: detect incorrect freeing of live locks"
		eerror "        [ ] Lock debugging: prove locking correctness"
		eerror "        [ ] Lock usage statistics"
		eerror "in 'menuconfig'"
		die "LOCKDEP enabled"
	fi
}

pkg_setup() {
	if use kernel_linux; then
		linux-mod_pkg_setup
		MODULE_NAMES="nvidia(video:${S}/kernel)"
		BUILD_PARAMS="IGNORE_CC_MISMATCH=yes V=1 SYSSRC=${KV_DIR} \
		SYSOUT=${KV_OUT_DIR} HOST_CC=$(tc-getBUILD_CC)"
		mtrr_check
		lockdep_check
	fi

	# On BSD userland it wants real make command
	use userland_BSD && MAKE="$(get_bmake)"

	export _POSIX2_VERSION="199209"

	# Since Nvidia ships 3 different series of drivers, we need to give the user
	# some kind of guidance as to what version they should install. This tries
	# to point the user in the right direction but can't be perfect. check
	# nvidia-driver.eclass
	nvidia-driver-check-warning

	# set variables to where files are in the package structure
	if use kernel_FreeBSD; then
		NV_SRC="${S}/src"
	elif use kernel_linux; then
		NV_SRC="${S}/kernel"
	else
		die "Could not determine proper NVIDIA package"
	fi
}

src_unpack() {
	if use kernel_linux && kernel_is lt 2 6 7; then
		echo
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
		ewarn "This is not officially supported for ${P}. It is likely you"
		ewarn "will not be able to compile or use the kernel module."
		ewarn "It is recommended that you upgrade your kernel to a version >= 2.6.7"
		echo
		ewarn "DO NOT file bug reports for kernel versions less than 2.6.7 as they will be ignored."
	fi

	if ! use x86-fbsd; then
		cd "${S}"
		unpack_makeself
	else
		unpack ${A}
	fi
}

src_prepare() {
	# Please add a brief description for every added patch
	use x86-fbsd && cd doc

	if use kernel_linux; then
		# Quiet down warnings the user does not need to see
		sed -i \
			-e 's:-Wsign-compare::g' \
			"${NV_SRC}"/Makefile.kbuild

		# Add support for the 'x86' unified kernel arch in conftest.sh
		epatch "${FILESDIR}"/256.35-unified-arch.patch

		# If you set this then it's your own fault when stuff breaks :)
		use custom-cflags && sed -i "s:-O:${CFLAGS}:" "${NV_SRC}"/Makefile.*

		# If greater than 2.6.5 use M= instead of SUBDIR=
		convert_to_m "${NV_SRC}"/Makefile.kbuild
	fi
}

src_compile() {
	# This is already the default on Linux, as there's no toplevel Makefile, but
	# on FreeBSD there's one and triggers the kernel module build, as we install
	# it by itself, pass this.

	cd "${NV_SRC}"
	if use x86-fbsd; then
		MAKE="$(get_bmake)" CFLAGS="-Wno-sign-compare" emake CC="$(tc-getCC)" \
			LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)" || die
	elif use kernel_linux; then
		linux-mod_src_compile
	fi
}

src_install() {
	if use kernel_linux; then
		linux-mod_src_install
	elif use x86-fbsd; then
		insinto /boot/modules
		doins "${WORKDIR}/${NV_PACKAGE}/src/nvidia.kld" || die

		exeinto /boot/modules
		doexe "${WORKDIR}/${NV_PACKAGE}/src/nvidia.ko" || die
	fi

	# Gentoo bug #375615 -- GTK apps hanging
	doenvd "${FILESDIR}"/10nvidia
}

pkg_preinst() {
	if use kernel_linux; then
		linux-mod_pkg_postinst
	fi
}

pkg_postinst() {
	if use kernel_linux; then
		linux-mod_pkg_postinst
	fi

	echo
	elog "You must be in the video group to use the NVIDIA device"
	elog "For more info, read the docs at"
	elog "http://www.gentoo.org/doc/en/nvidia-guide.xml#doc_chap3_sect6"
	elog

	elog "This package installs a kernel module and X driver. Both must"
	elog "match explicitly in their version. This means, if you restart"
	elog "X, you must modprobe -r nvidia before starting it back up"
	elog

}

pkg_postrm() {
	if use kernel_linux; then
		linux-mod_pkg_postrm
	fi
}
