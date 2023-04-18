# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="FUSE filesystem for bind mounting with altered permissions"
HOMEPAGE="https://bindfs.org/"
SRC_URI="https://github.com/mpartel/bindfs/tarball/a0f98a7aef83b45f5ffca7f2c5095b14024f0814 -> bindfs-1.17.2-a0f98a7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=sys-fs/fuse-3.4:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="test"

post_src_unpack() {
	mv ${WORKDIR}/mpartel-bindfs-* ${S} || die
}

src_prepare() {
	default
	eautoreconf
}



src_configure() {
	econf $(use_enable debug debug-output) --with-fuse3
}