# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool

DESCRIPTION="IPC library used by GnuPG and GPGME"
HOMEPAGE="https://www.gnupg.org/related_software/libassuan/"
SRC_URI="https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.5.tar.bz2 -> libassuan-2.5.5.tar.bz2"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="*"

# Note: On each bump, update dep bounds on each version from configure.ac!
RDEPEND="dev-libs/libgpg-error"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		--disable-static
		GPG_ERROR_CONFIG="${EROOT}/usr/bin/gpg-error-config"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# ppl need to use libassuan-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}