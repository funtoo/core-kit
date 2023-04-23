# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools usr-ldscript multilib-minimal

DESCRIPTION="Userspace access to USB devices (libusb-0.1 compat wrapper)"
HOMEPAGE="https://libusb.info"
SRC_URI="https://github.com/libusb/libusb-compat-0.1/tarball/3e8a88d296b5405902c22d2ada61937bd9a89415 -> libusb-compat-0.1-0.1.8-3e8a88d.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="*"
IUSE="debug examples"

RDEPEND="
	>=virtual/libusb-1-r1:1[${MULTILIB_USEDEP}]
	!dev-libs/libusb:0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libusb-config
)


post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libusb-libusb-compat-0.1-* "${S}" || die
	fi
}

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable debug debug-log)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	gen_usr_ldscript -a usb
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}