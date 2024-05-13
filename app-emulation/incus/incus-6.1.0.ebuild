# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools golang-base go-module bash-completion-r1 linux-info user

DESCRIPTION="Powerful system container and virtual machine manager"
HOMEPAGE="https://linuxcontainers.org/incus/introduction/ https://github.com/lxc/incus"
SRC_URI="https://linuxcontainers.org/downloads/incus/incus-v6.1.0.tar.xz -> incus-v6.1.0.tar.xz"

# Needs to include licenses for all bundled programs and libraries.
LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="apparmor ipv6 nls"

DEPEND="app-arch/xz-utils
	app-arch/lz4
	>=app-emulation/lxc-4.0.6[apparmor?]
	dev-lang/tcl
	dev-libs/libuv
	dev-libs/lzo
	>=dev-util/xdelta-3.0
	net-dns/dnsmasq[dhcp,ipv6?]"
RDEPEND="${DEPEND}
	net-firewall/ebtables
	net-firewall/iptables[ipv6?]
	sys-apps/iproute2[ipv6?]
	sys-fs/fuse:*
	sys-fs/lxcfs
	sys-fs/squashfs-tools[lzma]
	virtual/acl"
BDEPEND=">=dev-lang/go-1.21
	>=sys-kernel/linux-headers-4.15
	nls? ( sys-devel/gettext )"

CONFIG_CHECK="
	~CGROUPS
	~IPC_NS
	~NET_NS
	~PID_NS

	~SECCOMP
	~USER_NS
	~UTS_NS
"

ERROR_IPC_NS="CONFIG_IPC_NS is required."
ERROR_NET_NS="CONFIG_NET_NS is required."
ERROR_PID_NS="CONFIG_PID_NS is required."
ERROR_SECCOMP="CONFIG_SECCOMP is required."
ERROR_UTS_NS="CONFIG_UTS_NS is required."

# Go magic.
QA_PREBUILT="/usr/lib/incus/libcowsql.so.0.0.1
	/usr/bin/incus
	/usr/bin/lxc-to-incus
	/usr/bin/incus-agent
	/usr/bin/incus-benchmark
	/usr/bin/incus-migrate
	/usr/bin/incus-user
	/usr/sbin/incusd"

S="${WORKDIR}/incus-${PV}"
RESTRICT="test"
VDIR="${S}/vendor"

post_src_unpack() {
	mv "${WORKDIR}"/${PN}-* "${S}" || die
}

pkg_setup() {
	ebegin "Ensuring incus and incus-admin groups exist"
	# The group incus is used for user socket with restrict access to a specific
	# project.
	enewgroup incus
	# The control socket will be owned by (and writeable by) this group.
	enewgroup incus-admin
	eend $?
}

src_prepare() {
	default

	sed -i \
		-e "s:\./configure:./configure --prefix=/usr --libdir=${EPREFIX}/usr/lib/incus:g" \
		-e "s:make:make ${MAKEOPTS}:g" \
		Makefile || die
	sed -i \
		-e "s:/usr/lib/qemu/virtfs-proxy-helper:/usr/libexec/virtfs-proxy-helper:g" \
		internal/server/device/device_utils_disk.go || die "Failed to fix virtfs-proxy-helper path."

	sed -i 's#zfs version 2>/dev/null | cut -f 2 -d - | head -1#< /sys/module/zfs/version cut -f 1#' ${VDIR}/raft/configure.ac || die

	cd ${VDIR}/cowsql
	eautoreconf

	cd ${VDIR}/raft
	eautoreconf
}

src_configure() {
	export RAFT_CFLAGS="-I${VDIR}/raft/include/"
	export RAFT_LIBS="${VDIR}/raft/.libs"

	cd ${VDIR}/raft
	econf --libdir="${EPREFIX}"/usr/lib/incus

	cd ${VDIR}/cowsql
	export PKG_CONFIG_PATH="${VDIR}/raft"
	econf --libdir="${EPREFIX}"/usr/lib/incus
}

