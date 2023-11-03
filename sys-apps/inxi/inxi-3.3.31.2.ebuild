# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The CLI inxi collects and prints hardware and system information"
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://api.github.com/repos/smxi/inxi/tarball/refs/tags/3.3.31-2 -> inxi-3.3.31.2.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="bluetooth hddtemp opengl"

RDEPEND="
	dev-lang/perl
	sys-apps/pciutils
	sys-apps/usbutils
	bluetooth? ( net-wireless/bluez )
	hddtemp? ( app-admin/hddtemp )
	opengl? ( x11-apps/mesa-progs )
"

post_src_unpack() {
	mv "${WORKDIR}"/smxi-inxi-* "${S}" || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.txt
}