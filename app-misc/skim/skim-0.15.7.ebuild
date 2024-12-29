# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/tarball/74b2ea971d94d80e54762f9561ea204b34de69f0 -> skim-0.15.7-74b2ea9.tar.gz
https://direct.funtoo.org/f1/f2/8a/f1f28a900e40f0ef6a4bba258dc4d649cdb07edc2cdb5562845a4376bb5bad189867dfcbc19cd1a17fbd5d70fc466c2affcb3f788533bb1e9d63b1f8da87bf97 -> skim-0.15.7-funtoo-crates-bundle-77f9083c83e3696b634ab62a19c05deeba2d6c5ce90463198a99d3999a938c6446b889be558455d021656f505dcdf5c10841db56a2f19ec756f17e9bd0eab48a.tar.gz"

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