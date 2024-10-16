# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic systemd
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/smartmontools/code/trunk/smartmontools"
	ESVN_PROJECT="smartmontools"
	inherit subversion
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Tools to monitor storage systems to provide advanced warning of disk degradation"
HOMEPAGE="https://www.smartmontools.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="caps +daemon selinux static update_drivedb"

DEPEND="
	caps? (
		static? ( sys-libs/libcap-ng[static-libs] )
		!static? ( sys-libs/libcap-ng )
	)
	kernel_FreeBSD? (
		sys-freebsd/freebsd-lib[usb]
	)
	selinux? (
		sys-libs/libselinux
	)"
RDEPEND="${DEPEND}
	daemon? ( virtual/mailx )
	selinux? ( sec-policy/selinux-smartmon )
	update_drivedb? (
		app-crypt/gnupg
		|| (
			net-misc/curl
			net-misc/wget
			www-client/lynx
			dev-vcs/subversion
		)
	)
"

REQUIRED_USE="( caps? ( daemon ) )"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	# The build installs /etc/init.d/smartd, but we clobber it
	# in our src_install, so no need to manually delete it.
	myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--with-drivedbdir="${EPREFIX}/var/db/${PN}" #575292
		--with-initscriptdir="${EPREFIX}/etc/init.d"
		$(use_with caps libcap-ng)
		$(use_with selinux)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_with update_drivedb gnupg)
		$(use_with update_drivedb update-smart-drivedb)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local db_path="/var/db/${PN}"

	if use daemon; then
		default

		newinitd "${FILESDIR}"/smartd-r1.rc smartd
		newconfd "${FILESDIR}"/smartd.confd smartd
		systemd_newunit "${FILESDIR}"/smartd.systemd smartd.service
	else
		dosbin smartctl
		doman smartctl.8

		local DOCS=( AUTHORS ChangeL* COPYING INSTALL NEWS README TODO )
		einstalldocs
	fi

	if use update_drivedb ; then
		if ! use daemon; then
			dosbin "${S}"/update-smart-drivedb
		fi

		exeinto /etc/cron.monthly
		doexe "${FILESDIR}/${PN}-update-drivedb"
	fi

	if use daemon || use update_drivedb; then
		keepdir "${db_path}"

		# Install a copy of the initial drivedb.h to /usr/share/${PN}
		# so that we can access that file later in pkg_postinst
		# even when dealing with binary packages (bug #575292)
		insinto /usr/share/${PN}
		doins "${S}"/drivedb.h
	fi

	# Make sure we never install drivedb.h into the db location
	# of the acutal image so we don't record hashes because user
	# can modify that file
	rm -f "${ED%/}${db_path}/drivedb.h" || die

	# Bug #622072
	find "${ED%/}"/usr/share/doc -type f -exec chmod a-x '{}' \; || die
}

pkg_postinst() {
	if use daemon || use update_drivedb; then
		local initial_db_file="${EPREFIX%/}/usr/share/${PN}/drivedb.h"
		local db_path="${EPREFIX%/}/var/db/${PN}"

		if [[ ! -f "${db_path}/drivedb.h" ]] ; then
			# No initial database found
			cp "${initial_db_file}" "${db_path}" || die
			einfo "Default drive database which was shipped with this release of ${PN}"
			einfo "has been installed to '${db_path}'."
		else
			ewarn "WARNING: There's already a drive database in '${db_path}'!"
			ewarn "Because we cannot determine if this database is untouched"
			ewarn "or was modified by the user you have to manually update the"
			ewarn "drive database:"
			ewarn ""
			ewarn "a) Replace '${db_path}/drivedb.h' by the database shipped with this"
			ewarn "   release which can be found in '${initial_db_file}', i.e."
			ewarn ""
			ewarn "     cp \"${initial_db_file}\" \"${db_path}\""
			ewarn ""
			ewarn "b) Run the following command as root:"
			ewarn ""
			ewarn "     /usr/sbin/update-smart-drivedb"

			if ! use update_drivedb ; then
				ewarn ""
				ewarn "However, 'update-smart-drivedb' requires that you re-emerge ${PN}"
				ewarn "with USE='update_drivedb'."
			fi
		fi
	fi
}
