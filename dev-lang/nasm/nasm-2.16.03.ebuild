# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="groovy little assembler"
HOMEPAGE="https://www.nasm.us"
SRC_URI="https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz -> nasm-2.16.03.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND=""
DEPEND=""

# [fonts note] doc/psfonts.ph defines ordered list of font preference.
# Currently 'media-fonts/source-pro' is most preferred and is able to
# satisfy all 6 font flavours: tilt, chapter, head, etc.
BDEPEND="
	dev-lang/perl
	doc? (
		app-text/ghostscript-gpl
		dev-perl/Font-TTF
		dev-perl/Sort-Versions
		media-fonts/source-pro
		virtual/perl-File-Spec
	)
"

src_prepare() {
	default
	sed -i -e 's/^CP_UF[ \t]\+=.*/CP_UF = cp -f/' doc/Makefile.in
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default
	emake DESTDIR="${D}" $(usex doc install_doc '')
}