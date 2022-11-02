# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools qmake-utils

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="https://gnupg.org/aegypten2"
SRC_URI="https://gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.1.tar.bz2 -> pinentry-1.2.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="caps efl emacs gnome-keyring gtk ncurses qt5"

DEPEND="
	dev-libs/libassuan
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	efl? ( dev-libs/efl[X] )
	gnome-keyring? ( app-crypt/libsecret )
	ncurses? ( sys-libs/ncurses:= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="
	${DEPEND}
	gtk? ( app-crypt/gcr:0[gtk] )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
IDEPEND=">=app-eselect/eselect-pinentry-0.7.2"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	default

	unset FLTK_CONFIG

	eautoreconf
}

src_configure() {
	export PATH="$(qt5_get_bindir):${PATH}"
	export QTLIB="$(qt5_get_libdir)"

	local myeconfargs=(
		$(use_enable efl pinentry-efl)
		$(use_enable emacs pinentry-emacs)
		$(use_enable gnome-keyring libsecret)
		$(use_enable gtk pinentry-gnome3)
		$(use_enable ncurses fallback-curses)
		$(use_enable ncurses pinentry-curses)
		$(use_enable qt5 pinentry-qt)

		--enable-pinentry-tty
		--disable-pinentry-fltk
		--disable-pinentry-gtk2

		MOC="$(qt5_get_bindir)"/moc
		GPG_ERROR_CONFIG="${EROOT}"/usr/bin/gpg-error-config
		LIBASSUAN_CONFIG="${EROOT}"/usr/bin/libassuan-config

		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm "${ED}"/usr/bin/pinentry || die

	use qt5 && dosym pinentry-qt /usr/bin/pinentry-qt5
}

pkg_postinst() {
	eselect pinentry update ifunset
}

pkg_postrm() {
	eselect pinentry update ifunset
}