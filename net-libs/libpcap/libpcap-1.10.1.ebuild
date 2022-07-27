# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools ltprune

DESCRIPTION="A system-independent library for user-level network packet capture"

SRC_URI="https://github.com/the-tcpdump-group/libpcap/tarball/c7642e2cc0c5bd65754685b160d25dc23c76c6bd -> libpcap-1.10.1-c7642e2.tar.gz"

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

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-pcap-config.patch
	"${FILESDIR}"/${PN}-1.10.0-usbmon.patch
)

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