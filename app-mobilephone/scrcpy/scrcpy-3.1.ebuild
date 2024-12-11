# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-server-v3.1 -> scrcpy-server-v3.1
https://github.com/Genymobile/scrcpy/archive/refs/tags/v3.1.tar.gz -> scrcpy-3.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/libsdl2[X]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${PN}-server-v${PV}"
	)
	meson_src_configure
}