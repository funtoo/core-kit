# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utility to find btrfs compression type/ratio on a file or set of files"
HOMEPAGE="https://github.com/kilobyte/compsize"

SRC_URI="https://github.com/kilobyte/compsize/tarball/0ae6d84b3ac1ac62f6976ce6bf1aa9bb94e83391 -> compsize-1.5-0ae6d84.tar.gz"
KEYWORDS="*"

LICENSE="GPL-2+ GPL-2"
IUSE="debug"
SLOT="0"

DEPEND="sys-fs/btrfs-progs"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/kilobyte-compsize* "${S}" || die
	fi
}

src_prepare() {
	default
	# Don't try to install a gzipped manfile during emake install
	sed -i -e $'s/\.gz//' -e $'s/gzip.*/install \-Dm755 \$\< \$\@/' Makefile || die
}

src_configure() {
	tc-export CC

	use debug && append-cflags -Wall -DDEBUG -g
	default
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}