# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/949ad4c99a1c5b5dc6871a8785f4f1a55b20c1ef -> kubernetes-1.29.2-949ad4c.tar.gz
https://direct.funtoo.org/15/59/47/155947b425e532fdecd719e6d642609e70c0ef9e637b9051f7660a842032828beb8ecb2ed590ef229df2267645b99ca7b39d28af4e8ffc8ca4f2c832e1097fa7 -> kubectl-1.29.2-funtoo-go-bundle-68c8d6e1e1945bb4acccddf4ab2a14da67715e866056cc16747e0c0c3341868a5ed882100e3e3f2f9db07530e9f3ceb3a694a1caede8bf3143f9c452bb20d382.tar.gz"

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