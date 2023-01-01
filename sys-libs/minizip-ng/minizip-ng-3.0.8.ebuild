# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution."
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/minizip-ng/tarball/cee6d8cbd4da70c48e9df1426607ff95b4f24fa6 -> minizip-ng-3.0.8-cee6d8c.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="compat openssl test zstd"
RESTRICT="!test? ( test )"

# Automagically prefers sys-libs/zlib-ng if installed, so let's
# just depend on it as presumably it's better tested anyway.
RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib-ng
	virtual/libiconv
	compat? ( !sys-libs/zlib[minizip] )
	openssl? ( dev-libs/openssl:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	${REPODIR}//files/${PN}-3.0.7-system-gtest.patch
)

post_src_unpack() {
	mv ${WORKDIR}/zlib-ng-minizip-ng-* ${S} || die
}


src_configure() {
	local mycmakeargs=(
		-DMZ_COMPAT=$(usex compat)

		-DMZ_BUILD_TESTS=$(usex test)
		-DMZ_BUILD_UNIT_TESTS=$(usex test)

		-DMZ_FETCH_LIBS=OFF
		-DMZ_FORCE_FETCH_LIBS=OFF

		# Compression library options
		-DMZ_ZLIB=ON
		-DMZ_BZIP2=ON
		-DMZ_LZMA=ON
		-DMZ_ZSTD=$(usex zstd)
		-DMZ_LIBCOMP=OFF

		# Encryption support options
		-DMZ_PKCRYPT=ON
		-DMZ_WZAES=ON
		-DMZ_OPENSSL=$(usex openssl)
		# MZ_LIBBSD -- Builds with libbsd crypto random
		# Turning this option on breaks compilation on Funtoo next
		# https://bugs.funtoo.org/browse/FL-10883
		-DMZ_LIBBSD=OFF
		-DMZ_SIGNING=ON

		# Character conversion options
		-DMZ_ICONV=ON
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# TODO: investigate
		-E "(raw-unzip-pkcrypt|raw-append-unzip-pkcrypt|raw-erase-unzip-pkcrypt|deflate-unzip-pkcrypt|deflate-append-unzip-pkcrypt|deflate-erase-unzip-pkcrypt|bzip2-unzip-pkcrypt|bzip2-append-unzip-pkcrypt|bzip2-erase-unzip-pkcrypt|lzma-unzip-pkcrypt|lzma-append-unzip-pkcrypt|lzma-erase-unzip-pkcrypt|xz-unzip-pkcrypt|xz-append-unzip-pkcrypt|xz-erase-unzip-pkcrypt|zstd-unzip-pkcrypt|zstd-append-unzip-pkcrypt|zstd-erase-unzip-pkcrypt)"
	)

	# TODO: A bunch of tests end up looping and writing over each other's files
	# It gets better with a patch applied (see https://github.com/zlib-ng/minizip-ng/issues/623#issuecomment-1264518994)
	# but still hangs.
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}