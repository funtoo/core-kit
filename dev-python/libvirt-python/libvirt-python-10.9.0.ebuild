# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1


DESCRIPTION="libvirt Python bindings"
HOMEPAGE="https://www.libvirt.org"
SRC_URI="https://libvirt.org/sources/python/libvirt-python-10.9.0.tar.gz -> libvirt-python-10.9.0.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="app-emulation/libvirt:0/${PV}"
DEPEND="virtual/pkgconfig"
BDEPEND="test? (
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
)"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}