# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Funtoo's configuration tool: ego, epro."
HOMEPAGE="http://www.funtoo.org/Package:Ego"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="zsh-completion"
RESTRICT="mirror"
GITHUB_REPO="$PN"
GITHUB_USER="funtoo"
GITHUB_TAG="${PVR}"
SRC_URI="https://www.github.com/${GITHUB_USER}/${GITHUB_REPO}/tarball/${GITHUB_TAG} -> ${PN}-${GITHUB_TAG}.tar.gz"

DEPEND=""
RDEPEND="=dev-lang/python-3* dev-python/appi:0/0.1"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${GITHUB_USER}-${PN}"-??????? "${S}" || die
}

src_install() {
	exeinto /usr/share/ego/modules
	doexe $S/modules/*
	insinto /usr/share/ego/modules-info
	doins $S/modules-info/*
	dobin $S/ego
	dosym ../share/ego/modules/profile.ego /usr/sbin/epro
	doman ego.1 epro.1

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/completion/zsh/_ego
	fi
}

pkg_postinst() {
	if [ ! -e $ROOT/etc/portage/repos.conf ]; then
		ln -s /var/git/meta-repo/repos.conf $ROOT/etc/portage/repos.conf
	fi
	if [ -e $ROOT/usr/share/portage/config/repos.conf ]; then
		rm -f $ROOT/usr/share/portage/config/repos.conf
	fi
}