src_compile() {
	export GOFLAGS="-buildmode=pie -trimpath -mod=vendor"
	#export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
	export CGO_LDFLAGS_ALLOW="-Wl,-z,now"

	export CGO_CFLAGS="${CGO_CFLAGS} -I${VDIR}/cowsql/include/ -I${VDIR}/raft/include/"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L${VDIR}/raft/.libs/ -L${VDIR}/cowsql/.libs/ -Wl,-rpath,${EPREFIX}/usr/lib/incus"
	export LD_LIBRARY_PATH="${VDIR}/raft/.libs/:${VDIR}/cowsql/.libs/:${LD_LIBRARY_PATH}"

	cd ${VDIR}/raft || die
	emake

	cd ${VDIR}/cowsql || die
	emake CFLAGS="-I${VDIR}/raft/include" LDFLAGS="-L${VDIR}/raft/.libs -lraft"

	cd ${S}/ || die
	mkdir -p bin || die

	export GOFLAGS="-buildmode=pie -trimpath -mod=vendor"
	export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"

	CGO_ENABLED=0 go build $GOFLAGS -v -x -tags "netgo" -o bin/ ./cmd/incus-migrate/... || die "Failed to build incus-migrate"

	for k in incus incusd lxc-to-incus incus incus-benchmark incus-user ; do
		CGO_ENABLED=1 go build -v -x -tags "libsqlite3" -o bin/ ./cmd/${k}/... || die "Failed to build ${k}"
	done

	CGO_ENABLED=0 CGO_LDFLAGS="$CGO_LDFLAGS -static" go build -v -x -tags "agent,netgo" -o bin/ ./cmd/incus-agent/... || die "Failed to build incus-agent"

	pushd "${S}"/cmd/lxd-to-incus || die
	CGO_ENABLED=0 CGO_LDFLAGS="$CGO_LDFLAGS -static" go build -v -x -o ../../bin/ ./ || die "Failed to build lxd-to-incus"
	popd

	use nls && emake build-mo
}

src_install() {
	cd ${S}/
	local bindir="bin"

	dosbin ${bindir}/incusd
	dosbin ${bindir}/incus-user
	dosbin ${bindir}/lxd-to-incus

	for l in incus-agent incus-benchmark incus-migrate incus lxc-to-incus; do
		dobin ${bindir}/${l}
	done

	for m in cowsql raft; do
		local mdir=${VDIR}/${m}
		cd ${mdir} || die "failed switching into /${mdir}"
		emake DESTDIR="${D}" install
	done

	cd "${S}" || die

	# We only need bundled libs during src_compile, and we don't want anything
	# to link against these.
	rm -r "${ED}"/usr/include || die
	rm -r "${ED}"/usr/lib/incus/*.a || die
	rm -r "${ED}"/usr/lib/incus/pkgconfig || die

	newbashcomp "${FILESDIR}"/incus.bashcomp-0.7.0 incus

	exeinto /usr/sbin/
	doexe "${FILESDIR}"/incus-startup

	newinitd "${FILESDIR}"/incus.initd incus || die
	newinitd "${FILESDIR}"/incus-user.initd incus-user || die
	newinitd "${FILESDIR}"/incus-lxcfs.initd incus-lxcfs || die

	newconfd "${FILESDIR}"/incus.confd incus || die
	newconfd "${FILESDIR}"/incus-user.confd incus-user || die
	newconfd "${FILESDIR}"/incus-lxcfs.confd incus-lxcfs || die

	# Creating service directory
	diropts -m0750 -o root -g incus-admin
	dodir /var/lib/incus/
	dodir /var/lib/incus-lxcfs/
	keepdir /var/lib/incus/
	keepdir /var/lib/incus-lxcfs/
	dodir /var/log/incus/
	keepdir /var/log/incus/
	diropts

	local dodoc_opts=-r
	dodoc -r AUTHORS doc/**
	use nls && domo po/*.mo
}

pkg_postinst() {
	if [[ -z ${ROOT} && -n "$( rc-service incusd status| grep started )"  ]]; then
		einfo "Restarting incusd service."
		if nofatal rc-service incusd restart ; then
			eerror
			eerror "Incus service failed to start after update."
			eerror "Please check if your configuration for ${REPLACING_VERSIONS}"
			eerror "is still valid for the new version."
			eerror
		else
			ewarn
			ewarn "Incus service was automatically restarted."
			ewarn "If you are unable to 'lxc exec <containername>',"
			ewarn "then you may need to restart all containers. "
			ewarn "This can be done with /etc/init.d/incus stop; /etc/init.d/incus start."
			ewarn
		fi
	fi

	elog
	elog "Please run 'lxc-checkconfig' to see all optional kernel features."
	elog
	elog "Though not strictly required, some features are enabled at run-time"
	elog "when the relevant helper programs are detected:"
	elog "- sys-fs/btrfs-progs"
	elog "- sys-fs/lvm2"
	elog "- sys-fs/zfs"
	elog "- sys-process/criu"
	elog
	elog "Be sure to add your local user to the incus group."
}

# vim: noet ts=4 syn=ebuild