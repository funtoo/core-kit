# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools, autogeneration scripts."
HOMEPAGE="https://pypi.org/project/metatools/"
SRC_URI="https://files.pythonhosted.org/packages/f3/f9/650ee6d94761b74703fc609eaae597d375908dd2f1a7cbafa013c6dbe1ff/funtoo-metatools-0.5.1.tar.gz -> funtoo-metatools-0.5.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.5.1"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"