# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs https://github.com/rfjakob/gocryptfs/releases"

SRC_URI="https://github.com/rfjakob/gocryptfs/tarball/aafbf94f91a5bcce18e696add48b7268a7c87776 -> gocryptfs-2.5.0-aafbf94.tar.gz
https://direct.funtoo.org/82/fd/50/82fd5062af92afe075fb9462c552b8edfc7ef04e2d2ead5ce777fe195ea3c85ead1ab77117ccfb2077017188d48bf404cf7dde894275073f23392c2b1a59ad51 -> gocryptfs-2.5.0-funtoo-go-bundle-4928c3dcde4d89a64cb4f7b1e355c5eeea6e6cadc25e2cb394188d832253f12965cbc8e0593552cf933503509cb016760b10fef4c0df579a20ef4f0c00de69ec.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"

SLOT="0"
KEYWORDS="*"
IUSE="debug +man pie +ssl"

BDEPEND="man? ( dev-go/go-md2man )"
RDEPEND="
	sys-fs/fuse
	ssl? ( dev-libs/openssl:0= )
"

S="${WORKDIR}/rfjakob-gocryptfs-aafbf94"

# We omit debug symbols which looks like pre-stripping to portage.
QA_PRESTRIPPED="
	/usr/bin/gocryptfs-atomicrename
	/usr/bin/gocryptfs-findholes
	/usr/bin/gocryptfs-statfs
	/usr/bin/gocryptfs-xray
	/usr/bin/gocryptfs
"

src_compile() {
	export GOPATH="${G}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "main.GitVersion=v${PV}"
		-X "'main.GitVersionFuse=[vendored]'"
		-X "main.BuildDate=$(date -u '+%Y-%m-%d')"
	)

	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie exe)"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
		-tags "$(usex !ssl 'without_openssl' 'none')"
	)

	go build "${mygoargs[@]}" || die

	# loop over all helper tools
	for dir in gocryptfs-xray contrib/statfs contrib/findholes contrib/atomicrename; do
		cd "${S}/${dir}" || die
		go build "${mygoargs[@]}" || die
	done

	cd "${S}"

	if use man; then
		go-md2man -in Documentation/MANPAGE.md -out gocryptfs.1 || die
		go-md2man -in Documentation/MANPAGE-STATFS.md -out gocryptfs-statfs.2 || die
		go-md2man -in Documentation/MANPAGE-XRAY.md -out gocryptfs-xray.1 || die
	fi
}

src_install() {
	dobin gocryptfs
	dobin gocryptfs-xray/gocryptfs-xray

	newbin contrib/statfs/statfs "${PN}-statfs"
	newbin contrib/findholes/findholes "${PN}-findholes"
	newbin contrib/atomicrename/atomicrename "${PN}-atomicrename"

	if use man; then
		doman gocryptfs.1
		doman gocryptfs-xray.1
		doman gocryptfs-statfs.2
	fi
}