# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="A gentle evolution of the POP paradigm."
HOMEPAGE="https://code.funtoo.org/bitbucket/users/drobbins/repos/subpop/browse https://pypi.org/project/subpop/"
SRC_URI="https://files.pythonhosted.org/packages/09/f9/b7204bb5d466cef6a3f2123497ae14450d91de49df8a8f894559052664d8/subpop-2.0.0.tar.gz -> subpop-2.0.0.tar.gz"

DEPEND=""
RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/subpop-2.0.0"