# Distributed under the terms of the GNU General Public License v2
# 🦊 ❤ metatools: {autogen_id}

EAPI=7

inherit flag-o-matic meson

DESCRIPTION=""
HOMEPAGE="https://www.spice-space.org/usbredir.html"
SRC_URI="https://gitlab.freedesktop.org/spice/usbredir/-/archive/usbredir-0.13.0/usbredir-usbredir-0.13.0.tar.gz -> usbredir-usbredir-0.13.0.tar.gz"
S="${WORKDIR}/${PN}-usbredir-0.13.0"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="
    virtual/libusb:1
    dev-libs/glib:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS="README* TODO *.txt"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/spice-usbredir* "${S}" || die
	fi
}