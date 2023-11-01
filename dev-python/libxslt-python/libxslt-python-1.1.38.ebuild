# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE=""

DEPEND="=dev-libs/libxslt-${PV}:=[crypt?]"
RDEPEND="${DEPEND}"
IUSE="+crypt"
SLOT="0"
LICENSE=""
KEYWORDS="*"

S="$WORKDIR"/python

src_unpack() {
	unpack ${ROOT}/usr/share/libxslt/bindings/libxslt-python-${PV}.tar.gz || die
}
