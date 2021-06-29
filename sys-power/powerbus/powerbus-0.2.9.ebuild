# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo Power Management Framework"
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-powerbus/browse https://pypi.org/project/funtoo-powerbus/"
SRC_URI="https://files.pythonhosted.org/packages/97/76/207c0b9604d9c946bb20808dcc4d5b77085879f41f90d1f134137ded077d/funtoo-powerbus-0.2.9.tar.gz
"

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
	dev-python/aiohttp[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/funtoo-powerbus-0.2.9"

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
