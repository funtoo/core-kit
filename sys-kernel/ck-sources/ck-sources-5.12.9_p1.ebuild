# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="amd64 x86"

HOMEPAGE="http://kernel.kolivas.org/"

K_SECURITY_UNSUPPORTED="1"

OKV="5.12.9"
KV="5.12.9"

inherit kernel-2
detect_arch

RDEPEND="virtual/linux-sources"

DESCRIPTION="Linux 5.12.9-ck1, with Con Kolivas' MuQSS scheduler and patchset"

SRC_URI="
https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/patch-5.12.9.xz -> patch-5.12.9.xz
http://ck.kolivas.org/patches/5.0/5.12/5.12-ck1/patch-5.12-ck1.xz -> patch-5.12-ck1.xz
https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.12.tar.xz -> linux-5.12.tar.xz"

UNIPATCH_LIST="
	${DISTDIR}/patch-5.12.9.xz
	${DISTDIR}/patch-5.12-ck1.xz
"

UNIPATCH_STRICTORDER="yes"

src_unpack() {
	universal_unpack
	unipatch "${UNIPATCH_LIST}"
	env_setup_xmakeopts
}

pkg_postinst() {
	kernel-2_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}