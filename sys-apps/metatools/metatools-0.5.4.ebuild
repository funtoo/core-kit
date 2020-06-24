# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools, autogeneration scripts."
HOMEPAGE="https://pypi.org/project/metatools/"
SRC_URI="https://files.pythonhosted.org/packages/84/2c/1f45c067b70d00b71c4a7fdee5f6ad073c5869baf2a55ab657263696b764/funtoo-metatools-0.5.4.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.5.4"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"