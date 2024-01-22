# Distributed under the terms of the GNU General Public License v2

EAPI=7
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools toolchain-funcs

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="https://zlib.net/"
SRC_URI="https://zlib.net/zlib-1.3.1.tar.xz -> zlib-1.3.1.tar.xz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="minizip static-libs"

DEPEND="minizip? ( ${AUTOTOOLS_DEPEND} )"
RDEPEND=""
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-minizip-drop-crypt-header.patch
)
src_prepare() {
	default
	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
	fi
}

echoit() { echo "$@"; "$@"; }

src_configure() {
	# not an autoconf script, so can't use econf
	local uname=$("${EPREFIX}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3) #347167
	echoit "${S}"/configure \
		--shared \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		${uname:+--uname=${uname}} \
		|| die

	if use minizip ; then
		local minizipdir="contrib/minizip"
		cd ${minizipdir} || die
		ECONF_SOURCE="${S}/${minizipdir}" \
		econf $(use_enable static-libs static)
	fi
}

src_compile() {
	emake
	use minizip && emake -C contrib/minizip
}

sed_macros() {
	# clean up namespace a little #383179
	# we do it here so we only have to tweak 2 files
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' "$@" || die
}

src_install() {
	emake install DESTDIR="${D}" LDCONFIG=:
	gen_usr_ldscript -a z
	sed_macros "${ED}"/usr/include/*.h
	if use minizip ; then
		emake -C contrib/minizip install DESTDIR="${D}"
		sed_macros "${ED}"/usr/include/minizip/*.h
	fi
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/lib{z,minizip}.{a,la} #419645
	dodoc FAQ README ChangeLog doc/*.txt
	use minizip && dodoc contrib/minizip/*.txt
}