# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils toolchain-funcs savedconfig

DESCRIPTION="suckless mdev"
HOMEPAGE="http://git.suckless.org/smdev/"
SRC_URI="http://git.suckless.org/${PN}/snapshot/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="strip"

src_prepare() {
	restore_config config.h

	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" install

	newinitd "${FILESDIR}/init-${PV}" smdev

	save_config config.h
}

pkg_postinst() {
	elog "smdev install guide can be found at:"
	elog "http://www.funtoo.org/Package:Smdev"
}
