# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix readme.gentoo-r1

DESCRIPTION="ZSH port of Fish history search (up arrow)"
HOMEPAGE="https://github.com/zsh-users/zsh-history-substring-search/"
SRC_URI="https://api.github.com/repos/zsh-users/zsh-history-substring-search/tarball/refs/tags/v1.0.2 -> zsh-history-substring-search-1.0.2.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="app-shells/zsh"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="\
For use this script, load it into your interactive ZSH session:
	. ${EROOT}/usr/share/zsh/plugins/${PN}/${PN}.zsh
If you want to use zsh-syntax-highlighting along with this script, then make
sure that you load it before you load this script.
For further information, please read the README.md file installed in:
	${EROOT}/usr/share/doc/${PF}"

post_src_unpack() {
	mv ${WORKDIR}/zsh-users-zsh-history-substring-search-* ${S} || die
}

src_prepare() {
	default

	hprefixify -w 1 "${PN}.zsh"
}

src_install() {
	einstalldocs
	readme.gentoo_create_doc

	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}