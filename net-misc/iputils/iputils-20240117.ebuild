# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de fr ja pt_BR tr uk zh_CN"

inherit fcaps meson plocale toolchain-funcs

SRC_URI="https://github.com/iputils/iputils/tarball/8372f355bdf7a9b0c79338dd8ef8464c00a5c4e2 -> iputils-20240117-8372f35.tar.gz"
KEYWORDS="*"
DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"
S="${WORKDIR}/${P/_/}"
# We install ping unconditionally so BSD is listed by itself
# See LICENSE on each release, it summaries per-component
LICENSE="
	BSD
	arping? ( GPL-2+ )
	clockdiff? ( BSD )
	tracepath? ( GPL-2+ )
"
SLOT="0"
IUSE="+arping caps clockdiff doc idn nls test tracepath"
RESTRICT="!test? ( test )"

RDEPEND="
	caps? ( sys-libs/libcap )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-ns-stylesheets
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	test? ( sys-apps/iproute2 )
	nls? ( sys-devel/gettext )
"
src_unpack() {
	unpack "${A}"
        mv "${WORKDIR}/iputils-iputils"* "$S" || die
}

src_prepare() {
	default
	plocale_get_locales > po/LINGUAS || die
}

src_configure() {
	local emesonargs=(
		-DUSE_CAP=$(usex caps true false)
		-DUSE_IDN=$(usex idn true false)
		-DBUILD_ARPING=$(usex arping true false)
		-DBUILD_CLOCKDIFF=$(usex clockdiff true false)
		-DBUILD_PING=true
		-DBUILD_TRACEPATH=$(usex tracepath true false)
		-DNO_SETCAP_OR_SUID=true
		-DUSE_GETTEXT=$(usex nls true false)
		$(meson_use !test SKIP_TESTS)
		-DBUILD_HTML_MANS=$(usex doc true false)
		-DBUILD_MANS=true
	)

	meson_src_configure
}

src_compile() {
	tc-export CC

	meson_src_compile
}

src_test() {
	if [[ ${EUID} != 0 ]] ; then
		einfo "Tests require root privileges. Skipping ..."
		return
	fi

	meson_src_test
}

src_install() {
	meson_src_install

	FILECAPS=( cap_net_raw usr/bin/ping )
	use arping && FILECAPS+=( usr/bin/arping )
	use clockdiff && FILECAPS+=( usr/bin/clockdiff )

	dosym ping /usr/bin/ping4
	dosym ping /usr/bin/ping6

	if use tracepath ; then
		dosym tracepath /usr/bin/tracepath4
		dosym tracepath /usr/bin/tracepath6
		dosym tracepath.8 /usr/share/man/man8/tracepath4.8
		dosym tracepath.8 /usr/share/man/man8/tracepath6.8
	fi

	if use doc ; then
		mv "${ED}"/usr/share/${PN} "${ED}"/usr/share/doc/${PF}/html || die
	fi
}

pkg_preinst() {
	local version_with_tftpd="<${CATEGORY}/${PN}-20211215"
	if has_version "${version_with_tftpd}[traceroute6]" || has_version "${version_with_tftpd}[tftpd]" ; then
		HAD_TFTPD_VERSION=1
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst

	if [[ ${HAD_TFTPD_VERSION} -eq 1 ]] ; then
		ewarn "This upstream version (>= 20211215) drops two tools:"
		ewarn "1. tftpd (alternatives: net-ftp/tftp-hpa, net-dns/dnsmasq)"
		ewarn "2. traceroute6 (alternatives: net-analyzer/mtr, net-analyzer/traceroute)"
		ewarn "Please install one of the listed alternatives if needed!"
	fi
}