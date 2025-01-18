# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern replacement for ps written in Rust"
HOMEPAGE="https://github.com/dalance/procs"
SRC_URI="https://github.com/dalance/procs/tarball/2a0ba5c900b90a510a7fd1f21f8efe4b827c4b22 -> procs-0.14.9-2a0ba5c.tar.gz
https://direct.funtoo.org/03/d8/56/03d85601d516964e810897768068e5b280d8a329ab56850cace76ff1f854cded2405e35f9fb9de0057d6e36f11ef8cd7a14a7c7ba2c48a2016ad17d56a58b9fa -> procs-0.14.9-funtoo-crates-bundle-e11585914c4ac140700fb8c0feaf33a23a9206a265eb20db6fd6a24e5272dd1c605a5ccc1d370cb993d566ed2b3d4e0bb46ecc31dc40facf5e0a66aaefaba02f.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT ZLIB"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/rust"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/dalance-procs-* ${S} || die
}

src_install() {
	# Avoid calling doman from eclass. It fails.
	rm -rf ${S}/man
	cargo_src_install
	dodoc README.md
}