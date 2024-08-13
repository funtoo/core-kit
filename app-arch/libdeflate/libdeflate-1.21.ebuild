# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/libdeflate/ebiggers"
SRC_URI="https://github.com/ebiggers/libdeflate/tarball/6c011136e34a09270c0eb2d5f392006c55a017b7 -> libdeflate-1.21-6c01113.tar.gz"

KEYWORDS="*"


LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

post_src_unpack() {
	cd ${WORKDIR} && mv ebiggers-libdeflate-* libdeflate-1.21
}

src-configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}
