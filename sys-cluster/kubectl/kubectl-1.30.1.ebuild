# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/7f6f9261e634f9358385528d08cf989a455d4372 -> kubernetes-1.30.1-7f6f926.tar.gz
https://direct.funtoo.org/1d/28/16/1d28168d455f73efc7ecc7d50c2d7cfddaa971fd4954626ba69c3ca082eed2cd77f40dcbc2936c2fd7ef18f8329238d0d13de96d6a8512faa8b377ec609890a7 -> kubectl-1.30.1-funtoo-go-bundle-e4097fe99bb07c17ceb0fcacff18323e9b75e0230d66ba95226eef08e89a91daa2a13cf2f1861b66d16c53b1aa6078a0ccf4b81ccaf013e689ca541826d3a361.tar.gz"

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