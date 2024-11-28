# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/tarball/d9419c640b92527ac72f50cee2f7e26fe2c54515 -> skim-0.14.3-d9419c6.tar.gz
https://direct.funtoo.org/4b/8b/1f/4b8b1f95ecee71b74ac34429adfa7d8b715d419abd002cddfd58f02b5be4dcd588188dc81b636c813c8f0306b34c1691143ee6b1973c96cf35fea03b1a9f5638 -> skim-0.14.3-funtoo-crates-bundle-12cd8e2bfb275164c35f44802d0336216349ac67199d3b1edfbc5128e2245f4fb5fb1663fb1e602254591c6d5ed945f01f1b9cd7325b5c685c3a3f19c4289366.tar.gz"

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