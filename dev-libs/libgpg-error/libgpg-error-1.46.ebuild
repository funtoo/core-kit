# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs prefix

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="https://www.gnupg.org/related_software/libgpg-error/"
SRC_URI="https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.bz2 -> libgpg-error-1.46.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="common-lisp nls static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="nls? ( >=virtual/libintl-0-r1 )"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
"
PATCHES=(
	"${FILESDIR}"/"${PN}-1.44-remove_broken_check.patch"
)

src_prepare() {
	default

	# only necessary for as long as we run eautoreconf, configure.ac
	# uses ./autogen.sh to generate PACKAGE_VERSION, but autogen.sh is
	# not a pure /bin/sh script, so it fails on some hosts
	hprefixify -w 1 autogen.sh
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable common-lisp languages)
		$(use_enable nls)
		# required for sys-power/suspend[crypt], bug 751568
		$(use_enable static-libs static)
		$(use_enable test tests)

		# See bug #699206 and its duplicates wrt gpgme-config
		# Upstream no longer install this by default and we should
		# seek to disable it at some point.
		--enable-install-gpg-error-config

		--enable-threads
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}