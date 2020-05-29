# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools, autogeneration scripts."
HOMEPAGE="https://pypi.org/project/metatools/"
SRC_URI="https://files.pythonhosted.org/packages/51/0c/7826102b35c3152fac58976c30ba9c3628fb7236195ab58df917cb52af56/funtoo-metatools-0.5.0.tar.gz -> funtoo-metatools-0.5.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.5.0"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"