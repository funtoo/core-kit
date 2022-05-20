# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo franken-chroot tool."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/fchroot/browse https://pypi.org/project/fchroot/"
SRC_URI="https://files.pythonhosted.org/packages/84/c4/c9db5085efbfbd0021e3f9d7b5d44f978d4e165e935f51b6616a811b6681/fchroot-0.4.0.tar.gz
"

DEPEND=""
RDEPEND="
	app-emulation/qemu[static-user,qemu_user_targets_aarch64,qemu_user_targets_arm,qemu_user_targets_riscv64,qemu_user_targets_ppc64]
	dev-libs/glib[static-libs]
	sys-apps/attr[static-libs]
	sys-libs/zlib[static-libs]
	dev-libs/libpcre[static-libs]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/fchroot-0.4.0"