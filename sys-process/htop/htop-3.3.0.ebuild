# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit autotools linux-info python-any-r1 xdg

DESCRIPTION="interactive process viewer"
HOMEPAGE="https://htop.dev/ https://github.com/htop-dev/htop"
SRC_URI="https://api.github.com/repos/htop-dev/htop/tarball/3.3.0 -> htop-3.3.0.tar.gz"
KEYWORDS="*"

LICENSE="BSD GPL-2"
SLOT="0"
IUSE="debug hwloc kernel_FreeBSD kernel_linux lm_sensors openvz unicode vserver"

BDEPEND="virtual/pkgconfig"
RDEPEND="sys-libs/ncurses:0=
	hwloc? ( sys-apps/hwloc )
	lm_sensors? ( sys-apps/lm_sensors )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

pkg_setup() {
	if ! has_version sys-process/lsof; then
		ewarn "To use lsof features in htop (what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi

	python-any-r1_pkg_setup
	linux-info_pkg_setup
}

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/htop-dev-htop-* ${S} || die
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable hwloc)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable vserver)
		$(use_enable lm_sensors sensors)
	)

	if ! use hwloc && use kernel_linux ; then
		myeconfargs+=( --enable-affinity )
	else
		myeconfargs+=( --disable-affinity )
	fi

	econf ${myeconfargs[@]}
}
pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}