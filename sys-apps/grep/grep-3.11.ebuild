# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="GNU regular expression matcher"
HOMEPAGE="https://www.gnu.org/software/grep/"
SRC_URI="https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz -> grep-3.11.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="nls pcre static"

LIB_DEPEND="pcre? ( dev-libs/libpcre2[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	nls? ( virtual/libintl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	sed -i \
		-e "s:@SHELL@:${EPREFIX}/bin/sh:g" \
		-e "s:@grep@:${EPREFIX}/bin/grep:" \
		src/egrep.sh || die #523898

	default
}

src_configure() {
	use static && append-ldflags -static
	# don't link against libsigsegv even when available
	export ac_cv_libsigsegv=no

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		$(use_enable nls)
		$(use_enable pcre perl-regexp)
	)
	econf "${myeconfargs[@]}"
}