# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools -- autogeneration framework."
HOMEPAGE=""
SRC_URI="https://files.pythonhosted.org/packages/9e/03/bda88fd989682bc5a107151e9a3cd340d08f9896eebbb942f92eede60092/funtoo-metatools-0.9.1.tar.gz"

DEPEND=""
RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/dict-toolbox[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/funtoo-metatools-${PV}"