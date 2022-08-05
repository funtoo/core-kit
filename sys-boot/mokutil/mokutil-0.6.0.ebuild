# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The utility to manipulate machines owner keys which managed in shim"
HOMEPAGE="https://github.com/lcp/mokutil"
SRC_URI="https://github.com/lcp/mokutil/tarball/b4d8693f04bcf43986aba061845947534b384152 -> mokutil-0.6.0-b4d8693.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-libs/openssl:=
	sys-apps/keyutils:=
	sys-libs/efivar:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/lcp-* ${S} || die
    fi
}

src_prepare() {
	default
	eautoreconf
}