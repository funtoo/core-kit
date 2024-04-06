# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="https://github.com/jca02266/lha https://lha.osdn.jp"
SRC_URI="https://github.com/jca02266/lha/archive/4f193b1e98700aa2bc9dfeef11943efc1f036154.zip -> lha-114i-4f193b1.zip"

LICENSE="lha"
SLOT="0"
KEYWORDS="*"

PATCHES=(
	"${FILESDIR}"/${P/_p*}-file-list-from-stdin.patch
)

post_src_unpack() {
	if [ ! -d "${WORKDIR}/${S}" ]; then
		mv "${WORKDIR}"/* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoheader
	eautoreconf
}

src_install() {
	default
	dodoc README.md INSTALL Hacking_of_LHa
}