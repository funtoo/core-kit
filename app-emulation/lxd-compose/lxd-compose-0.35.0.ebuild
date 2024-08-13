# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Deploy a complex environment to an LXD Cluster or LXD standalone installation"
HOMEPAGE="https://github.com/MottainaiCI/lxd-compose https://mottainaici.github.io/lxd-compose-docs"
SRC_URI="https://github.com/MottainaiCI/lxd-compose/releases/download/v0.35.0/lxd-compose-v0.35.0-source.tar.gz -> lxd-compose-0.35.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

DEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}"

src_compile() {
	emake_args=(
		LDFLAGS=""
		GOFLAGS="-v -x -mod=vendor"
	)

	emake "${emake_args[@]}" build || die
}

src_install() {
	dobin "${PN}"
	dodoc README.md
}