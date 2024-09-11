# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod user

DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/7.1.0/VirtualBox-7.1.0-164728-Linux_amd64.run -> VirtualBox-7.1.0-164728-Linux_amd64.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="vboxdrv(misc:${S}) vboxnetflt(misc:${S}) vboxnetadp(misc:${S})"
MODULESD_VBOXDRV_ENABLED="yes"
MODULESD_VBOXNETADP_ENABLED="no"
MODULESD_VBOXNETFLT_ENABLED="no"

src_unpack() {
	sh ${DISTDIR}/${A} --noexec --keep --nox11 || die
	cd install && tar -xaf VirtualBox.tar.bz2
	mv src/vboxhost ${S}
}

pkg_setup() {
	enewgroup vboxusers
	linux-mod_pkg_setup
	BUILD_PARAMS="CC=$(tc-getBUILD_CC) KERN_DIR=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_prepare() {
	sed -i -e 's/^#if RTLNX_VER_MIN(6,5,0)/#if RTLNX_VER_MIN(6,4,10)/' ${S}/vboxnetflt/linux/VBoxNetFlt-linux.c || die
	default
}

src_install() {
	linux-mod_src_install
	insinto /usr/lib/modules-load.d/
	doins "${FILESDIR}"/virtualbox.conf
}

pkg_postinst() {
	# Remove vboxpci.ko from current running kernel
	find /lib/modules/${KV_FULL}/misc -type f -name "vboxpci.ko" -delete
	linux-mod_pkg_postinst
}