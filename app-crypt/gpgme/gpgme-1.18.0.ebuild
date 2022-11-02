# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 libtool flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.18.0.tar.bz2 -> gpgme-1.18.0.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1/11.27.15.1"
KEYWORDS="*"
IUSE="common-lisp static-libs +cxx python qt5 test"
RESTRICT="!test? ( test )"

# - On each bump, update dep bounds on each version from configure.ac!
# - Quirky libgpg-error dep for bug #699206 (change in recent libgpg-error
#   made gpgme stop installing gpgme-config)
RDEPEND="app-crypt/gnupg
	dev-libs/libassuan
	dev-libs/libgpg-error
	python? ( ${PYTHON_DEPS} )
	qt5? ( dev-qt/qtcore:5 )"
	#doc? ( app-doc/doxygen[dot] )
DEPEND="${RDEPEND}
	test? (
		qt5? ( dev-qt/qttest:5 )
	)"
BDEPEND="python? ( dev-lang/swig )"

REQUIRED_USE="qt5? ( cxx ) python? ( ${PYTHON_REQUIRED_USE} )"
PATCHES=(
	"${FILESDIR}"/"${PN}-1.18.0-tests-start-stop-agent-use-command-v.patch"
)

do_python() {
	if use python; then
		pushd "lang/python" > /dev/null || die
		top_builddir="../.." srcdir="." CPP="$(tc-getCPP)" distutils-r1_src_${EBUILD_PHASE}
		popd > /dev/null || die
	fi
}

src_prepare() {
	default

	elibtoolize

	# bug #697456
	addpredict /run/user/$(id -u)/gnupg

	local MAX_WORKDIR=66
	if use test && [[ "${#WORKDIR}" -gt "${MAX_WORKDIR}" ]]; then
		eerror "Unable to run tests as WORKDIR='${WORKDIR}' is longer than ${MAX_WORKDIR} which causes failure!"
		die "Could not run tests as requested with too-long WORKDIR."
	fi

	# Make best effort to allow longer PORTAGE_TMPDIR
	# as usock limitation fails build/tests
	ln -s "${P}" "${WORKDIR}/b" || die
	S="${WORKDIR}/b"
}

src_configure() {
	local languages=()

	use common-lisp && languages+=( "cl" )
	use cxx && languages+=( "cpp" )
	if use qt5; then
		languages+=( "qt" )
		#use doc ||
		export DOXYGEN=true
		export MOC="$(qt5_get_bindir)/moc"
	fi

	# bug #847955
	append-lfs-flags

	econf \
		$(use test || echo "--disable-gpgconf-test --disable-gpg-test --disable-gpgsm-test --disable-g13-test") \
		--enable-languages="${languages[*]}" \
		$(use_enable static-libs static)

	use python && emake -C lang/python prepare

	do_python
}

src_compile() {
	default
	do_python
}

src_test() {
	default

	use python && distutils-r1_src_test
}

python_test() {
	emake -C lang/python/tests check \
		PYTHON=${EPYTHON} \
		PYTHONS=${EPYTHON} \
		TESTFLAGS="--python-libdir=${BUILD_DIR}/lib"
}

src_install() {
	default

	do_python

	find "${ED}" -type f -name '*.la' -delete || die

	# Backward compatibility for gentoo
	# (in the past, we had slots)
	dodir /usr/include/gpgme
	dosym ../gpgme.h /usr/include/gpgme/gpgme.h
}