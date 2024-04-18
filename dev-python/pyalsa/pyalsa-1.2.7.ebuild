# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python bindings for ALSA library"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="https://www.alsa-project.org/files/pub/pyalsa/pyalsa-1.2.7.tar.bz2 -> pyalsa-1.2.7.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${REPODIR}/media-sound/files/${PN}/${PN}-1.1.6-no-build-symlinks.patch" )