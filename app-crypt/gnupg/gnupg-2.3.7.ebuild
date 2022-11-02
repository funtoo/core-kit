# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P/_/-}"

DESCRIPTION="The GNU Privacy Guard, a GPL OpenPGP implementation"
HOMEPAGE="https://gnupg.org/"
SRC_URI="https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.7.tar.bz2 -> gnupg-2.3.7.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="bzip2 doc ldap nls readline selinux +smartcard ssl test +tofu tpm tools usb user-socket wks-server"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( tofu )"

# Existence of executables is checked during configuration.
# Note: On each bump, update dep bounds on each version from configure.ac!
DEPEND="dev-libs/libassuan
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/libksba
	dev-libs/npth
	>=net-misc/curl-7.10
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	ldap? ( net-nds/openldap:= )
	readline? ( sys-libs/readline:0= )
	smartcard? ( usb? ( virtual/libusb:1 ) )
	tofu? ( >=dev-db/sqlite-3.27 )
	tpm? ( >=app-crypt/tpm2-tss-2.4.0:= )
	ssl? ( >=net-libs/gnutls-3.0:0= )
"

RDEPEND="${DEPEND}
	app-crypt/pinentry
	nls? ( virtual/libintl )
	selinux? ( sec-policy/selinux-gpg )
	wks-server? ( virtual/mta )"

BDEPEND="virtual/pkgconfig
	doc? ( sys-apps/texinfo )
	nls? ( sys-devel/gettext )"

DOCS=(
	ChangeLog NEWS README THANKS TODO VERSION
	doc/FAQ doc/DETAILS doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER
)
PATCHES=(
	"${FILESDIR}"/"${PN}-2.1.20-gpgscm-Use-shorter-socket-path-lengts-to-improve-tes.patch"
	"${FILESDIR}"/"${PN}-2.3.7-yubikey-workaround-fix.patch"
)

src_configure() {
	local myconf=(
		$(use_enable bzip2)
		$(use_enable nls)
		$(use_enable smartcard scdaemon)
		$(use_enable ssl gnutls)
		$(use_enable test all-tests)
		$(use_enable test tests)
		$(use_enable tofu)
		$(use_enable tofu keyboxd)
		$(use_enable tofu sqlite)
		$(usex tpm '--with-tss=intel' '--disable-tpm2d')
		$(use smartcard && use_enable usb ccid-driver || echo '--disable-ccid-driver')
		$(use_enable wks-server wks-tools)
		$(use_with ldap)
		$(use_with readline)
		--with-mailprog=/usr/libexec/sendmail
		--disable-ntbtls
		--enable-gpgsm
		--enable-large-secmem

		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		GPG_ERROR_CONFIG="${EROOT}/usr/bin/gpg-error-config"
		KSBA_CONFIG="${EROOT}/usr/bin/ksba-config"
		LIBASSUAN_CONFIG="${EROOT}/usr/bin/libassuan-config"
		LIBGCRYPT_CONFIG="${EROOT}/usr/bin/libgcrypt-config"
		NPTH_CONFIG="${EROOT}/usr/bin/npth-config"

		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	if use prefix && use usb; then
		# bug #649598
		append-cppflags -I"${EROOT}/usr/include/libusb-1.0"
	fi

	# bug #663142
	if use user-socket; then
		myconf+=( --enable-run-gnupg-user-socket )
	fi

	# glib fails and picks up clang's internal stdint.h causing weird errors
	tc-is-clang && export gl_cv_absolute_stdint_h="${EROOT}"/usr/include/stdint.h

	# Hardcode mailprog to /usr/libexec/sendmail even if it does not exist.
	# As of GnuPG 2.3, the mailprog substitution is used for the binary called
	# by wks-client & wks-server; and if it's autodetected but not not exist at
	# build time, then then 'gpg-wks-client --send' functionality will not
	# work. This has an unwanted side-effect in stage3 builds: there was a
	# [R]DEPEND on virtual/mta, which also brought in virtual/logger, bloating
	# the build where the install guide previously make the user chose the
	# logger & mta early in the install.

	econf "${myconf[@]}"
}

src_compile() {
	default

	use doc && emake -C doc html
}

src_test() {
	# bug #638574
	use tofu && export TESTFLAGS=--parallel

	default
}

src_install() {
	default

	use tools &&
		dobin \
			tools/{convert-from-106,gpg-check-pattern} \
			tools/{gpgconf,gpgsplit,lspgpot,mail-signed-keys} \
			tools/make-dns-cert

	dosym gpg /usr/bin/gpg2
	dosym gpgv /usr/bin/gpgv2
	echo ".so man1/gpg.1" > "${ED}"/usr/share/man/man1/gpg2.1 || die
	echo ".so man1/gpgv.1" > "${ED}"/usr/share/man/man1/gpgv2.1 || die

	dodir /etc/env.d
	echo "CONFIG_PROTECT=/usr/share/gnupg/qualified.txt" >> "${ED}"/etc/env.d/30gnupg || die

	use doc && dodoc doc/gnupg.html/* doc/*.png
}