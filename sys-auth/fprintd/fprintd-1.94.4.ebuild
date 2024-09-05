# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit meson pam python-any-r1

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/libfprint/fprintd"
SRC_URI="https://gitlab.freedesktop.org/libfprint/fprintd/-/archive/v1.94.4/fprintd-v1.94.4.tar.bz2 -> fprintd-v1.94.4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc pam static-libs"
RESTRICT="test"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	sys-auth/libfprint:2
	sys-auth/polkit
	pam? (
	sys-libs/pam
	sys-libs/pam_wrapper
	)
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	dev-util/intltool
	doc? ( dev-libs/libxml2 dev-libs/libxslt )
"

S=${WORKDIR}/${PN}-v${PV}

PATCHES=(
	${FILESDIR}/add-test-feature-and-make-tests-optional.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use pam)
		-Dgtk_doc=$(usex doc true false)
		-Dman=true
		-Dpam_modules_dir=$(getpam_mod_dir)
		-Dsystemd=false
		-Ddbus_service_dir="${EPREFIX}/usr/share/dbus-1/services"
		-Dlibsystemd=libelogind
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	dodoc AUTHORS NEWS README TODO
	newdoc pam/README README.pam_fprintd
}

pkg_postinst() {
	elog "Please take a look at README.pam_fprintd for integration docs."
}