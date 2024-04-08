# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fly through your shell history. Great Scott!"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://github.com/cantino/mcfly/tarball/3d2358dbc2d6920728ed84abee4520ed956c8281 -> mcfly-0.8.4-3d2358d.tar.gz
https://direct.funtoo.org/09/c3/a3/09c3a3f7a29ea75de007c94bd4ca0081b91c8b5747cba9ffa2a500911509e820bcfd7aef5359d4c4b7d649aad981e0eb92f3fc0f5bf04f2492abe3b59fc47283 -> mcfly-0.8.4-funtoo-crates-bundle-ddc3903a28c3f91582c907b6c521b38ba76592c9769e532fb1a024306d256f4b80c9f7915ee451b76baa9b46b39572b5b54195c48dabb70a0d60c7cc492ee437.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="/usr/bin/mcfly"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/cantino-mcfly-* ${S} || die
}

src_install() {
	cargo_src_install

	insinto "/usr/share/${PN}"
	doins "${PN}".{bash,fish,zsh}

	einstalldocs
}

pkg_postinst() {

	elog "To start using ${PN}, add the following to your shell:"
	elog
	elog "~/.bashrc"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.bash"
	elog "[[ -f ${p} ]] && source ${p}"
	elog
	elog "~/.config/fish/config.fish"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.fish"
	elog "if test -r ${p}"
	elog "    source ${p}"
	elog "    mcfly_key_bindings"
	elog
	elog "~/.zsh"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.zsh"
	elog "[[ -f ${p} ]] && source ${p}"
}