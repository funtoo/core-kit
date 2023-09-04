# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/zsh-users/zsh-completions/archive/refs/tags/0.35.0.tar.gz -> 0.35.0.tar.gz"
KEYWORDS="*"

DESCRIPTION="Additional completion definitions for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-completions"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-shells/zsh"

src_prepare() {
	
	rm -rf src/_flameshot
	

	default
}

src_install() {
	insinto /usr/share/zsh/site-functions
	doins src/_*
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make the new completions available"
	elog "to your shell."
	elog
}