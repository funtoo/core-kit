# Distributed under the terms of the GNU General Public License v2
# 🦊 ❤ metatools: {autogen_id}

EAPI=7

inherit flag-o-matic meson

DESCRIPTION=""
HOMEPAGE="https://www.spice-space.org/usbredir.html"
SRC_URI="https://gitlab.freedesktop.org/spice/usbredir/uploads/211844dd64853ca4378ad7e74faf3e00/usbredir-0.13.0.tar.xz -> usbredir-0.13.0-5fc0e1c4.tar.xz"

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
		mv "${WORKDIR}"/spice-usbredir* "${S}" || die
	fi
}