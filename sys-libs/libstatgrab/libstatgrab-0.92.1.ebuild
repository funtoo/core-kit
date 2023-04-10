# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTORECONF=frob
inherit autotools

DESCRIPTION=""
HOMEPAGE="https://www.i-scream.org/libstatgrab/"
SRC_URI="https://github.com/libstatgrab/libstatgrab/archive/refs/tags/LIBSTATGRAB_0_92_1.tar.gz -> libstatgrab-0.92.1.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT=0
KEYWORDS="*"
IUSE="examples perl static-libs"

RDEPEND="sys-libs/ncurses
	dev-libs/log4cplus
	app-text/docbook2X
	perl? ( virtual/perl )
"
DEPEND="${RDEPEND}"

DOCS=( PLATFORMS NEWS AUTHORS README )

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libstatgrab-LIBSTATGRAB_0_92_1* "${S}" || die
	fi
}

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	local myconf=(
		--disable-setgid-binaries
		--disable-setuid-binaries
		--enable-man
		--with-ncurses
		--with-log4cplus
		$(use_enable static-libs static)
		$(use_with perl perl5)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi

	find "${ED}" -name '*.la' -delete || die
}