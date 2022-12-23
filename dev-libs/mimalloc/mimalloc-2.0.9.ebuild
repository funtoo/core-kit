# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="mimalloc is a compact general purpose allocator with excellent performance."
HOMEPAGE="https://github.com/microsoft/mimalloc"
SRC_URI="https://github.com/microsoft/mimalloc/tarball/28cf67e5b64c704cad993c71f29a24e781bee544 -> mimalloc-2.0.9-28cf67e.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="next"
IUSE="hardened test"
RESTRICT="!test? ( test )"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv "${WORKDIR}"/microsoft-* "${S}" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DMI_SECURE=$(usex hardened)

		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_BUILD_TESTS=$(usex test)

		-DMI_BUILD_OBJECT=OFF
		-DMI_BUILD_STATIC=OFF
	)

	cmake-multilib_src_configure
}