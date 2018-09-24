# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils flag-o-matic linux-info multilib

DESCRIPTION="A daemon to run x86 code in an emulated environment"
HOMEPAGE="https://dev.gentoo.org/~spock/projects/uvesafb/"
SRC_URI="mirror://funtoo/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug x86emu"

DEPEND="dev-libs/klibc"
RDEPEND=""

S="${WORKDIR}/${P//_*/}"

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	if [ -z "$(grep V86D ${ROOT}/usr/$(get_libdir)/klibc/include/linux/connector.h)" ]; then
		eerror "You need to compile klibc against a kernel tree patched with uvesafb"
		eerror "prior to merging this package."
		die "Kernel not patched with uvesafb."
	fi

	if use kernel_linux && kernel_is ge 3 10; then
	epatch "${FILESDIR}/v86d-0.1.10-atomict.patch"
	fi
}

src_configure() {
	./configure --with-klibc $(use_with debug) $(use_with x86emu) || die
}

src_compile() {
	# Disable stack protector, as it does not work with klibc (bug #346397).
	filter-flags -fstack-protector -fstack-protector-all
	emake KDIR="${KV_DIR}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README ChangeLog

	insinto /usr/share/${PN}
	doins misc/initramfs
}

pkg_postinst() {
	elog "If you wish to place v86d into an initramfs image, you might want to use"
	elog "'/usr/share/${PN}/initramfs' in your kernel's CONFIG_INITRAMFS_SOURCE."
}
