# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
SRC_URI="https://github.com/json-c/json-c/tarball/2f2ddc1f2dbca56c874e8f9c31b5b963202d80e7 -> json-c-0.16-2f2ddc1.tar.gz"

KEYWORDS="*"

SLOT="0/True"
IUSE="cpu_flags_x86_rdrand doc static-libs threads"

BDEPEND="doc? ( >=app-doc/doxygen-1.8.13 )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/json-c/config.h
)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv json-c-json-c* "${S}" || die
	fi
}

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DDISABLE_WERROR=ON
		-DENABLE_RDRAND=$(usex cpu_flags_x86_rdrand)
		-DENABLE_THREADING=$(usex threads)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	multilib_is_native_abi && cmake_src_test
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( "${S}"/doc/html/. )
	einstalldocs
}