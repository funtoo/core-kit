# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/f505324dac96a7f39b92ff85477c109d7efe6c5e -> starship-1.20.1-f505324.tar.gz
https://direct.funtoo.org/79/58/9b/79589b06ede558d1e80e06e7655f2036e5607b64088350a8aca9ea3edc1158b1772115d76fe67f28c843c9a948273b85556376ef285e0726141fb869b06bf703 -> starship-1.20.1-funtoo-crates-bundle-b1cd1bdefca30ce5920a3d988eebb8be834a9ac38ba591026edaebf304bd9b322dc76fa9dfa7c8dca1e75f29f4d0cbd337b3f917fb2c6d0213daea47afac2527.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE="libressl"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

DOCS="docs/README.md"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/starship-starship-* ${S} || die
}

src_install() {
	dobin target/release/${PN}
	default
}

pkg_postinst() {
	echo
	elog "Thanks for installing starship."
	elog "For better experience, it's suggested to install some Powerline font."
	elog "You can get some from https://github.com/powerline/fonts"
	echo
}