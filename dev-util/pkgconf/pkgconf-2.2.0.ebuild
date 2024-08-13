# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/pkgconf/pkgconf/tarball/06120a8769aed87d50e914f87a6f9f67110cf16e -> pkgconf-2.2.0-06120a8.tar.gz"
KEYWORDS="*"
S="${WORKDIR}/${P/_/}"

inherit autotools multilib multilib-minimal

DESCRIPTION="pkg-config compatible replacement with no dependencies other than ANSI C89"
HOMEPAGE="https://github.com/pkgconf/pkgconf"

LICENSE="ISC"
SLOT="0/3"
IUSE="+pkg-config test"

# tests require 'kyua'
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
RDEPEND="
	pkg-config? (
		!dev-util/pkgconfig
		!dev-util/pkg-config-lite
		!dev-util/pkgconfig-openbsd[pkg-config]
	)
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pkgconf$(get_exeext)
)

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/pkgconf-pkgconf"* "$S" || die
}

src_prepare() {
	default
	./autogen.sh
	eautoreconf
	if use pkg-config; then
		MULTILIB_CHOST_TOOLS+=(
			/usr/bin/pkg-config$(get_exeext)
		)
	fi
}

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	local args=(
		--with-system-includedir="${EPREFIX}/usr/include"
		--with-system-libdir="${EPREFIX}/$(get_libdir):${EPREFIX}/usr/$(get_libdir)"
	)
	econf "${args[@]}"
}

multilib_src_test() {
	unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
	default
}

multilib_src_install() {
	default

	if use pkg-config; then
		dosym pkgconf$(get_exeext) /usr/bin/pkg-config$(get_exeext)
	else
		rm "${ED%/}"/usr/share/aclocal/pkg.m4 || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}