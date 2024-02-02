# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhboot/efivar/tarball/a77a4ffec000ad5dfc5d6394d208784672acda82 -> efivar-39-a77a4ff.tar.gz"

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
	sed -i 's@-DEFIVAR_BUILD_ENVIRONMENT $(HOST_MARCH)@-DEFIVAR_BUILD_ENVIRONMENT@' src/include/defaults.mk  || die
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