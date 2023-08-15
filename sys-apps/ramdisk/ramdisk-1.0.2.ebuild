# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo framework for creating initial ramdisks."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-ramdisk/browse https://pypi.org/project/funtoo-ramdisk/"
SRC_URI="https://files.pythonhosted.org/packages/f9/fa/646343cf9f6313cf3808fc13d1f0e047a0f044afbdd7c60d76613a4da543/funtoo-ramdisk-1.0.2.tar.gz -> funtoo-ramdisk-1.0.2.tar.gz
"

DEPEND=""
RDEPEND="
	app-arch/xz-utils
	app-arch/zstd
	app-misc/pax-utils
	sys-apps/busybox[-pam,static]
	dev-python/rich[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/funtoo-ramdisk-1.0.2"