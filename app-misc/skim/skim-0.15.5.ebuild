# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/tarball/1121509428a6e4ada14a7d852075bd99ff17369e -> skim-0.15.5-1121509.tar.gz
https://direct.funtoo.org/34/65/19/3465199cad6f33ce079a1dd5a439db96f4b9ceaa316769a2fa9f41304e4861b4caf163df05f79036c0293020f1e2491d393a88036b63ba4d983a7a59b59afaaa -> skim-0.15.5-funtoo-crates-bundle-4966630b20aa9015b0528584456249b216eb68e7290b3c8509048861943e5d26839626b33606fd9b0005187f13658001bbaacff9f33b5befe6523c6082b85bbf.tar.gz"

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