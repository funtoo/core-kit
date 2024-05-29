# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Popular filesystem benchmark"
SRC_URI="https://www.samba.org/ftp/tridge/dbench/dbench-4.0.tar.gz -> dbench-4.0.tar.gz
"
HOMEPAGE="https://dbench.samba.org/web/index.html https://www.samba.org/ftp/tridge/dbench/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-libs/popt"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e "s:\$(CC) -o:\$(CC) \$(LDFLAGS) -o:" Makefile.in || die
	mv configure.{in,ac} || die

	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dbench tbench tbench_srv
	dodoc README INSTALL
	doman dbench.1
	insinto /usr/share/dbench
	doins client.txt
}

pkg_postinst() {
	elog "You can find the client.txt file in ${EROOT}/usr/share/dbench."
}