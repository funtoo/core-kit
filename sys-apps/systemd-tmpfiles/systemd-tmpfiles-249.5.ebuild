# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit flag-o-matic meson python-any-r1

DESCRIPTION="Creates, deletes and cleans up volatile and temporary files and directories"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="https://api.github.com/repos/systemd/systemd-stable/tarball/refs/tags/v249.5 -> systemd-stable-249.5.tar.gz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="*"
IUSE="selinux"

RDEPEND="
	sys-apps/acl:0=
	sys-apps/util-linux
	sys-libs/libcap:0=
	selinux? ( sys-libs/libselinux:0= )
	sys-libs/libxcrypt
	!sys-apps/opentmpfiles
	!sys-apps/systemd
"

DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	dev-util/meson
	sys-apps/coreutils
	sys-devel/gettext
	virtual/pkgconfig
"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if [[ -n ${EPREFIX} ]]; then
		ewarn "systemd-tmpfiles uses un-prefixed paths at runtime.".
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

post_src_unpack() {
	mv "${WORKDIR}"/systemd-systemd-stable-* "${S}" || die
}

src_prepare() {
	default

	python_fix_shebang tools/*.py
}

src_configure() {
	local emesonargs=(
		-Ddebug=false
		-Dstrip=false
		-Dwerror=false
		-Db_pch=false
		-Db_lto=false
		-Db_coverage=false
		-Db_staticpic=false
		-Db_asneeded=false
		-Db_pie=false
		-Db_ndebug=false
		-Db_lundef=false
		-Dbuild.cpp_rtti=false
		-Dbuild.cpp_debugstl=false
		-Dcpp_rtti=false
		-Dcpp_debugstl=false
		-Dsplit-usr=false
		-Dsplit-bin=false
		-Dlink-udev-shared=false
		-Dlink-systemctl-shared=false
		-Dlink-networkd-shared=false
		-Dlink-timesyncd-shared=false
		-Dstatic-libsystemd=false
		-Dstatic-libudev=false
		-Dstandalone-binaries=false
		-Dinitrd=false
		-Dcompat-mutable-uid-boundaries=false
		-Dnscd=false
		-Dmemory-accounting-default=false
		-Dbump-proc-sys-fs-file-max=false
		-Dbump-proc-sys-fs-nr-open=false
		-Dvalgrind=false
		-Dlog-trace=false
		-Dutmp=false
		-Dhibernate=false
		-Dldconfig=false
		-Dresolve=false
		-Defi=false
		-Dtpm=false
		-Denvironment-d=false
		-Dbinfmt=false
		-Drepart=false
		-Dcoredump=false
		-Dpstore=false
		-Doomd=false
		-Dlogind=false
		-Dhostnamed=false
		-Dlocaled=false
		-Dmachined=false
		-Dportabled=false
		-Dsysext=false
		-Duserdb=false
		-Dhomed=false
		-Dnetworkd=false
		-Dtimedated=false
		-Dtimesyncd=false
		-Dremote=false
		-Dcreate-log-dirs=false
		-Dnss-myhostname=false
		-Dnss-mymachines=false
		-Dnss-resolve=false
		-Dnss-systemd=false
		-Dfirstboot=false
		-Drandomseed=false
		-Dbacklight=false
		-Dvconsole=false
		-Dquotacheck=false
		-Dsysusers=false
		-Dtmpfiles=false
		-Dimportd=false
		-Dhwdb=false
		-Drfkill=false
		-Dxdg-autostart=false
		-Dman=false
		-Dhtml=false
		-Dtranslations=false
		-Dinstall-sysconfdir=false
		-Dadm-group=false
		-Dwheel-group=false
		-Ddefault-kill-user-processes=false
		-Dgshadow=false
		-Ddns-over-tls=false
		-Dseccomp=false
		-Dselinux=false
		-Dapparmor=false
		-Dsmack=false
		-Dpolkit=false
		-Dima=false
		-Dacl=false
		-Daudit=false
		-Dblkid=false
		-Dfdisk=false
		-Dkmod=false
		-Dpam=false
		-Dpwquality=false
		-Dmicrohttpd=false
		-Dlibcryptsetup=false
		-Dlibcurl=false
		-Didn=false
		-Dlibidn2=false
		-Dlibidn=false
		-Dlibiptc=false
		-Dqrencode=false
		-Dgcrypt=false
		-Dgnutls=false
		-Dopenssl=false
		-Dp11kit=false
		-Dlibfido2=false
		-Dtpm2=false
		-Delfutils=false
		-Dzlib=false
		-Dbzip2=false
		-Dxz=false
		-Dlz4=false
		-Dzstd=false
		-Dxkbcommon=false
		-Dpcre2=false
		-Dglib=false
		-Ddbus=false
		-Dgnu-efi=false
		-Dtests=false
		-Dslow-tests=false
		-Dfuzz-tests=false
		-Dinstall-tests=false
		-Dfexecve=false
		-Doss-fuzz=false
		-Dllvm-fuzz=false
		-Dkernel-install=false
		-Danalyze=false
		-Dbpf-framework=false
		-Derrorlogs=false
		-Dstdsplit=false
		-Drootprefix="${EPREFIX:-/}"
		-Dacl=true
		-Db_staticpic=true
		-Dtmpfiles=true
		-Dstandalone-binaries=true # this and below option does the magic
		-Dstatic-libsystemd=true
		-Dsysvinit-path=''
		$(meson_use selinux)
	)
	meson_src_configure
}

src_compile() {
	# tmpfiles and sysusers can be built as standalone and link systemd-shared in statically.
	# https://github.com/systemd/systemd/pull/16061 original implementation
	# we just need to pass -Dstandalone-binaries=true and
	# use <name>.standalone target below.
	# check meson.build for if have_standalone_binaries condition per target.
	local mytargets=(
		systemd-tmpfiles.standalone
	)
	meson_src_compile "${mytargets[@]}"
}

src_install() {
	# lean and mean installation, single binary and man-pages
	pushd "${BUILD_DIR}" > /dev/null || die
	into /
	newbin systemd-tmpfiles.standalone systemd-tmpfiles

	popd > /dev/null || die

	# service files adapter from opentmpfiles
	newinitd "${FILESDIR}"/stmpfiles-dev.initd stmpfiles-dev
	newinitd "${FILESDIR}"/stmpfiles-setup.initd stmpfiles-setup

	# same content, but install as different file
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-dev
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-setup
}

# stolen from opentmpfiles ebuild
add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_postinst() {
	if [[ -z $REPLACING_VERSIONS ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
}