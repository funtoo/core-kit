# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A framework for managing DNS information"
HOMEPAGE="https://roy.marples.name/projects/openresolv"
SRC_URI="https://github.com/NetworkConfiguration/openresolv/tarball/867a412d63a28d2c4978e02fc44fb8013f46d356 -> openresolv-3.13.2-867a412.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-resolvconf )"

S="${WORKDIR}"/NetworkConfiguration-openresolv-867a412

src_configure() {
	local myeconfargs=(
		--prefix="${EPREFIX}"
		--rundir="${EPREFIX}"/run
		--libexecdir="${EPREFIX}"/lib/resolvconf
	)
	econf "${myeconfargs[@]}"
}

pkg_config() {
	if [[ -n ${ROOT} ]]; then
		eerror "We cannot configure unless \$ROOT is empty"
		return 1
	fi

	if [[ -n "$(resolvconf -l)" ]]; then
		einfo "${PN} already has DNS information"
	else
		ebegin "Copying /etc/resolv.conf to resolvconf -a dummy"
		resolvconf -a dummy </etc/resolv.conf
		eend $? || return $?
		einfo "The dummy interface will disappear when you next reboot"
	fi
}

DOCS=( LICENSE README.md )

#! vim: noet ts=4 syn=ebuild