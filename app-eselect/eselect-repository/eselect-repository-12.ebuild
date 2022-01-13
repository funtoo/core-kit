# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit python-single-r1

DESCRIPTION="Manage repos.conf via eselect"
HOMEPAGE="https://github.com/mgorny/eselect-repository"
SRC_URI="https://api.github.com/repos/mgorny/eselect-repository/tarball/refs/tags/v12 -> eselect-repository-v12.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	app-admin/eselect
	dev-python/lxml[${PYTHON_USEDEP}]
	net-misc/wget"

src_unpack() {
  default
  rm -rf ${S}
  mv ${WORKDIR}/mgorny-eselect-repository-* ${S} || die  
}

src_compile() {
	MAKEARGS=(
		PREFIX="${EPREFIX}/usr"
		SYSCONFDIR="${EPREFIX}/etc"
		SHAREDSTATEDIR="${EPREFIX}/var"
		ESELECTDIR="${EPREFIX}/usr/share/eselect/modules"
	)

	emake "${MAKEARGS[@]}"
	python_fix_shebang eselect-repo-helper
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	keepdir /var/db/repos
	einstalldocs
}