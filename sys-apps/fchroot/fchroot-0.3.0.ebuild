# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo franken-chroot tool."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/fchroot/browse https://pypi.org/project/fchroot/"
SRC_URI="https://files.pythonhosted.org/packages/6b/5c/5e7049ef25ba0406f171c7d0704ff81eadf2f457223dd42052d5e564fc09/fchroot-0.3.0.tar.gz
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

S="${WORKDIR}/fchroot-0.3.0"