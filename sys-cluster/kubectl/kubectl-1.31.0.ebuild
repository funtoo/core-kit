# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/e73bd2e33f000c5a2886771e712d6c90796a4873 -> kubernetes-1.31.0-e73bd2e.tar.gz
https://direct.funtoo.org/62/84/fa/6284fa5c881400972368eba64e9efc2f0f3f18df5556f7116c6b1d8a6b166f3359b9310628f107e0a63591a6384626b0090335fad696d65bf412c9a0095c1d46 -> kubectl-1.31.0-funtoo-go-bundle-ac558c5ab09681140cc7252ff2c97c2d39994738b6782ce52f0678b2bae459a5ba2bc6a2d4c6d46ae59529c266226b3d05c445dd7c76e559307816ba907d1287.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

DEPEND="!sys-cluster/kubernetes"
BDEPEND=">=dev-lang/go-1.21"

RESTRICT+=" test"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/kubernetes-kubernetes-* ${S} || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	FORCE_HOST_GO=yes \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}