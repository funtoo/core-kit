# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo's metatools -- autogeneration framework."
HOMEPAGE=""
SRC_URI="https://files.pythonhosted.org/packages/d4/5b/c8aa6a56434589a3f2b8e042e064137054c7b6cbd79f17918f0a045adc63/funtoo-metatools-0.9.4.tar.gz
"

DEPEND=""
RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/dict-toolbox[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
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

S="${WORKDIR}/funtoo-metatools-0.9.4"