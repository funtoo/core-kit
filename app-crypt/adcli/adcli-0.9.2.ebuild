# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool for performing actions on an Active Directory domain"
HOMEPAGE="https://www.freedesktop.org/software/realmd/adcli/adcli.html"
SRC_URI="https://gitlab.freedesktop.org/realmd/adcli/-/archive/0.9.2/adcli-0.9.2.tar.bz2 -> adcli-0.9.2.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

DEPEND="
	app-crypt/mit-krb5
	net-nds/openldap:=[sasl]"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/docbook-xml-dtd:4.3
		app-text/xmlto
		dev-libs/libxslt
	)"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable doc)
}