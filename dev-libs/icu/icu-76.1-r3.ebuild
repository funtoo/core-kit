# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit autotools python-any-r1 toolchain-funcs

MY_PV=${PV/_rc/-rc}
MY_PV=${MY_PV//./_}

DESCRIPTION="International Components for Unicode"
HOMEPAGE="https://icu.unicode.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-src.tgz"
S="${WORKDIR}"/${PN}/source
KEYWORDS="*"
LICENSE="BSD"
SLOT="0/${PV%.*}"
IUSE="debug doc examples static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	sys-devel/autoconf
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

PATCHES=(
	# `pkg-config icu-i18n --libs` will not include -licuuc which is needed for
	# undefined symbols in icu-i18n so that it links properly with eg. libxml2.
	"${FILESDIR}/${PN}-76.1-undo-pkgconfig-change-for-now.patch"
)

src_prepare() {
	default

	# TODO: switch uconfig.h hacks to use uconfig_local
	#
	# Disable renaming as it assumes stable ABI and that consumers
	# won't use unofficial APIs. We need this despite the configure argument.
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		common/unicode/uconfig.h || die
	#
	# ODR violations, experimental API
	sed -i \
		-e "s/#   define UCONFIG_NO_MF2 0/#define UCONFIG_NO_MF2 1/" \
		common/unicode/uconfig.h || die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		config/mh-linux || die

	# Append doxygen configuration to configure
	sed -i \
		-e 's:icudefs.mk:icudefs.mk Doxyfile:' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-renaming
		--disable-samples
		--enable-layoutex
		--enable-tools
		$(use_enable debug)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable examples samples)
	)

	# ICU tries to use clang by default
	tc-export CC CXX

	# Make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL="${EPREFIX}/bin/sh"
	# Probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL="${BASH}"
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
	fi
}

src_test() {
	# INTLTEST_OPTS: intltest options
	#   -e: Exhaustive testing
	#   -l: Reporting of memory leaks
	#   -v: Increased verbosity
	# IOTEST_OPTS: iotest options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	# CINTLTST_OPTS: cintltst options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	emake check
}

src_install() {
	default
	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}
