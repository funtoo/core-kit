# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-metatools/browse https://pypi.org/project/funtoo-metatools/"
SRC_URI="https://files.pythonhosted.org/packages/a5/e6/dd8d1b438e183132fe089db567bf2c38eb25320c68ebab21a7896dec1fec/funtoo-metatools-1.1.0.tar.gz -> funtoo-metatools-1.1.0.tar.gz
"

DEPEND=">=dev-python/subpop-2.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	app-arch/unzip
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/dict-toolbox[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/funtoo-metatools-1.1.0"