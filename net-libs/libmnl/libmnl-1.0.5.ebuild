# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Minimalistic netlink library"
HOMEPAGE="https://netfilter.org/projects/libmnl/"
SRC_URI="https://www.netfilter.org/pub/libmnl/libmnl-1.0.5.tar.bz2 -> libmnl-1.0.5.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/0.2.0"
KEYWORDS="*"
IUSE="examples static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	gen_usr_ldscript -a mnl
	prune_libtool_files

	if use examples; then
		find examples/ -name 'Makefile*' -delete
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}