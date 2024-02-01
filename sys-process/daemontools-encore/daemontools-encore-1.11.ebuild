# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="https://untroubled.org/daemontools-encore/"
SRC_URI="https://github.com/bruceg/daemontools-encore/tarball/b40600d9ee0aa6025f33f2644207e069315ca64c -> daemontools-encore-1.11-b40600d.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="selinux"
# USE=static causes the tests to hang, so disable
# TODO: revisit!

RDEPEND="
	!app-doc/daemontools-man
	!sys-process/daemontools
	selinux? ( sec-policy/selinux-daemontools )
"
PATCHES=(
	"${FILESDIR}"/"${PN}-1.11-implicit-func-decl-clang16.patch"
	"${FILESDIR}"/"${PN}-1.11-use-posix-complaint-functions.patch"
)

S="${WORKDIR}/bruceg-daemontools-encore-b40600d"

src_compile() {
	# USE=static causes tests to hang, so disable
	# TODO: revisit!
	# use static && append-ldflags -static
	qmail_set_cc
	./makemake
	emake
}

src_install() {
	keepdir /service

	echo "${ED}/usr/bin" > conf-bin || die
	echo "${ED}/usr/share/man" > conf-man || die
	dodir /usr/bin
	dodir /usr/share/man
	emake install

	dodoc CHANGES CHANGES.djb README TODO

	newinitd "${FILESDIR}"/svscan.init-2 svscan
}

pkg_postinst() {
	einfo
	einfo "You can run daemontools using the svscan init.d script,"
	einfo "or you could run it through inittab."
	einfo "To use inittab, emerge supervise-scripts and run:"
	einfo "svscan-add-to-inittab"
	einfo "Then you can hup init with the command telinit q"
	einfo
}