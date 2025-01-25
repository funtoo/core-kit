# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/tarball/1dcdf06b5c4c400ce349fc84ec06c59e99f5c9af -> skim-0.16.0-1dcdf06.tar.gz
https://direct.funtoo.org/4a/fb/04/4afb04e700f4cbaa8eafc66b50c460c303400167900b5df65980b666879269a33ffd6c0a8d80bdbc08b160d2617e5610fa489576df0cef2d3837822f475bf1b9 -> skim-0.16.0-funtoo-crates-bundle-e6b8c71a3cf75ea4b9b5b4a90592c0057c4adbf331504344d111150e816f66d548105046c3e35eba479b4877d660795a1ed60c77aefae5f059938d887bf6585b.tar.gz"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="tmux vim"

RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/sk"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/lotabout-skim-* ${S} || die
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	use tmux && dobin bin/sk-tmux

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/skim.vim
	fi

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}