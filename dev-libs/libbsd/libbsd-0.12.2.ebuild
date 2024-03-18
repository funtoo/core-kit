# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to provide useful functions commonly found on BSD systems"
HOMEPAGE="https://libbsd.freedesktop.org/wiki/ https://gitlab.freedesktop.org/libbsd/libbsd"
SRC_URI="https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz -> libbsd-0.12.2.tar.xz"

LICENSE="BSD BSD-2 BSD-4 ISC"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="app-crypt/libmd[static-libs?]"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.17
"
BDEPEND=""

src_configure() {
	# The build system will install libbsd-ctor.a despite USE="-static-libs"
	# which is correct, see:
	# https://gitlab.freedesktop.org/libbsd/libbsd/commit/c5b959028734ca2281250c85773d9b5e1d259bc8
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install

	find "${ED}" -type f -name "*.la" -delete || die
}