# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Note: Please bump in sync with dev-libs/libxslt

PYTHON_COMPAT=( python3+ )

inherit autotools flag-o-matic gnome.org libtool python-single-r1

DESCRIPTION="XML C parser and toolkit"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home"
KEYWORDS="*"

SRC_URI="https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.5.tar.xz -> libxml2-2.11.5.tar.xz
test? (
  https://www.w3.org/XML/2004/xml-schema-test-suite/xmlschema2002-01-16/xsts-2002-01-16.tar.gz -> xsts-2002-01-16.tar.gz
  https://www.w3.org/XML/2004/xml-schema-test-suite/xmlschema2004-01-14/xsts-2004-01-14.tar.gz -> xsts-2004-01-14.tar.gz
  https://www.w3.org/XML/Test/xmlts20130923.tar.gz -> xmlts20130923.tar.gz
)
"

LICENSE="MIT"
SLOT="2"
# TODO: keep default USE "+" vars in sync in future autogen
IUSE="debug examples +ftp icu +lzma +python readline static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/libiconv
	>=sys-libs/zlib-1.2.8-r1:=
	icu? ( >=dev-libs/icu-51.2-r1:= )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:= )
	readline? ( sys-libs/readline:= )
"
# This USE variable now triggers the install of bindings in a separate package:
PDEPEND="python? ( dev-python/libxml2-python )"
DEPEND="${RDEPEND} ${PYTHON_DEPS}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.11.5-CVE-2023-45322.patch
)

src_prepare() {
	default
	elibtoolize
}

src_unpack() {
	local tarname=${P}.tar.xz

	# ${A} isn't used to avoid unpacking of test tarballs into ${WORKDIR},
	# as they are needed as tarballs in ${S}/xstc instead and not unpacked
	unpack ${tarname}

	if [[ -n ${PATCHSET_VERSION} ]] ; then
		unpack ${PN}-${PATCHSET_VERSION}.tar.xz
	fi

	cd "${S}" || die

	if use test ; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
		unpack ${XMLCONF_TARBALL}
	fi
}

src_configure() {
	# Filter seemingly problematic CFLAGS (bug #26320)
	filter-flags -fprefetch-loop-arrays -funroll-loops

	# Notes:
	# The meaning of the 'debug' USE flag does not apply to the --with-debug
	# switch (enabling the libxml2 debug module). See bug #100898.
	ECONF_SOURCE="${S}" econf \
		--enable-ipv6 \
		$(use_with ftp) \
		$(use_with debug run-debug) \
		$(use_with icu) \
		$(use_with lzma) \
		$(use_enable static-libs static) \
		$(use_with readline) \
		$(use_with readline history) \
		--with-python
}

src_compile() {
	# This generates libxml2.py which we need to exist in the python bindings:
	( cd ${S}/python && make all-local ) || die

	# No-op Makefile to disable python build. We just want this ^^
	cat > ${S}/python/Makefile << EOF
all :
install :
.PHONY : all
EOF
	# Peform the build, sans python:
	default
}

src_test() {
	ln -s "${S}"/xmlconf || die
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	if ! use examples ; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples || die
		rm -rf "${ED}"/usr/share/doc/${PF}/python/examples || die
	fi

	rm -rf "${ED}"/usr/share/doc/${PN}-python-${PVR} || die

	find "${ED}" -name '*.la' -delete || die

	# Install a pre-configured python source distribution for python bindings.
	# The libxml2-python ebuild will use this to build. These bindings have been
	# specifically configured to "match" this libxml2.

	dodir /usr/share/${PN}/bindings/
	# This generates certain data files which the python build uses to bind to the API:
	( cd ${S}/python && ./generator.py ) || die
	tar czf ${D}/usr/share/${PN}/bindings/${PN}-python-${PV}.tar.gz -C ${S} python || die
}

pkg_postinst() {
	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [[ -n "${ROOT}" ]]; then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# Need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${EROOT}/etc/xml/catalog"

		# We don't want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [[ ! -e "${CATALOG}" ]]; then
			[[ -d "${EROOT}/etc/xml" ]] || mkdir -p "${EROOT}/etc/xml"
			"${EPREFIX}"/usr/bin/xmlcatalog --create > "${CATALOG}"
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}

# vim: ts=4 sw=4 noet