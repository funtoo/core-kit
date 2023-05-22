# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!burnt!sushi/toml v1.2.0"
	"github.com/!burnt!sushi/toml v1.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.14"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/mod v0.5.1"
	"golang.org/x/mod v0.5.1/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
)

go-module_set_globals

DESCRIPTION="Direnv is an environment switcher for the shell"
HOMEPAGE="https://direnv.net"
SRC_URI="https://github.com/direnv/direnv/tarball/66225ccf94e923268c46c10be666cd281d916601 -> direnv-2.32.3-66225cc.tar.gz
https://direct.funtoo.org/48/d2/aa/48d2aafdcbcfeee659ef54a5239d65c238e4ea6c129e3235f0c1e2dcdecc1510fd7b6b902af23bb6286bbbfd56e8d12d7a7d5bb4b6f1783ce2372a99d5d3c9b7 -> direnv-2.32.3-funtoo-go-bundle-88d17fb7238febb9164af104584deabe10ca0b0b32db328a9d1e789bf9c67b153d4f1a83e4857c545e5627f44ee9c496a1dc821645a1fde6c9a821e867f9f036.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-lang/go"

# depends on golangci-lint which we do not have an ebuild for
RESTRICT="test"

post_src_unpack() {
	mv "${WORKDIR}"/direnv-direnv-* "${S}" || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	einstalldocs
}