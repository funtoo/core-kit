# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="*"

HOMEPAGE="http://kernel.org/"

K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

RDEPEND="virtual/linux-sources"

DESCRIPTION="Linux 6.10.6"

SRC_URI="https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.xz -> linux-6.10.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/patch-6.10.6.xz -> patch-6.10.6.xz"

pkg_postinst() {
	kernel-2_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}