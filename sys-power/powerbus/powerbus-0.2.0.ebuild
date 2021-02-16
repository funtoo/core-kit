# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://files.pythonhosted.org/packages/5b/72/ded1f0c1578c4f5637735795d09e4652133d073fbacc22614e463e4edfea/funtoo-powerbus-0.2.0.tar.gz"

DEPEND="
	x11-libs/libXscrnSaver
	x11-libs/libXext
	x11-libs/libX11"
RDEPEND="
	sys-apps/dbus
	dev-python/dbus-next[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/subpop-0.4[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/funtoo-powerbus-${PV}"

src_compile() {
	distutils-r1_src_compile
	gcc $CFLAGS xidle.c -o funtoo-xidle -lX11 -lXext -lXss || die
}

src_install() {
	distutils-r1_src_install
	exeinto /usr/bin
	doexe funtoo-xidle
	newinitd $FILESDIR/powerbus.initd powerbus
	insinto /etc/xdg/autostart
	doins ${FILESDIR}/funtoo-idled.desktop
}
