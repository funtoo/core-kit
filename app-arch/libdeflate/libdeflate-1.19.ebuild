# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/libdeflate/ebiggers"
SRC_URI="https://github.com/ebiggers/libdeflate/tarball/484346dea605fa43295c1770333f94abf08280c4 -> libdeflate-1.19-484346d.tar.gz"

KEYWORDS="*"


LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

post_src_unpack() {
	cd ${WORKDIR} && mv ebiggers-libdeflate-* libdeflate-1.19
}

src-configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}
