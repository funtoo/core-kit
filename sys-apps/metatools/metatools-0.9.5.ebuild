# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo's metatools -- autogeneration framework."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-metatools/browse https://pypi.org/project/funtoo-metatools/"
SRC_URI="https://files.pythonhosted.org/packages/ff/54/e958796551b54896af5fa198c336d947fb8ee3d32fb9b8cda8e4702e4ced/funtoo-metatools-0.9.5.tar.gz
"

DEPEND=""
RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/dict-toolbox[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	>dev-python/subpop-0.4.2[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/funtoo-metatools-0.9.5"