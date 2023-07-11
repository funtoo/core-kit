# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A kubectl plugin for interactively changing the kubeconfig context"
HOMEPAGE="https://github.com/weibeld/kubectl-ctx"
SRC_URI="https://github.com/weibeld/kubectl-ctx/archive/84ce9a632d4cdc33dc31ce7a00bda1365b3707a7.tar.gz -> kubectl-ctx-20221229-84ce9a632d4cdc33dc31ce7a00bda1365b3707a7.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	sys-cluster/kubectl
	app-shells/fzf
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/kubectl-ctx-84ce9a632d4cdc33dc31ce7a00bda1365b3707a7"

src_install() {
	dobin kubectl-ctx
	dodoc README.md
}
