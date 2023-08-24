# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit python-single-r1

DESCRIPTION="Python3 compatible clone of dstat"
HOMEPAGE="https://github.com/scottchiefbaker/dool"
SRC_URI="https://github.com/scottchiefbaker/dool/tarball/755e94050925125a67187276b4386621eda54b9f -> dool-1.2.0-755e940.tar.gz"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="*"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/scottchiefbaker-dool* "${S}" || die
	fi
}

src_compile() {
	${S}/install.py
}

DOCS=( AUTHORS ChangeLog README.md )

src_install() {
	python_doexe ${S}/dool

	python_moduleinto dool
	python_domodule ${S}/plugins/*.py

	doman ${S}/docs/dool.1
	dodoc "${DOCS[@]}"
}