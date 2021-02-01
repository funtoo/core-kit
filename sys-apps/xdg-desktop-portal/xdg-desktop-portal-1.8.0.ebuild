# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit systemd

SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"
DESCRIPTION="A portal frontend service for Flatpak and possibly other containment frameworks"
HOMEPAGE="http://flatpak.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="doc geolocation screencast test"

RDEPEND="
	dev-libs/json-glib
	dev-libs/glib:2[dbus]
	media-libs/fontconfig
	sys-fs/fuse:0
	geolocation? ( >=app-misc/geoclue-2.5.2:2.0 )
	screencast? ( >=media-video/pipewire-0.2.90 )
	test? ( sys-libs/libportal )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.3
	)
"

src_configure() {

	econf \
		$(use_enable doc docbook-docs) \
		$(use_enable geolocation geoclue) \
		$(use_enable screencast pipewire) \
		$(use_enable test libportal) \
		--with-systemduserunitdir="$(systemd_get_userunitdir)"

}
