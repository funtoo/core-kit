# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="

https://github.com/Genymobile/scrcpy/tarball/f1b2d6bbbb5afd1f95913a49b94eda7cfb85226b -> scrcpy-2.0-f1b2d6b.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/libsdl2[X]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
BDEPEND=""

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/Genymobile-scrcpy-* ${S} || die
}

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${PN}-server-v${PV}"
	)
	meson_src_configure
}