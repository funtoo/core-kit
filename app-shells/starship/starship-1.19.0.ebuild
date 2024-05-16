# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/de2c4a63553568adcba95432acfbe36080cc6be8 -> starship-1.19.0-de2c4a6.tar.gz
https://direct.funtoo.org/53/fe/2b/53fe2b1bb8a8b4ed878cc61b912ff66c84935acc646e2a8b10c1e637f21c74ce1f3d6965f27a9b4db0f4bb8c3613c638f4b9ac97344625522ef739ae2bc405a6 -> starship-1.19.0-funtoo-crates-bundle-412f8695ad90d8e49450c122eda782b0cda8c1b6c342139738870eadbab392e0cf0fb8aec862f22dbd98f8907535e988fb6c7760c94578011b43c1b74f38caec.tar.gz"
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