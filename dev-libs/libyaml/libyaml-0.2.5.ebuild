# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool

DESCRIPTION="A C library for parsing and emitting YAML"
HOMEPAGE="https://github.com/yaml/libyaml"
SRC_URI="https://github.com/yaml/libyaml/tarball/65d19898a301b817261003b00d1dcef00895a7b4 -> libyaml-0.2.5-65d1989.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv ${WORKDIR}/yaml-* ${S} || die
	fi
}

src_prepare() {
	default

	# conditionally remove tests
	if ! use test; then
		sed -i -e 's: tests::g' Makefile* || die
	fi

	elibtoolize
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
}