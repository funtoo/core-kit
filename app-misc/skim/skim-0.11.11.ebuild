# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/tarball/32d9e70af4eeaaf2c3f2d276838dc338361a75cf -> skim-0.11.11-32d9e70.tar.gz
https://direct.funtoo.org/03/5a/af/035aaf91196224e3517925028b8a606fdf9eedd98d4169f8143fa0e26b263c447639ffa47912672eb8bdd150b9259a83b98b20fd51187d3cd27ba94db2229078 -> skim-0.11.11-funtoo-crates-bundle-631a7b148db0af9b8784affbcf9a57fe77de9a20ac7a0892b714870be53531bdc67852bbb96ac7613b881129a2a6fb43f90c9311def5b56976f3613e96d25883.tar.gz"

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