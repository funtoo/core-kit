# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo's metatools -- autogeneration framework."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-metatools/browse https://pypi.org/project/funtoo-metatools/"
SRC_URI="https://files.pythonhosted.org/packages/0d/98/6c5d0cfa132879ce58e8589705a17e7170875127f7d12cfa89daa62a2515/funtoo-metatools-1.3.5.tar.gz -> funtoo-metatools-1.3.5.tar.gz"

DEPEND=">=dev-python/subpop-2.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	app-arch/unzip
	>=dev-util/meson-1.2.0
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/dict-toolbox[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.24.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/funtoo-metatools-1.3.5"

src_configure() {
	unset PYTHONPATH
	default
}
