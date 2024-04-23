# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

SRC_URI="https://api.github.com/repos/google/google-authenticator-libpam/tarball/refs/tags/1.10 -> google-authenticator-libpam-1.10.tar.gz"
KEYWORDS="*"

DESCRIPTION="PAM Module for two step verification via mobile platform"
HOMEPAGE="https://github.com/google/google-authenticator-libpam"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

post_src_unpack() {
	mv "${WORKDIR}"/google-google-authenticator-libpam-* "${S}" || die
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# We might want to use getpam_mod_dir from pam eclass,
	# but the build already appends "/security" for us.
	econf --libdir="/$(get_libdir)"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "For further information see"
		elog "https://wiki.gentoo.org/wiki/Google_Authenticator"
		elog ""
		elog "If you want support for QR-Codes, install media-gfx/qrencode."
	fi
}