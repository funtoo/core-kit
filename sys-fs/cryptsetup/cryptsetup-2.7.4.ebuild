# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info tmpfiles autotools

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="https://gitlab.com/cryptsetup/cryptsetup/blob/master/README.md"
SRC_URI="https://github.com/mbroz/cryptsetup/tarball/538068263d0ccc58433eba5d330a40195ad53bdc -> cryptsetup-2.7.4-5380682.tar.gz"

LICENSE="GPL-2+"
SLOT="0/10" # libcryptsetup.so version
KEYWORDS="*"

CRYPTO_BACKENDS="gcrypt kernel nettle +openssl"
# we don't support nss since it doesn't allow cryptsetup to be built statically
# and it's missing ripemd160 support so it can't provide full backward compatibility
IUSE="${CRYPTO_BACKENDS} doc fips nls pwquality +reencrypt ssh static static-libs test +udev urandom"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( ${CRYPTO_BACKENDS//+/} )
	static? ( !gcrypt !openssl !udev !fips )
	fips? ( !kernel !nettle )
" # 496612, 832711, 843863. See FL-10620 about static vs udev.

LIB_DEPEND="
	>=dev-libs/json-c-0.16_p20220414:=[static-libs(+)]
	dev-libs/popt[static-libs(+)]
	>=sys-apps/util-linux-2.31-r1[static-libs(+)]
	app-crypt/argon2:=[static-libs(+)]
	gcrypt? (
		dev-libs/libgcrypt:0=[static-libs(+)]
		dev-libs/libgpg-error[static-libs(+)]
	)
	nettle? ( >=dev-libs/nettle-2.4[static-libs(+)] )
	openssl? ( dev-libs/openssl:0=[static-libs(+)] )
	pwquality? ( dev-libs/libpwquality[static-libs(+)] )
	ssh? ( net-libs/libssh[static-libs(+)] )
	sys-fs/lvm2[static-libs(+)]"
# We have to always depend on ${LIB_DEPEND} rather than put behind
# !static? () because we provide a shared library which links against
# these other packages. #414665
RDEPEND="static-libs? ( ${LIB_DEPEND} )
	${LIB_DEPEND//\[static-libs\([+-]\)\]}
	udev? ( virtual/libudev:= )"
# vim-core needed for xxd in tests
DEPEND="${RDEPEND}
	doc? ( app-text/asciidoctor )
	static? ( ${LIB_DEPEND} )
	test? ( app-editors/vim-core )"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_/-}"

pkg_setup() {
	local CONFIG_CHECK="~DM_CRYPT ~CRYPTO ~CRYPTO_CBC ~CRYPTO_SHA256"
	local WARNING_DM_CRYPT="CONFIG_DM_CRYPT:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_SHA256="CONFIG_CRYPTO_SHA256:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_CBC="CONFIG_CRYPTO_CBC:\tis not set (required for kernel 2.6.19)\n"
	local WARNING_CRYPTO="CONFIG_CRYPTO:\tis not set (required for cryptsetup)\n"
	check_extra_config
}

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv mbroz-cryptsetup* "${S}"
	fi
}

src_prepare() {
	sed -i '/^LOOPDEV=/s:$: || exit 0:' tests/{compat,mode}-test || die
	eautoreconf
	default
}

src_configure() {
	if use kernel ; then
		ewarn "Note that kernel backend is very slow for this type of operation"
		ewarn "and is provided mainly for embedded systems wanting to avoid"
		ewarn "userspace crypto libraries."
	fi

	local myeconfargs=(
		--enable-libargon2
		--enable-shared
		--sbindir="${EPREFIX}"/sbin
		# for later use
		--with-default-luks-format=LUKS2
		--with-tmpfilesdir="${EPREFIX}/usr/lib/tmpfiles.d"
		--with-crypto_backend=$(for x in ${CRYPTO_BACKENDS//+/} ; do usev ${x} ; done)
		$(use_enable doc asciidoc)
		$(use_enable udev)
		$(use_enable nls)
		$(use_enable pwquality)
		$(usex reencrypt '' '--disable-luks2-reencrypt')
		$(use_enable !static external-tokens)
		$(use_enable static static-cryptsetup)
		$(use_enable static-libs static)
		$(use_enable !urandom dev-random)
		$(use_enable ssh ssh-token)
		$(use_enable fips)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	if [[ ! -e /dev/mapper/control ]] ; then
		ewarn "No /dev/mapper/control found -- skipping tests"
		return 0
	fi

	local p
	for p in /dev/mapper /dev/loop* ; do
		addwrite ${p}
	done

	default
}

src_install() {
	default

	if use static ; then
		mv "${ED}"/sbin/cryptsetup{.static,} || die
		mv "${ED}"/sbin/veritysetup{.static,} || die
		mv "${ED}"/sbin/integritysetup{.static,} || die
	fi
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc docs/v*ReleaseNotes

	newconfd "${FILESDIR}"/dmcrypt.confd dmcrypt
	newinitd "${FILESDIR}"/dmcrypt.rc dmcrypt
}

pkg_postinst() {
	tmpfiles_process cryptsetup.conf
}