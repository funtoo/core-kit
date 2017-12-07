# Distributed under the terms of the GNU General Public License v2

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

EAPI="3"

VERSION_BUSYBOX='1.21.1'
VERSION_DMRAID='1.0.0.rc16-3'
VERSION_MDADM='3.1.5'
VERSION_E2FSPROGS='1.42'
VERSION_FUSE='2.8.6'
VERSION_ISCSI='2.0-872'
VERSION_UNIONFS_FUSE='0.24'
VERSION_GPG='1.4.11'

MY_HOME="mirror://funtoo/${PN}"
RH_HOME="ftp://sources.redhat.com/pub"
DM_HOME="http://people.redhat.com/~heinzm/sw/dmraid/src"
BB_HOME="http://www.busybox.net/downloads"

COMMON_URI="mirror://funtoo/genkernel/dmraid-${VERSION_DMRAID}.tar.bz2
		mirror://funtoo/genkernel/busybox-${VERSION_BUSYBOX}.tar.bz2
		mirror://funtoo/genkernel/open-iscsi-${VERSION_ISCSI}.tar.gz
		mirror://funtoo/genkernel/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz
		mirror://funtoo/genkernel/fuse-${VERSION_FUSE}.tar.gz
		mirror://funtoo/genkernel/unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.bz2
		mirror://funtoo/genkernel/gnupg-${VERSION_GPG}.tar.bz2"

GITHUB_REPO="${PN}"
GITHUB_USER="funtoo"
GITHUB_TAG="v${PVR}-funtoo"

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/${PN}.git
		http://git.overlays.gentoo.org/gitroot/proj/${PN}.git"
	inherit git-2 bash-completion-r1 eutils
	S="${WORKDIR}/${PN}"
	SRC_URI="${COMMON_URI}"
	KEYWORDS=""
else
	inherit bash-completion-r1 eutils
	SRC_URI="https://www.github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/${GITHUB_TAG} -> ${PN}-${GITHUB_TAG}.tar.gz
		${COMMON_URI}"
	KEYWORDS="*"
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"
IUSE="btrfs +cryptsetup ibm selinux"

DEPEND="sys-fs/e2fsprogs
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}
		btrfs? ( sys-fs/btrfs-progs )
		cryptsetup? ( sys-fs/cryptsetup )
		sys-fs/lvm2
		sys-fs/mdadm
		app-misc/pax-utils
		!<sys-apps/openrc-0.9.9"
# pax-utils is used for lddtree
# cpio is part of Funtoo @system set

if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND} app-text/asciidoc"
fi

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		git-2_src_unpack
	else
		default
	fi
}

src_prepare() {
	cd "${WORKDIR}"/${GITHUB_USER}-${PN}-*
	S="$(pwd)"
	use selinux && sed -i 's/###//g' "${S}"/gen_compile.sh
}

src_compile() {
	return
}

src_compile() {
	if [[ ${PV} == 9999* ]]; then
		emake || die
	fi
}

src_install() {
	# This block updates genkernel.conf
	sed \
		-e "s:VERSION_BUSYBOX:$VERSION_BUSYBOX:" \
		-e "s:VERSION_MDADM:$VERSION_MDADM:" \
		-e "s:VERSION_DMRAID:$VERSION_DMRAID:" \
		-e "s:VERSION_E2FSPROGS:$VERSION_E2FSPROGS:" \
		-e "s:VERSION_FUSE:$VERSION_FUSE:" \
		-e "s:VERSION_ISCSI:$VERSION_ISCSI:" \
		-e "s:VERSION_UNIONFS_FUSE:$VERSION_UNIONFS_FUSE:" \
		-e "s:VERSION_GPG:$VERSION_GPG:" \
		"${S}"/genkernel.conf > "${T}"/genkernel.conf \
		|| die "Could not adjust versions"
	insinto /etc
	doins "${T}"/genkernel.conf || die "doins genkernel.conf"

	doman genkernel.8 || die "doman"
	dodoc AUTHORS ChangeLog README TODO || die "dodoc"

	dobin genkernel || die "dobin genkernel"

	rm -f genkernel genkernel.8 AUTHORS ChangeLog README TODO genkernel.conf

	insinto /usr/share/genkernel
	doins -r "${S}"/* || die "doins"
	use ibm && cp "${S}"/ppc64/kernel-2.6-pSeries "${S}"/ppc64/kernel-2.6 || \
		cp "${S}"/arch/ppc64/kernel-2.6.g5 "${S}"/arch/ppc64/kernel-2.6

	# Copy files to /usr/share/genkernel/src
	elog "Copying files to /usr/share/genkernel/src..."
	mkdir -p "${D}"/usr/share/genkernel/src
	cp -f \
		"${DISTDIR}"/dmraid-${VERSION_DMRAID}.tar.bz2 \
		"${DISTDIR}"/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz \
		"${DISTDIR}"/busybox-${VERSION_BUSYBOX}.tar.bz2 \
		"${DISTDIR}"/fuse-${VERSION_FUSE}.tar.gz \
		"${DISTDIR}"/unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.bz2 \
		"${DISTDIR}"/gnupg-${VERSION_GPG}.tar.bz2 \
		"${DISTDIR}"/open-iscsi-${VERSION_ISCSI}.tar.gz \
		"${D}"/usr/share/genkernel/src || die "Copying distfiles..."

	newbashcomp "${FILESDIR}"/genkernel.bash "${PN}"
	insinto /etc
	doins "${FILESDIR}"/initramfs.mounts
}

pkg_postinst() {
	echo
	elog 'Documentation is available in the genkernel manual page'
	elog 'as well as the following URL:'
	echo
	elog 'http://www.gentoo.org/doc/en/genkernel.xml'
	echo
	ewarn "This package is known to not work with reiser4.  If you are running"
	ewarn "reiser4 and have a problem, do not file a bug.  We know it does not"
	ewarn "work and we don't plan on fixing it since reiser4 is the one that is"
	ewarn "broken in this regard.  Try using a sane filesystem like ext3 or"
	ewarn "even reiser3."
	echo
	ewarn "The LUKS support has changed from versions prior to 3.4.4.  Now,"
	ewarn "you use crypt_root=/dev/blah instead of real_root=luks:/dev/blah."
	echo
}
