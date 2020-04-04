# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Plugin-Oriented Programming"
HOMEPAGE="https://pypi.org/project/pop/"
SRC_URI="https://files.pythonhosted.org/packages/ec/f5/f8f5a542edd8be4ae8b4b2ff279a503de62a195b2e160a4645e9088b0d08/funtoo-metatools-0.3.1.tar.gz -> funtoo-metatools-0.3.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.3.1"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"