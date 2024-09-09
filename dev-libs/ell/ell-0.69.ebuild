# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info multilib-minimal

DESCRIPTION="Embedded Linux Library provides core, low-level functionality for system daemons"
HOMEPAGE="https://01.org/ell"
SRC_URI="https://mirrors.edge.kernel.org/pub/linux/libs/ell/ell-0.69.tar.xz -> ell-0.69.tar.xz"
KEYWORDS="*"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="pie test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="test? ( sys-apps/dbus )"

CONFIG_CHECK="
	~TIMERFD
	~EVENTFD
	~CRYPTO_USER_API
	~CRYPTO_USER_API_HASH
	~CRYPTO_MD5
	~CRYPTO_SHA1
	~KEY_DH_OPERATIONS
"

multilib_src_configure() {
	append-cflags "-fsigned-char" #662694
	local myeconfargs=(
		$(use_enable pie)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	local DOCS=( ChangeLog README )
	einstalldocs

	find "${ED}" -name "*.la" -delete || die
}