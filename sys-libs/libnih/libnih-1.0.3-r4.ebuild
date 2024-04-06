# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs usr-ldscript

DESCRIPTION="Light-weight 'standard library' of C functions"
HOMEPAGE="https://launchpad.net/libnih"
SRC_URI="https://github.com/keybuk/libnih/tarball/e4edea5653e700a07c67f714ab8b7c63179f3be2 -> libnih-1.0.3-e4edea5.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+dbus nls static-libs +threads"

S="${WORKDIR}/keybuk-libnih-e4edea5"

RDEPEND="dbus? ( dev-libs/expat >=sys-apps/dbus-1.2.16 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	${FILESDIR}/${P}-optional-dbus.patch
)

src_prepare() {
	default
	sed \
		-e '/^pkgconfigdir/s:prefix)/lib:libdir):' \
		-i nih-dbus/Makefile.am
	sed \
		-e '/^pkgconfigdir/s:prefix)/lib:libdir):' \
		-i nih/Makefile.am
	sed \
		-e 's:char \*output_package:extern char \*output_package:' \
		-i nih-dbus-tool/output.h
	eautoreconf
}

src_configure() {
	append-lfs-flags
	econf \
		$(use_with dbus) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_enable threads threading)
}

src_install() {
	default

	# we need to be in / because upstart needs libnih
	gen_usr_ldscript -a nih $(use dbus && echo nih-dbus)
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.la
}