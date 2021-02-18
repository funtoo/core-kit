# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://files.pythonhosted.org/packages/91/18/99b564c9a50c4f37e8b9d06a77e85a713630c941737d82a488e6d00e8404/funtoo-powerbus-0.2.5.tar.gz"

DEPEND="
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libX11
	>=dev-python/subpop-0.4.1[$PYTHON_USEDEP]"
RDEPEND="
	sys-apps/dbus
	dev-python/dbus-next[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/subpop-0.4[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
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
