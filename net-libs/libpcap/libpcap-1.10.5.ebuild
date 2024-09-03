# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools ltprune

DESCRIPTION="A system-independent library for user-level network packet capture"

SRC_URI="https://github.com/the-tcpdump-group/libpcap/tarball/bbcbc9174df3298a854daee2b3e666a4b6e5383a -> libpcap-1.10.5-bbcbc91.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="bluetooth dbus netlink rdma remote static-libs usb yydebug"

RDEPEND="
	bluetooth? ( net-wireless/bluez:= )
	dbus? ( sys-apps/dbus )
	netlink? ( dev-libs/libnl:3 )
	remote? ( virtual/libcrypt:= )
	rdma? ( sys-cluster/rdma-core )
	usb? ( virtual/libusb:1 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/yacc
	dbus? ( virtual/pkgconfig )
"

S=${WORKDIR}/${PN}-${P/_}

post_src_unpack() {
        if [ ! -d "${S}" ]; then
                mv the-tcpdump-group-libpcap* "${S}" || die
        fi
}

src_prepare() {
	default
	echo ${PV} > VERSION || die
	eautoreconf
}

src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable bluetooth) \
		$(use_enable dbus) \
		$(use_enable rdma) \
		$(use_enable remote) \
		$(use_enable usb) \
		$(use_enable yydebug) \
		$(use_with netlink libnl) \
		--enable-ipv6
}

src_compile() {
	emake all shared
}

src_install() {
	default
	dodoc CREDITS CHANGES VERSION TODO README.* doc/README.*
	# remove static libraries (--disable-static does not work)
	if ! use static-libs; then
		find "${ED}" -name '*.a' -exec rm {} + || die
	fi
	prune_libtool_files

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h portability.h
	fi
}