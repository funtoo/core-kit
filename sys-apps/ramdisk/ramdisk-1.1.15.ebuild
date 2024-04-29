# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo framework for creating initial ramdisks."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-ramdisk/browse https://pypi.org/project/funtoo-ramdisk/"
SRC_URI="https://files.pythonhosted.org/packages/ee/a3/f131b3045b581e9b0b2882abeff2c037ac8862773fd6e7c9947dcf72824b/funtoo_ramdisk-1.1.15.tar.gz -> funtoo_ramdisk-1.1.15.tar.gz"

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
S="${WORKDIR}/funtoo_ramdisk-1.1.15"

python_install_all() {
	doman ${S}/doc/ramdisk.8
}
