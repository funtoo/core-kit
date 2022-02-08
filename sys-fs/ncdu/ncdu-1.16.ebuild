# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu/"
SRC_URI="https://dev.yorhel.nl/download/ncdu-1.16.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

DEPEND="sys-libs/ncurses:=[unicode(+)]"

RDEPEND="${DEPEND}"