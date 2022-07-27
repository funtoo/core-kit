# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

MY_PV=${PV/_p*/}

DESCRIPTION="usbredir libraries and utilities"
HOMEPAGE="https://www.spice-space.org/usbredir.html"
SRC_URI="https://github.com/freedesktop/spice-usbredir/tarball/bc64f5e23eeb6cf144649de3a85fe85d1347c52d -> spice-usbredir-0.12.0-bc64f5e.tar.gz"

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