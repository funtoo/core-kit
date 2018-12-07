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
	elog
	elog "To switch from udev you should do the following:"
	elog "Disable udev USE flag"
	elog "Use keyboard and mouse instead of evdev in INPUT_DEVICES"
	elog "Rebuild world"
	elog "Update X.Org configs to use kbd and mouse instead of evdev"
	elog "rc-update del udev sysinit"
	elog "rc-update del udev-mount sysinit"
	elog "rc-update del udev-postmount boot"
	elog "rc-update add smdev sysinit"
	elog
}
