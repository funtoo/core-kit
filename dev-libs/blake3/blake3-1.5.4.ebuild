# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="the official Rust and C implementations of the BLAKE3 cryptographic hash function"
HOMEPAGE="https://github.com/BLAKE3-team/BLAKE3"
SRC_URI="https://github.com/BLAKE3-team/BLAKE3/tarball/95e42b84fc4709974c7b23c7ae885989ab36c31e -> BLAKE3-1.5.4-95e42b8.tar.gz"

LICENSE="|| ( CC0-1.0 Apache-2.0 )"
SLOT="0/0"
KEYWORDS="*"
S="${WORKDIR}/BLAKE3-${PV}/c"

RDEPEND=""
DEPEND="${RDEPEND}"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mkdir -p "${S}"
		mv "${WORKDIR}"/BLAKE3-team-*/c/* "${S}" || die
	fi
}