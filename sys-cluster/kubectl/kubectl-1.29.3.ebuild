# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/9ebebe1d052bf42b8b0990cab80e00a4e3a1b417 -> kubernetes-1.29.3-9ebebe1.tar.gz
https://direct.funtoo.org/b1/f8/50/b1f85077722ca3f46e69331abd833948bb64d860633128ad71812cd31cce47d958c2ad3905b8cc4a1af49cdfbcd05f215a831b68b8a2feafe0f6d25c168baae6 -> kubectl-1.29.3-funtoo-go-bundle-eee0592370f8bc0cb0353c97ae431aa23a6e2d3b04fd902e7f665ab89b04bb33d80255a54ab2701e22453cc3d32a411f76f5e9e53f3b259ac7129e5fdafaeb29.tar.gz"

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