# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!burnt!sushi/toml v1.0.0"
	"github.com/!burnt!sushi/toml v1.0.0/go.mod"
	"github.com/alessio/shellescape v1.4.1"
	"github.com/alessio/shellescape v1.4.1/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.1/go.mod"
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/evanphx/json-patch/v5 v5.6.0"
	"github.com/evanphx/json-patch/v5 v5.6.0/go.mod"
	"github.com/google/safetext v0.0.0-20220905092116-b49f7bc46da2"
	"github.com/google/safetext v0.0.0-20220905092116-b49f7bc46da2/go.mod"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/jessevdk/go-flags v1.4.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.14"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e/go.mod"
	"github.com/pelletier/go-toml v1.9.4"
	"github.com/pelletier/go-toml v1.9.4/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/spf13/cobra v1.4.0"
	"github.com/spf13/cobra v1.4.0/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b/go.mod"
	"gopkg.in/yaml.v2 v2.4.0"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	"sigs.k8s.io/yaml v1.3.0"
	"sigs.k8s.io/yaml v1.3.0/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/kubernetes-sigs/kind/tarball/0296c52b38a6bb5ccdcbcf4e57f0ba79415e6ff2 -> kind-0.23.0-0296c52.tar.gz
https://direct.funtoo.org/74/fb/44/74fb44e9b90a75cdd48f60b84efe28e49266b0b65e5f0e4a5116f7e3fad1bac7d90e191327e3c14160a5ad8dd1348c84bf3d623ba714aac60b331694406c01dd -> kind-0.23.0-funtoo-go-bundle-db8518754d1e638fe192cccde4cd9c8baca418c8936f901d6d2db1e6009b8fa11f36d0b9b408145c7e40589ef57a913145ee061c9553745746ed550b1abef7fc.tar.gz"

DESCRIPTION="Tool for running local Kubernetes clusters using Docker container nodes"
HOMEPAGE="https://kind.sigs.k8s.io/ https://github.com/kubernetes-sigs/kind"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

BDEPEND="dev-lang/go"
RDEPEND="app-emulation/docker"

post_src_unpack() {
	mv "${WORKDIR}"/kubernetes-sigs-kind-* "${S}" || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}