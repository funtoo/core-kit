# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Core utilities for legacy Python packages"
HOMEPAGE=" https://pypi.org/project/packaging-legacy/"
SRC_URI="https://files.pythonhosted.org/packages/f8/31/3a2fe3f5fc01a0671ba20560c556b4239b69bfef842a20bba99e3239fd3e/packaging_legacy-23.0.post0.tar.gz -> packaging_legacy-23.0.post0.tar.gz
"

DEPEND=""
RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/packaging_legacy-23.0.post0"