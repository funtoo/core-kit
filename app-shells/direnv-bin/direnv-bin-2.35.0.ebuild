# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Direnv is an environment switcher for the shell"
HOMEPAGE="https://direnv.net"
SRC_URI="amd64? (
  https://github.com/direnv/direnv/releases/download/v2.35.0/direnv.linux-amd64 -> direnv.linux-amd64
)
arm64? (
  https://github.com/direnv/direnv/releases/download/v2.35.0/direnv.linux-arm64 -> direnv.linux-arm64
)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

# no tests included with binary
RESTRICT="test"

S=${WORKDIR}

src_install() {
	exeinto /usr/bin
	newexe ${DISTDIR}/${A} direnv
}