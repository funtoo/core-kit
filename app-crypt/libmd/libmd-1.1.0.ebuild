# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
SRC_URI="https://archive.hadrons.org/software/libmd/libmd-1.1.0.tar.xz -> libmd-1.1.0.tar.xz"

IUSE="static-libs"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"
KEYWORDS="*"

DOCS="ChangeLog README"

src_install() {
	default
	use static-libs || find "${ED}" -type f -name "*.a" -delete || die
	find "${ED}" -type f -name "*.la" -delete || die
	insinto /usr/$(get_libdir)/pkgconfig/
	doins src/libmd.pc
}