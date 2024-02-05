# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps toolchain-funcs

DESCRIPTION="Interactive monitor of Linux IO activity"
HOMEPAGE="https://github.com/Tomas-M/iotop"
SRC_URI="https://github.com/Tomas-M/iotop/releases/download/v1.26/iotop-1.26.tar.xz -> iotop-1.26.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="
	sys-libs/ncurses:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

FILECAPS=(
	cap_net_admin=eip usr/bin/iotop
)

src_compile() {
	emake V=1 CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)" NO_FLTO=1
}

src_install() {
	dobin iotop
	dodoc README.md
	doman iotop.8
}