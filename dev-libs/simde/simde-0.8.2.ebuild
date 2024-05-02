# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Header-only library provides fast, portable implementations of SIMD intrinsics"
HOMEPAGE="https://github.com/simd-everywhere/simde"
SRC_URI="https://github.com/simd-everywhere/simde/tarball/71fd833d9666141edcd1d3c109a80e228303d8d7 -> simde-0.8.2-71fd833.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="test"
RESTRICT="!test? ( test )"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv "${WORKDIR}"/simd-everywhere-* "${S}" || die
	fi
}

src_configure() {
	# *FLAGS are only used for tests (nothing that is installed), and
	# upstream tests with specific *FLAGS and is otherwise flaky with
	# -march=native, -mno-*, and such -- unset to be spared headaches.
	unset {C,CPP,CXX,LD}FLAGS

	local emesonargs=(
		$(meson_use test tests)
	)

	meson_src_configure
}