# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit libtool

DESCRIPTION="Multi-format archive and compression library"
HOMEPAGE="https://www.libarchive.org/"
SRC_URI="https://github.com/libarchive/libarchive/releases/download/v3.7.4/libarchive-3.7.4.tar.gz -> libarchive-3.7.4.tar.gz"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SLOT="0/13"
KEYWORDS="*"
IUSE="acl blake2 +bzip2 +e2fsprogs expat +iconv kernel_linux libressl lz4 +lzma lzo nettle static-libs +threads xattr +zlib zstd"

RDEPEND="
	acl? ( virtual/acl )
	blake2? ( app-crypt/libb2 )
	bzip2? ( app-arch/bzip2 )
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	iconv? ( virtual/libiconv )
	kernel_linux? (
		xattr? ( sys-apps/attr )
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	lz4? ( >=app-arch/lz4-0_p131:0= )
	lzma? ( app-arch/xz-utils )
	lzo? ( >=dev-libs/lzo-2 )
	nettle? ( dev-libs/nettle:0= )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )"
DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers
		e2fsprogs? ( sys-fs/e2fsprogs )
	)"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libarchive-libarchive* "${S}"
	fi
}

src_configure() {
	export ac_cv_header_ext2fs_ext2_fs_h=$(usex e2fsprogs) #354923

	local myconf=(
		$(use_enable acl)
		$(use_enable static-libs static)
		$(use_enable xattr)
		$(use_with blake2 libb2)
		$(use_with bzip2 bz2lib)
		$(use_with expat)
		$(use_with !expat xml2)
		$(use_with iconv)
		$(use_with lz4)
		$(use_with lzma)
		$(use_with lzo lzo2)
		$(use_with nettle)
		$(use_with zlib)
		$(use_with zstd)
		--enable-bsdcat=$(tc-is-static-only && echo static || echo shared)
        --enable-bsdcpio=$(tc-is-static-only && echo static || echo shared)
        --enable-bsdtar=$(tc-is-static-only && echo static || echo shared)

		# Windows-specific
		--without-cng
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

src_compile() {
	emake
}

src_test() {
	mkdir -p "${T}"/bin || die
	# tests fail when lbzip2[symlink] is used in place of ref bunzip2
	ln -s "${BROOT}/bin/bunzip2" "${T}"/bin || die
	local -x PATH=${T}/bin:${PATH}
	minimal_src_test
}

src_test() {
	# sandbox is breaking long symlink behavior
	local -x SANDBOX_ON=0
	local -x LD_PRELOAD=
	emake check
}

src_install() {
	emake DESTDIR="${D}" install

    # Libs.private: should be used from libarchive.pc instead
	find "${ED}" -type f -name "*.la" -delete || die
}

src_install_all() {
	cd "${S}" || die
	einstalldocs
}
