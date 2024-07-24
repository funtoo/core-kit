# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pam tmpfiles

DESCRIPTION="screen manager with VT100/ANSI terminal emulation"
HOMEPAGE="https://www.gnu.org/software/screen/"

SRC_URI="https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz -> screen-4.9.1.tar.gz
"
KEYWORDS="*"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug nethack pam selinux multiuser"

# Don't need this depdency until we support musl, at which point we'll need to create virtual/libcrypt
#	virtual/libcrypt:=
DEPEND=">=sys-libs/ncurses-5.2:=
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-screen )"
BDEPEND=">=sys-apps/texinfo-7"

PATCHES=(
	# Don't use utempter even if it is found on the system.
	"${FILESDIR}"/${PN}-4.3.0-no-utempter.patch
	"${FILESDIR}"/${PN}-4.6.2-utmp-exit.patch
)

pkg_setup() {
	enewgroup utmp
}

src_prepare() {
	default

	# sched.h is a system header and causes problems with some C libraries
	mv sched.h _sched.h || die
	sed -i '/include/ s:sched.h:_sched.h:' screen.h || die

	# Fix manpage
	sed -i \
		-e "s:/usr/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/usr/local/screens:${EPREFIX}/tmp/screen:g" \
		-e "s:/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/etc/utmp:${EPREFIX}/var/run/utmp:g" \
		-e "s:/local/screens/S\\\-:${EPREFIX}/tmp/screen/S\\\-:g" \
		doc/screen.1 || die

	if [[ ${CHOST} == *-darwin* ]] || use elibc_musl; then
		sed -i -e '/^#define UTMPOK/s/define/undef/' acconfig.h || die
	fi

	# disable musl dummy headers for utmp[x]
	use elibc_musl && append-cppflags "-D_UTMP_H -D_UTMPX_H"

	# reconfigure
	eautoreconf
}

src_configure() {
	append-cppflags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"

	if [[ ${CHOST} == *-solaris* ]]; then
		# enable msg_header by upping the feature standard compatible
		# with c99 mode
		append-cppflags -D_XOPEN_SOURCE=600
	fi

	use nethack || append-cppflags "-DNONETHACK"
	use debug && append-cppflags "-DDEBUG"

	local myeconfargs=(
		--with-socket-dir="${EPREFIX}/tmp/${PN}"
		--with-sys-screenrc="${EPREFIX}/etc/screenrc"
		--with-pty-mode=0620
		--with-pty-group=5
		--enable-rxvt_osc
		--enable-telnet
		--enable-colors256
		$(use_enable pam)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	LC_ALL=POSIX emake comm.h term.h
	emake osdef.h

	emake -C doc screen.info
	default
}

src_install() {
	local DOCS=(
		README ChangeLog INSTALL TODO NEWS* patchlevel.h
		doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps}
	)

	emake DESTDIR="${D}" SCREEN="${P}" install

	local tmpfiles_perms tmpfiles_group

	if use multiuser || use prefix ; then
		fperms 4755 /usr/bin/${P}
		tmpfiles_perms="0755"
		tmpfiles_group="root"
	else
		fowners root:utmp /usr/bin/${P}
		fperms 2755 /usr/bin/${P}
		tmpfiles_perms="0775"
		tmpfiles_group="utmp"
	fi

	newtmpfiles - screen.conf <<<"d /tmp/screen ${tmpfiles_perms} root ${tmpfiles_group}"

	insinto /usr/share/${PN}
	doins terminfo/{screencap,screeninfo.src}

	insinto /etc
	doins "${FILESDIR}"/screenrc

	if use pam; then
		pamd_mimic_system screen auth
	fi

	dodoc "${DOCS[@]}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Some dangerous key bindings have been removed or changed to more safe values."
		elog "We enable some xterm hacks in our default screenrc, which might break some"
		elog "applications. Please check /etc/screenrc for information on these changes."
	fi

	tmpfiles_process screen.conf

	ewarn "This revision changes the screen socket location to ${EROOT}/tmp/${PN}"
}