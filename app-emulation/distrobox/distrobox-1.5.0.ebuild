# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution you’re more comfortable with. Mirror available at: https://gitlab.com/89luca89/distrobox"
HOMEPAGE="https://distrobox.privatedns.org/ https://github.com/89luca89/distrobox"
SRC_URI="https://github.com/89luca89/distrobox/tarball/67c5cb19719f164e662d8d29214c65aca5a58c56 -> distrobox-1.5.0-67c5cb1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	app-emulation/docker
"
RDEPEND="${DEPEND}"
BDEPEND=""

post_src_unpack() {
	mv "${WORKDIR}"/89luca89-distrobox-* "${S}" || die
}

src_install() {
	mkdir -p "${D}"/usr/bin
	./install -p "${D}"/usr/bin
}