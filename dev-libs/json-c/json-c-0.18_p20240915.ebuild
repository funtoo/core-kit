# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
SRC_URI="https://github.com/json-c/json-c/tarball/41a55cfcedb54d9c1874f2f0eb07b504091d7e37 -> json-c-0.18-41a55cf.tar.gz"

KEYWORDS="*"

SLOT="0/5"
IUSE="cpu_flags_x86_rdrand doc static-libs threads"

DEPEND="!dev-libs/json:0/True"

BDEPEND="doc? ( >=app-doc/doxygen-1.8.13 )
	|| (
		>=sys-libs/glibc-2.36[static-libs?]
		(
			dev-libs/libbsd[static-libs?]
			app-crypt/libmd[static-libs?]
		)
	)"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv json-c-json-c* "${S}" || die
	fi
}

src_prepare() {
	cmake_src_prepare

	if ! has_version -b ">=sys-libs/glibc-2.36" ;then
		sed -i -e 's/-ljson-c/& -lbsd -lmd/'  ${S}/json-c.pc.in || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DDISABLE_WERROR=ON
		-DENABLE_RDRAND=$(usex cpu_flags_x86_rdrand)
		-DENABLE_THREADING=$(usex threads)
	)

	cmake_src_configure
}


src_install() {
	cmake_src_install

	use doc && HTML_DOCS=( "${S}"/doc/html/. )
	einstalldocs
}