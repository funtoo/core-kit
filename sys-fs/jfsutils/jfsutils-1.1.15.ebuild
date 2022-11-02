# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="IBM's Journaling Filesystem (JFS) Utilities"
HOMEPAGE="http://jfs.sourceforge.net/"
SRC_URI="https://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz -> jfsutils-1.1.15.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="static"

LIB_DEPEND="sys-apps/util-linux:=[static-libs]"

RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs]} )"

DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-linux-headers.patch
	"${FILESDIR}"/${P}-sysmacros.patch
	"${FILESDIR}"/${P}-check-for-ar.patch
	"${FILESDIR}"/${P}-gcc10.patch
	"${FILESDIR}"/${P}-format-security-errors.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	use static && append-ldflags -static
	econf --sbindir=/sbin
}

src_install() {
	default

	rm -f "${ED}"/sbin/{mkfs,fsck}.jfs || die
	dosym jfs_mkfs /sbin/mkfs.jfs
	dosym jfs_fsck /sbin/fsck.jfs
}