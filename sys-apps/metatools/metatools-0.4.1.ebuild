# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools, autogeneration scripts."
HOMEPAGE="https://pypi.org/project/pop/"
SRC_URI="https://files.pythonhosted.org/packages/bb/5e/77e62d1583d43f1445d43760ab8132811fb62d4df9850527cbe4a2d1803b/funtoo-metatools-0.4.1.tar.gz -> funtoo-metatools-0.4.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.4.1"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"