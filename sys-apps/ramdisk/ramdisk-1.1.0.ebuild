# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo framework for creating initial ramdisks."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-ramdisk/browse https://pypi.org/project/funtoo-ramdisk/"
SRC_URI="https://files.pythonhosted.org/packages/7c/a6/12d689149a2f7695776cc1c97dba03d1baabbf2451e4bf7c28ccdd2ae4d3/funtoo-ramdisk-1.1.0.tar.gz -> funtoo-ramdisk-1.1.0.tar.gz
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
S="${WORKDIR}/funtoo-ramdisk-1.1.0"