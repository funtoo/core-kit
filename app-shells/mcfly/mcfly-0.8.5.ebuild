# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fly through your shell history. Great Scott!"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://github.com/cantino/mcfly/tarball/1e1143cfdb03636ab27fb0c7a82cf1ed356af513 -> mcfly-0.8.5-1e1143c.tar.gz
https://direct.funtoo.org/8f/f4/e3/8ff4e30bd38eb3a930237c1606a1fa463c31507c58ac598b326ac820f4bc87ac6c949076b1782fddae2d9a86ed0faf805383edf3b8f2e472cb19d78bff8d933f -> mcfly-0.8.5-funtoo-crates-bundle-c01b2a919e39ad78396f311d232c7def901e617559056764a2991fe8d1615387e2eed66def8b1433088da492b5bfa08c549ed4979673937750104ec3599f77e6.tar.gz"

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