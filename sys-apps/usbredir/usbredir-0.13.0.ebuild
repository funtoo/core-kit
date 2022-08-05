# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

MY_PV=${PV/_p*/}

DESCRIPTION="usbredir libraries and utilities"
HOMEPAGE="https://www.spice-space.org/usbredir.html"
SRC_URI="https://github.com/freedesktop/spice-usbredir/tarball/5fc0e1c43194d948545941d408f4c10d084eb6ed -> spice-usbredir-0.13.0-5fc0e1c.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS="README* TODO *.txt"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/freedesktop-spice-usbredir* "${S}" || die
	fi
}