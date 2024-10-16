# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd vcs-snapshot versionator
DESCRIPTION="FUSE filesystem for LXC"
HOMEPAGE="https://linuxcontainers.org/lxcfs/introduction/"
LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/lxc/lxcfs.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	# e.g. upstream is 2.0.0.beta2, we want 2.0.0_beta2
	UPSTREAM_PV=$(replace_version_separator 3 '.' )
	SRC_URI="https://github.com/lxc/lxcfs/archive/${PN}-${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=""
fi

# Omit all dbus.  Upstream appears to require it because systemd, but
# lxcfs makes no direct use of dbus.
RDEPEND="
	dev-libs/glib:2
	sys-fs/fuse:0
"
DEPEND="
	sys-apps/help2man
	${RDEPEND}
"

src_prepare() {
	default
	./bootstrap.sh || die "Failed to bootstrap configure files"
}

src_configure() {
	# Without the localstatedir the filesystem isn't mounted correctly
	econf --localstatedir=/var
}

# Test suite fails for me
# src_test() {
# 	emake tests
# 	tests/main.sh || die "Tests failed"
# }

src_install() {
	default
	newinitd "${FILESDIR}"/lxcfs-3.0.2-r2.initd lxcfs
	systemd_dounit config/init/systemd/lxcfs.service
}

pkg_postinst() {
	einfo
	einfo "Starting with version 3.0.0 the cgfs PAM module has moved, and"
	einfo "will eventually be available in app-emulation/lxc.  See:"
	einfo "https://brauner.github.io/2018/02/28/lxc-includes-cgroup-pam-module.html"
	einfo "for more information."
	einfo
}
