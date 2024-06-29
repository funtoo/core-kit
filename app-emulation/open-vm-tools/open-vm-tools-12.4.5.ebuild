# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info pam systemd toolchain-funcs

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
MY_P="${PN}-${PV/_p/-}"
SRC_URI="https://github.com/vmware/open-vm-tools/tarball/9b94132f54fbed0b86dce04ff4402d1d8fd059c3 -> open-vm-tools-12.4.5-9b94132.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +deploypkg +dnet doc +fuse gtkmm +icu multimon pam +resolutionkms +ssl static-libs +vgauth systemd"
REQUIRED_USE="
	multimon? ( X )
	vgauth? ( ssl )
"

PATCHES=(
	"${FILESDIR}/11.3.5-icu.patch"
)

RDEPEND="
	dev-libs/glib
	net-libs/libtirpc
	deploypkg? ( dev-libs/libmspack )
	fuse? ( sys-fs/fuse:0 )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl:0 )
	vgauth? (
		dev-libs/libxml2
		dev-libs/xmlsec
	)
	X? (
		x11-libs/libXext
		multimon? ( x11-libs/libXinerama )
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
		x11-libs/libSM
		x11-libs/libXcomposite
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		gtkmm? (
			dev-cpp/gtkmm:3.0
			dev-libs/libsigc++:2
		)
	)
	dnet? ( dev-libs/libdnet )
	icu? ( dev-libs/icu:= )
	resolutionkms? (
		x11-libs/libdrm[video_cards_vmware]
		virtual/libudev
	)
"

DEPEND="${RDEPEND}
	net-libs/rpcsvc-proto
"

BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/vmware-*/open-vm-tools/ "${S}"
}

pkg_setup() {
	local CONFIG_CHECK="~VMWARE_BALLOON ~VMWARE_PVSCSI ~VMXNET3"
	use X && CONFIG_CHECK+=" ~DRM_VMWGFX"
	kernel_is -lt 3 9 || CONFIG_CHECK+=" ~VMWARE_VMCI ~VMWARE_VMCI_VSOCKETS"
	kernel_is -lt 3 || CONFIG_CHECK+=" ~FUSE_FS"
	kernel_is -lt 5 5 || CONFIG_CHECK+=" ~X86_IOPL_IOPERM"
	linux-info_pkg_setup
}

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user

	# Drop -Werror
	sed -e 's|^CFLAGS="$CFLAGS -Werror"||g' -i configure.ac

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-glibc-check
		--without-root-privileges
		$(use_enable multimon)
		$(use_with X x)
		$(use_with X gtk3)
		$(use_with gtkmm gtkmm3)
		$(use_enable doc docs)
		--disable-tests
		$(use_enable resolutionkms)
		$(use_enable static-libs static)
		$(use_enable deploypkg)
		$(use_with pam)
		$(use_enable vgauth)
		$(use_with dnet)
		$(use_with icu)
	)
	# Avoid a bug in configure.ac
	use ssl || myeconfargs+=( --without-ssl )

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	if use pam; then
		rm "${ED}"/etc/pam.d/vmtoolsd || die
		pamd_mimic_system vmtoolsd auth account
	fi

	newconfd "${FILESDIR}/open-vm-tools.confd" vmware-tools

	if use systemd ; then
		if use vgauth; then
			systemd_newunit "${FILESDIR}"/vmtoolsd.vgauth.service vmtoolsd.service
			systemd_dounit "${FILESDIR}"/vgauthd.service
		else
			systemd_dounit "${FILESDIR}"/vmtoolsd.service
		fi
	else
		newinitd "${FILESDIR}/open-vm-tools.initd" vmware-tools
	fi

	# Make fstype = vmhgfs-fuse work in fstab
	dosym vmhgfs-fuse /usr/bin/mount.vmhgfs-fuse

	if use X; then
		fperms 4711 /usr/bin/vmware-user-suid-wrapper
		dobin scripts/common/vmware-xdg-detect-de
	fi
}