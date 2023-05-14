# Distributed under the terms of the GNU General Public License v2
# 🦊 ❤ metatools: {autogen_id}

EAPI=7

inherit meson

DESCRIPTION="Headers defining the SPICE protocol"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v0.14.4/spice-protocol-v0.14.4.tar.gz -> spice-protocol-v0.14.4.tar.gz"
S="${WORKDIR}/${PN}-v0.14.4"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""