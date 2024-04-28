# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE=""

DEPEND="app-arch/brotli"
RDEPEND="${DEPEND}"
IUSE=""
SLOT="0"
LICENSE=""
KEYWORDS="*"
S="${WORKDIR}/brotli-1.1.0"

src_unpack() {
	unpack ${ROOT}/usr/share/brotli/bindings/brotli-python-${PV}.tar.gz || die
}
