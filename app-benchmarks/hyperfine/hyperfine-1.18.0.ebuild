# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo bash-completion-r1

DESCRIPTION="A command-line benchmarking tool"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="https://github.com/sharkdp/hyperfine/tarball/24a0d5da1bff11567bbf307315d11cb0e10733ec -> hyperfine-1.18.0-24a0d5d.tar.gz
https://direct.funtoo.org/3c/f5/53/3cf5537ad9f06c2a6200c43bbf46143ba8eb5cb52659ec5c3d304584e8316d4d473b048dbb093d6dc5be1413fc394fd2d81e86e455fe6f5b9373cd0f1d8680e7 -> hyperfine-1.18.0-funtoo-crates-bundle-eb6e36dbaf69d58e55cde6bb79ee19dc43e8ef7ea7ce53f5b5f8b51e8a12e7c058f724267d20c869d26e2aa9fcc7a6f141a53b9717e226754a8d8330dcfba835.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+bash-completion zsh-completion fish-completion"

DEPEND=""
RDEPEND="
	bash-completion? ( app-shells/bash-completion )
	zsh-completion? ( app-shells/zsh-completions )
	fish-completion? ( app-shells/fish )
"
BDEPEND="virtual/rust"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/sharkdp-hyperfine-* ${S} || die
}

src_install() {
	cargo_src_install

	insinto /usr/share/hyperfine/scripts
	doins -r scripts/*

	doman doc/hyperfine.1

	einstalldocs

	if use bash-completion; then
		dobashcomp target/release/build/"${PN}"-*/out/"${PN}".bash
	fi

	if use fish-completion; then
		insinto /usr/share/fish/vendor_completions.d/
		doins target/release/build/"${PN}"-*/out/"${PN}".fish
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/vendor_completions.d/
		doins target/release/build/"${PN}"-*/out/_"${PN}"
	fi
}

pkg_postinst() {
	elog "You will need to install both 'numpy' and 'matplotlib' to make use of the scripts in '${EROOT%/}/usr/share/hyperfine/scripts'."
}