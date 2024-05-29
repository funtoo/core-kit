# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz -> autoconf-2.69.tar.xz
"
KEYWORDS="*"

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
IUSE="emacs"
LICENSE="GPL-3+"
SLOT="$(ver_cut 1-2)"
PATCHES=(
	"$FILESDIR"/autoconf-2.69-perl-5.26.patch
	"$FILESDIR"/autoconf-2.69-fix-libtool-test.patch
	"$FILESDIR"/autoconf-2.69-perl-5.26-2.patch
)

BDEPEND="
	sys-apps/texinfo
	>=dev-lang/perl-5.10
	>=sys-devel/m4-1.4.16
"
RDEPEND="
	${BDEPEND}
	>=sys-devel/autoconf-wrapper-13
	sys-devel/gnuconfig
	!~sys-devel/${P}:2.5
"

PDEPEND="emacs? ( app-emacs/autoconf-mode )"
src_configure() {
	export EMACS=no
	local myconf=(
		--program-suffix="-${PV}"
	)

	econf "${myconf[@]}" || die
	# econf updates config.{sub,guess} which forces the manpages
	# to be regenerated which we dont want to do #146621
	touch man/*.1
}

src_prepare() {
	find -name Makefile.in -exec sed -i '/^pkgdatadir/s:$:-@VERSION@:' {} + || die
	default
}

src_test() {
	emake check
}

src_install() {
	default
	rm -rf ${D}/usr/share/info
}