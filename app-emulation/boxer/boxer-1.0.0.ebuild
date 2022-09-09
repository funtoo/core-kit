# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-boxer/browse https://pypi.org/project/funtoo-boxer/"
SRC_URI="https://files.pythonhosted.org/packages/62/a4/513036021638c0b74e424de9d22c500c15a16c44d5bf81159d00a88bf26c/funtoo-boxer-1.0.0.tar.gz -> funtoo-boxer-1.0.0.tar.gz
"

DEPEND=">=dev-python/subpop-2.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/funtoo-boxer-1.0.0"