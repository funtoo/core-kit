# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
SRC_URI="https://github.com/legionus/kbd/archive/refs/tags/v2.4.0.tar.gz -> kbd-2.4.0.tar.gz"

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="http://kbd-project.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls pam"

RDEPEND="
	app-arch/gzip
	pam? (
		!app-misc/vlock
		sys-libs/pam
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_unpack() {
	default
	# Rename conflicting keymaps to have unique names, bug #293228
	cd "${S}"/data/keymaps/i386 || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable pam vlock)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	docinto html
	dodoc docs/doc/*.html
}