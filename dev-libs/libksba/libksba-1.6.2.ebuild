# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="X.509 and CMS (PKCS#7) library"
HOMEPAGE="https://www.gnupg.org/related_software/libksba"
SRC_URI="https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.2.tar.bz2 -> libksba-1.6.2.tar.bz2"

LICENSE="LGPL-3+ GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.8"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
"
PATCHES=(
	"${FILESDIR}"/"${PN}-1.6.0-no-fgrep-ksba-config.patch"
)

src_configure() {
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"

	local myeconfargs=(
		$(use_enable static-libs static)

		GPG_ERROR_CONFIG="${EROOT}/usr/bin/gpg-error-config"
		LIBGCRYPT_CONFIG="${EROOT}/usr/bin/libgcrypt-config"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# People need to use ksba-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}