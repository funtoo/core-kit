# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="A high performance build system"
HOMEPAGE="https://mesonbuild.com https://pypi.org/project/meson/"
SRC_URI="https://files.pythonhosted.org/packages/dd/01/3dba211a922c371044baa3ade48f3021e9b67e83c07b397f8eeeea99d3a6/meson-0.59.1.tar.gz
"

DEPEND=""
RDEPEND=""

IUSE=""
RESTRICT="test"
SLOT="0"
LICENSE="Apache License, Version 2.0"
KEYWORDS="*"

S="${WORKDIR}/meson-0.59.1"

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/vim/vimfiles
	doins -r data/syntax-highlighting/vim/{ftdetect,indent,syntax}
	insinto /usr/share/zsh/site-functions
	doins data/shell-completions/zsh/_meson
}
