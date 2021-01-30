# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ahash-0.4.7
aho-corasick-0.7.15
ansi_term-0.11.0
ansi_term-0.12.1
arrayref-0.3.6
arrayvec-0.5.2
attohttpc-0.16.1
atty-0.2.14
autocfg-1.0.1
base64-0.13.0
battery-0.7.8
bitflags-0.9.1
bitflags-1.2.1
blake2b_simd-0.5.11
block-0.1.6
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byte-unit-4.0.9
byteorder-1.4.2
bytes-1.0.1
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
const_fn-0.4.5
constant_time_eq-0.1.5
core-foundation-0.7.0
core-foundation-0.9.1
core-foundation-sys-0.7.0
core-foundation-sys-0.8.2
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.1
crossbeam-utils-0.8.1
dbus-0.9.1
digest-0.8.1
dirs-1.0.5
dirs-next-2.0.0
dirs-sys-next-0.1.2
dlv-list-0.2.2
dtoa-0.4.7
either-1.6.1
fake-simd-0.1.2
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.0
generic-array-0.12.3
gethostname-0.2.1
getrandom-0.1.16
getrandom-0.2.2
git2-0.13.17
hashbrown-0.9.1
hermit-abi-0.1.18
http-0.2.3
idna-0.2.0
indexmap-1.6.1
itoa-0.4.7
jobserver-0.1.21
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.84
libdbus-sys-0.2.1
libgit2-sys-0.12.18+1.1.0
libz-sys-1.1.2
linked-hash-map-0.5.4
log-0.4.14
mac-notification-sys-0.3.0
mach-0.3.2
malloc_buf-0.0.6
maplit-1.0.2
matches-0.1.8
memchr-2.3.4
memoffset-0.6.1
native-tls-0.2.7
nix-0.19.1
notify-rust-4.2.2
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.0
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.5.2
opaque-debug-0.2.3
open-1.4.0
openssl-0.10.32
openssl-probe-0.1.2
openssl-src-111.13.0+1.1.1i
openssl-sys-0.9.60
ordered-multimap-0.3.1
os_info-3.0.1
path-slash-0.1.4
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
pkg-config-0.3.19
ppv-lite86-0.2.10
proc-macro2-1.0.24
process_control-3.0.1
quick-xml-0.20.0
quote-0.3.15
quote-1.0.8
rand-0.7.3
rand-0.8.3
rand_chacha-0.2.2
rand_chacha-0.3.0
rand_core-0.5.1
rand_core-0.6.1
rand_hc-0.2.0
rand_hc-0.3.0
rayon-1.5.0
rayon-core-1.9.0
redox_syscall-0.1.57
redox_syscall-0.2.4
redox_users-0.3.5
redox_users-0.4.0
regex-1.4.3
regex-syntax-0.6.22
remove_dir_all-0.5.3
rust-argon2-0.8.3
rust-ini-0.16.1
ryu-1.0.5
schannel-0.1.19
scopeguard-1.1.0
security-framework-2.0.0
security-framework-sys-2.0.0
semver-0.11.0
semver-parser-0.10.2
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.61
serde_urlencoded-0.6.1
sha-1-0.8.2
shadow-rs-0.5.23
shell-words-1.0.0
starship_module_config_derive-0.1.2
strsim-0.8.0
strum-0.8.0
strum_macros-0.8.0
syn-0.11.11
syn-1.0.60
synom-0.11.3
sys-info-0.8.0
tempfile-3.2.0
term_size-0.3.2
textwrap-0.11.0
thiserror-1.0.23
thiserror-impl-1.0.23
thread_local-1.1.2
time-0.1.44
tinyvec-1.1.1
tinyvec_macros-0.1.0
toml-0.5.8
typenum-1.12.0
ucd-trie-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.0.4
unicode-xid-0.2.1
uom-0.30.0
url-2.2.0
urlencoding-1.1.1
utf8-width-0.1.4
vcpkg-0.2.11
vec_map-0.8.2
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.0+wasi-snapshot-preview1
which-4.0.2
wildmatch-1.0.13
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
winrt-0.4.0
winrt-notification-0.2.2
xml-rs-0.6.1
yaml-rust-0.4.5
"

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://api.github.com/repos/starship/starship/tarball/v0.49.0 -> starship-v0.49.0.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE="libressl"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

DOCS="docs/README.md"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/starship-starship-* ${S} || die
}

src_install() {
	dobin target/release/${PN}
	default
}


pkg_postinst() {
        echo
        elog "Thanks for installing starship."
        elog "For better experience, it's suggested to install some Powerline font."
        elog "You can get some from https://github.com/powerline/fonts"
        echo
}