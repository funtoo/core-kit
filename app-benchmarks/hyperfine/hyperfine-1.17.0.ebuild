# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo bash-completion-r1

CRATES="
ahash-0.7.6
ahash-0.8.3
aho-corasick-1.0.1
anstream-0.3.2
anstyle-1.0.0
anstyle-parse-0.2.0
anstyle-query-1.0.0
anstyle-wincon-1.0.1
anyhow-1.0.71
approx-0.5.1
arrayvec-0.7.2
assert_cmd-2.0.11
atty-0.2.14
autocfg-0.1.8
autocfg-1.1.0
bitflags-1.3.2
bitvec-1.0.1
borsh-0.10.3
borsh-derive-0.10.3
borsh-derive-internal-0.10.3
borsh-schema-derive-internal-0.10.3
bstr-1.5.0
bytecheck-0.6.11
bytecheck_derive-0.6.11
byteorder-1.4.3
bytes-1.4.0
cc-1.0.79
cfg-if-1.0.0
clap-4.3.1
clap_builder-4.3.1
clap_complete-4.3.1
clap_lex-0.5.0
cloudabi-0.0.3
colorchoice-1.0.0
colored-2.0.0
console-0.15.7
csv-1.2.2
csv-core-0.1.10
difflib-0.4.0
doc-comment-0.3.3
either-1.8.1
encode_unicode-0.3.6
errno-0.3.1
errno-dragonfly-0.1.2
fastrand-1.9.0
float-cmp-0.9.0
fuchsia-cprng-0.1.1
funty-2.0.0
getrandom-0.2.9
hashbrown-0.12.3
hashbrown-0.13.2
hermit-abi-0.1.19
hermit-abi-0.3.1
indicatif-0.17.4
instant-0.1.12
io-lifetimes-1.0.11
is-terminal-0.4.7
itertools-0.10.5
itoa-1.0.6
lazy_static-1.4.0
libc-0.2.144
linux-raw-sys-0.3.8
memchr-2.5.0
memoffset-0.7.1
nix-0.26.2
normalize-line-endings-0.3.0
num-0.2.1
num-bigint-0.2.6
num-complex-0.2.4
num-integer-0.1.45
num-iter-0.1.43
num-rational-0.2.4
num-traits-0.2.15
number_prefix-0.4.0
once_cell-1.17.2
pin-utils-0.1.0
portable-atomic-1.3.3
ppv-lite86-0.2.17
predicates-3.0.3
predicates-core-1.0.6
predicates-tree-1.0.9
proc-macro-crate-0.1.5
proc-macro2-1.0.59
ptr_meta-0.1.4
ptr_meta_derive-0.1.4
quote-1.0.28
radium-0.7.0
rand-0.6.5
rand-0.8.5
rand_chacha-0.1.1
rand_chacha-0.3.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.6.4
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.3.5
regex-1.8.3
regex-automata-0.1.10
regex-syntax-0.7.2
rend-0.4.0
rkyv-0.7.42
rkyv_derive-0.7.42
rust_decimal-1.29.1
rustix-0.37.19
ryu-1.0.13
seahash-4.1.0
serde-1.0.163
serde_derive-1.0.163
serde_json-1.0.96
shell-words-1.1.0
simdutf8-0.1.4
static_assertions-1.1.0
statistical-1.0.0
strsim-0.10.0
syn-1.0.109
syn-2.0.18
tap-1.0.1
tempfile-3.5.0
terminal_size-0.2.6
termtree-0.4.1
thiserror-1.0.40
thiserror-impl-1.0.40
tinyvec-1.6.0
tinyvec_macros-0.1.1
toml-0.5.11
unicode-ident-1.0.9
unicode-width-0.1.10
utf8parse-0.2.1
uuid-1.3.3
version_check-0.9.4
wait-timeout-0.2.0
wasi-0.11.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.45.0
windows-sys-0.48.0
windows-targets-0.42.2
windows-targets-0.48.0
windows_aarch64_gnullvm-0.42.2
windows_aarch64_gnullvm-0.48.0
windows_aarch64_msvc-0.42.2
windows_aarch64_msvc-0.48.0
windows_i686_gnu-0.42.2
windows_i686_gnu-0.48.0
windows_i686_msvc-0.42.2
windows_i686_msvc-0.48.0
windows_x86_64_gnu-0.42.2
windows_x86_64_gnu-0.48.0
windows_x86_64_gnullvm-0.42.2
windows_x86_64_gnullvm-0.48.0
windows_x86_64_msvc-0.42.2
windows_x86_64_msvc-0.48.0
wyz-0.5.1
"

DESCRIPTION="A command-line benchmarking tool"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="https://api.github.com/repos/sharkdp/hyperfine/tarball/v1.17.0 -> hyperfine-1.17.0.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+bash-completion zsh-completion fish-completion"

DEPEND=""
RDEPEND="
	bash-completion? ( app-shells/bash-completion )
	zsh-completion? ( app-shells/zsh-completions )
	fish-completion? ( app-shells/fish )
"
BDEPEND="virtual/rust"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/sharkdp-hyperfine-* ${S} || die
}

src_install() {
	cargo_src_install

	insinto /usr/share/hyperfine/scripts
	doins -r scripts/*

	doman doc/hyperfine.1

	einstalldocs

	if use bash-completion; then
		dobashcomp target/release/build/"${PN}"-*/out/"${PN}".bash
	fi

	if use fish-completion; then
		insinto /usr/share/fish/vendor_completions.d/
		doins target/release/build/"${PN}"-*/out/"${PN}".fish
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/vendor_completions.d/
		doins target/release/build/"${PN}"-*/out/_"${PN}"
	fi
}

pkg_postinst() {
	elog "You will need to install both 'numpy' and 'matplotlib' to make use of the scripts in '${EROOT%/}/usr/share/hyperfine/scripts'."
}