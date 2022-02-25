# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's franken-chroot tool."
HOMEPAGE="https://pypi.org/project/fchroot/"
SRC_URI="https://files.pythonhosted.org/packages/e1/aa/8a94dafef70d41d4d0763e0f7b1b4a93eae39ac7b9c1ec7a069b5a7e793d/fchroot-0.2.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-emulation/qemu[static-user,qemu_user_targets_aarch64,qemu_user_targets_arm,qemu_user_targets_riscv64,qemu_user_targets_ppc64]
	dev-libs/glib[static-libs]
	sys-apps/attr[static-libs]
	sys-libs/zlib[static-libs]
	dev-libs/libpcre[static-libs]
"