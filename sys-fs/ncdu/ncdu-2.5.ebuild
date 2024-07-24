# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu/"
SRC_URI="https://dev.yorhel.nl/download/ncdu-2.5.tar.gz -> ncdu-2.5.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

DEPEND="sys-libs/ncurses:="
BDEPEND="virtual/zig"

RDEPEND="${DEPEND}"

src_install() {
	emake PREFIX="${ED}"/usr install
}