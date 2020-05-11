# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Funtoo's metatools, autogeneration scripts."
HOMEPAGE="https://pypi.org/project/metatools/"
SRC_URI="https://files.pythonhosted.org/packages/b3/23/b1c7a9460d87f7edb1c7fbb0f7bf0a07c97a60cb1f508b9a435c643549f5/funtoo-metatools-0.4.8.tar.gz -> funtoo-metatools-0.4.8.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/funtoo-metatools-0.4.8"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pop[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"