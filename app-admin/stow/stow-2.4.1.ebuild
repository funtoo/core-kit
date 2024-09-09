# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="GNU Stow is a symlink farm manager"
HOMEPAGE="https://www.gnu.org/software/stow/ https://git.savannah.gnu.org/cgit/stow.git"
SRC_URI="https://ftp.gnu.org/gnu/stow/stow-2.4.1.tar.gz -> stow-2.4.1.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/perl:="
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-perl/IO-stringy
		virtual/perl-Test-Harness
		dev-perl/Test-Output
	)
"

src_configure() {
	perl_set_version
	econf "--with-pmdir=${VENDOR_LIB}"
}
