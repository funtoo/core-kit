# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz -> autoconf-2.13.tar.gz
"
KEYWORDS="*"

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
IUSE="emacs"
LICENSE="GPL-2"
SLOT="2.1"
PATCHES=(
	"$FILESDIR"/autoconf-2.13-gentoo.patch
	"$FILESDIR"/autoconf-2.13-destdir.patch
	"$FILESDIR"/autoconf-2.13-test-fixes.patch
	"$FILESDIR"/autoconf-2.13-perl-5.26.patch
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
	# make sure configure is newer than configure.in
	touch configure || die

	# need to include --exec-prefix and --bindir or our
	# DESTDIR patch will trigger sandbox hate :(
	#
	# need to force locale to C to avoid bugs in the old
	# configure script breaking the install paths #351982
	#
	# force to `awk` so that we don't encode another awk that
	# happens to currently be installed, but might later be
	# uninstalled (like mawk).	same for m4.
	local prepend=""
	use userland_BSD && prepend="g"
	ac_cv_path_M4="${prepend}m4" \
	ac_cv_prog_AWK="${prepend}awk" \
	LC_ALL=C \
	econf \
		--exec-prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--program-suffix="-${PV}"
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