# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo's boxer -- container and VM creation tool."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/funtoo-boxer/browse https://pypi.org/project/funtoo-boxer/"
SRC_URI="https://files.pythonhosted.org/packages/51/54/a7ccf2a3a3858e83425528fcfc22bbcc0d243efdf054d823211d36f050b5/funtoo-boxer-1.0.3.tar.gz -> funtoo-boxer-1.0.3.tar.gz"

DEPEND=">=dev-python/subpop-2.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/funtoo-boxer-1.0.3"