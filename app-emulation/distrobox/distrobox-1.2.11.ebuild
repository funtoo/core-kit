# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Use any linux distribution inside your terminal"
HOMEPAGE="https://distrobox.privatedns.org/ https://github.com/89luca89/distrobox"
SRC_URI="https://github.com/89luca89/distrobox/tarball/462cfe90806412e751af7acdab5b400bf3ff1382 -> distrobox-1.2.11-462cfe9.tar.gz"

LICENSE="GPLv3"
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