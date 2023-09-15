# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhboot/efivar/tarball/c1d6b10e1ed4ba2be07f385eae5bceb694478a10 -> efivar-37-c1d6b10.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="*"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/mandoc
	test? ( sys-boot/grub:2 )
"
RDEPEND="
	dev-libs/popt
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.18
	virtual/pkgconfig
"
post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv ${WORKDIR}/rhboot-* ${S} || die
	fi
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/efivar-38-ia64-relro.patch
		"${FILESDIR}"/efivar-38-march-native.patch
		"${FILESDIR}"/efivar-38-Makefile-dep.patch
		"${FILESDIR}"/efivar-38-binutils-2.36.patch
	)
	default
}

src_configure() {
	unset CROSS_COMPILE
	export COMPILER=$(tc-getCC)
	export HOSTCC=$(tc-getBUILD_CC)

	tc-ld-disable-gold

	export libdir="/usr/$(get_libdir)"

	# https://bugs.gentoo.org/562004
	unset LIBS

	# Avoid -Werror
	export ERRORS=

	if [[ -n ${GCC_SPECS} ]]; then
		# The environment overrides the command line.
		GCC_SPECS+=":${S}/src/include/gcc.specs"
	fi

	# Used by tests/Makefile
	export GRUB_PREFIX=grub
}