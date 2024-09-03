# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson udev

DESCRIPTION="Library to add support for consumer fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/libfprint"
SRC_URI="https://gitlab.freedesktop.org/libfprint/libfprint/-/archive/v1.94.8/libfprint-v1.94.8.tar.bz2 -> libfprint-v1.94.8.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="*"
IUSE="examples gtk-doc +introspection"
RESTRICT="test"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev
	dev-libs/nss
	dev-python/pygobject
	dev-libs/libgusb
	x11-libs/pixman
	examples? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? (
		dev-libs/gobject-introspection
		dev-libs/libgusb[introspection]
	)
"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	local emesonargs=(
		$(meson_use examples gtk-examples)
		$(meson_use gtk-doc doc)
		$(meson_use introspection introspection)
		-Ddrivers=aes1610,aes1660,aes2501,aes2550,aes2660,aes3500,aes4000,elan,elanmoc,elanspi,etes603,egis0570,goodixmoc,fpcmoc,nb1010,synaptics,upeksonly,upektc,upektc_img,upekts,uru4000,vcom5s,vfs0050,vfs101,vfs301,vfs5011
		-Dinstalled-tests=false
		-Dudev_rules=enabled
		-Dudev_rules_dir=$(get_udevdir)/rules.d
	)

	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}