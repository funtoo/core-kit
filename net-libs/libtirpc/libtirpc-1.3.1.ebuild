# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs usr-ldscript

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="https://sourceforge.net/projects/libtirpc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-glibc-nfs.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # subslot matches SONAME major
KEYWORDS="*"
IUSE="ipv6 kerberos static-libs"

RDEPEND="kerberos? ( >=virtual/krb5-0-r1 )"
DEPEND="${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	cp -r "${WORKDIR}"/tirpc "${S}"/ || die
	default
}

src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		$(use_enable kerberos gssapi)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	default

	# libtirpc replaces rpc support in glibc, so we need it in /
	gen_usr_ldscript -a tirpc
}

src_install_all() {
	einstalldocs

	insinto /etc
	doins doc/netconfig

	insinto /usr/include/tirpc
	doins -r "${WORKDIR}"/tirpc/*

	# makes sure that the linking order for nfs-utils is proper, as
	# libtool would inject a libgssglue dependency in the list.
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -delete || die
	fi
}
