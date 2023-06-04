# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ahash-0.8.3
aho-corasick-1.0.1
android-tzdata-0.1.1
android_system_properties-0.1.5
anstream-0.3.2
anstyle-1.0.0
anstyle-parse-0.2.0
anstyle-query-1.0.0
anstyle-wincon-1.0.1
autocfg-1.1.0
bitflags-1.3.2
bumpalo-3.13.0
cc-1.0.79
cfg-if-1.0.0
chrono-0.4.26
clap-4.3.1
clap_builder-4.3.1
clap_derive-4.3.1
clap_lex-0.5.0
colorchoice-1.0.0
core-foundation-sys-0.8.4
crossterm-0.26.1
crossterm_winapi-0.9.0
csv-1.2.2
csv-core-0.1.10
directories-next-2.0.0
dirs-4.0.0
dirs-sys-0.3.7
dirs-sys-next-0.1.2
either-1.8.1
errno-0.3.1
errno-dragonfly-0.1.2
fallible-iterator-0.2.0
fallible-streaming-iterator-0.1.9
filedescriptor-0.8.2
getrandom-0.2.9
hashbrown-0.13.2
hashlink-0.8.2
heck-0.4.1
hermit-abi-0.3.1
humantime-2.1.0
iana-time-zone-0.1.56
iana-time-zone-haiku-0.1.2
io-lifetimes-1.0.11
is-terminal-0.4.7
itertools-0.10.5
itoa-1.0.6
js-sys-0.3.63
libc-0.2.144
libsqlite3-sys-0.25.2
linux-raw-sys-0.3.8
lock_api-0.4.9
log-0.4.18
memchr-2.5.0
mio-0.8.8
num-traits-0.2.15
once_cell-1.17.2
parking_lot-0.12.1
parking_lot_core-0.9.7
pkg-config-0.3.27
ppv-lite86-0.2.17
proc-macro2-1.0.59
quote-1.0.28
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.8.3
regex-syntax-0.7.2
relative-path-1.8.0
rusqlite-0.28.0
rustix-0.37.19
ryu-1.0.13
scopeguard-1.1.0
serde-1.0.163
shellexpand-2.1.2
signal-hook-0.3.15
signal-hook-mio-0.2.3
signal-hook-registry-1.4.1
smallvec-1.10.0
strsim-0.10.0
syn-2.0.18
thiserror-1.0.40
thiserror-impl-1.0.40
time-0.1.45
unicode-ident-1.0.9
unicode-segmentation-1.10.1
utf8parse-0.2.1
vcpkg-0.2.15
version_check-0.9.4
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.86
wasm-bindgen-backend-0.2.86
wasm-bindgen-macro-0.2.86
wasm-bindgen-macro-support-0.2.86
wasm-bindgen-shared-0.2.86
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.48.0
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
"

inherit cargo

DESCRIPTION="Context-aware bash history search replacement (ctrl-r)"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://api.github.com/repos/cantino/mcfly/tarball/v0.8.1 -> mcfly-0.8.1.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="/usr/bin/mcfly"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/cantino-mcfly-* ${S} || die
}

src_install() {
	cargo_src_install

	insinto "/usr/share/${PN}"
	doins "${PN}".{bash,fish,zsh}

	einstalldocs
}

pkg_postinst() {

	elog "To start using ${PN}, add the following to your shell:"
	elog
	elog "~/.bashrc"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.bash"
	elog "[[ -f ${p} ]] && source ${p}"
	elog
	elog "~/.config/fish/config.fish"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.fish"
	elog "if test -r ${p}"
	elog "    source ${p}"
	elog "    mcfly_key_bindings"
	elog
	elog "~/.zsh"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.zsh"
	elog "[[ -f ${p} ]] && source ${p}"
}