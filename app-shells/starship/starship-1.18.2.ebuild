# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/4131edaa609887b866a5497648858fe6d39a3f99 -> starship-1.18.2-4131eda.tar.gz
https://direct.funtoo.org/97/46/6b/97466bff48930cdc58abf1e4c34c06fbd9f62dfadca0042f15d99d55f2f328e7f479ebbdd437a179f6521d26389738acbf21976e7dd8dba0d35e590193f4ff66 -> starship-1.18.2-funtoo-crates-bundle-2dfeb6d5f8377ea9eec4e8a1b3a4e683a201c49f00f8556817f09f2a66daa1d6ddd1a7b2c503b7c0095070c840dc4c7be0555719a0865268c856f6358b58b382.tar.gz"
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